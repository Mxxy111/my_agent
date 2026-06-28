#!/usr/bin/env python3
"""Register a Mihomo/Clash subscription as a ClashTui URL profile.

The subscription URL is read from a mode-0600 file and is never printed.
Designed for a fresh ClashTui setup. Existing non-empty databases require
--force to avoid silently overwriting a user's profiles.
"""

from __future__ import annotations

import argparse
import base64
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path
from urllib.request import Request, build_opener, ProxyHandler


HOME = Path.home()
CONFIG_DIR = HOME / ".config" / "clashtui"
DB_PATH = CONFIG_DIR / "clashtui.db"
PROFILES_DIR = CONFIG_DIR / "mihomo" / "profiles"
CORE_CONFIG = Path("/opt/clashtui/mihomo/config/config.yaml")


def run(cmd: list[str], *, check: bool = True, input_text: str | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        cmd,
        text=True,
        input=input_text,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=check,
    )


def read_secret_url(path: Path) -> str:
    st = path.stat()
    if st.st_mode & 0o077:
        raise SystemExit(f"Refusing to read {path}: permissions must be 0600 or stricter")
    value = path.read_text(encoding="utf-8").strip()
    if not value.startswith(("http://", "https://")):
        raise SystemExit("Subscription file does not contain an HTTP(S) URL")
    return value


def fetch_subscription(url: str, proxy: str | None) -> bytes:
    handlers = []
    if proxy:
        handlers.append(ProxyHandler({"http": proxy, "https": proxy}))
    opener = build_opener(*handlers)
    req = Request(url, headers={"User-Agent": "Clash.Meta"})
    with opener.open(req, timeout=45) as resp:
        data = resp.read()
    if len(data) < 100:
        raise SystemExit("Downloaded subscription is unexpectedly small")
    return data


def looks_like_yaml(data: bytes) -> bool:
    sample = data[:4096].decode("utf-8", errors="ignore")
    return any(token in sample for token in ("proxies:", "proxy-providers:", "mixed-port:", "port:"))


def db_is_empty() -> bool:
    if not DB_PATH.exists():
        return True
    text = DB_PATH.read_text(encoding="utf-8", errors="ignore")
    return "profiles: {}" in text and "cur_profile:" not in text


def write_db(profile_name: str, url: str) -> None:
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    if DB_PATH.exists():
        backup = DB_PATH.with_name(f"{DB_PATH.name}.backup-{time.strftime('%Y%m%d-%H%M%S')}")
        shutil.copy2(DB_PATH, backup)
        os.chmod(backup, 0o600)
    # YAML string uses base64 to avoid escaping the secret URL through shell.
    encoded_url = base64.b64encode(url.encode("utf-8")).decode("ascii")
    decoded = base64.b64decode(encoded_url).decode("utf-8")
    content = (
        "core_type: mihomo\n"
        "mihomo:\n"
        f"  cur_profile: {profile_name}\n"
        "  profiles:\n"
        f"    {profile_name}:\n"
        f"      dtype: !Url '{decoded}'\n"
        "      no_pp: false\n"
        "singbox:\n"
        "  profiles: {}\n"
    )
    DB_PATH.write_text(content, encoding="utf-8")
    os.chmod(DB_PATH, 0o600)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--profile", default="wazhua", help="ClashTui profile name")
    parser.add_argument("--url-file", required=True, type=Path, help="mode-0600 file containing subscription URL")
    parser.add_argument("--proxy", default=os.environ.get("BOOTSTRAP_PROXY"))
    parser.add_argument("--force", action="store_true", help="replace an existing non-empty ClashTui DB")
    args = parser.parse_args()

    if os.geteuid() == 0:
        raise SystemExit("Run as the normal SSH user, not root")

    url = read_secret_url(args.url_file.expanduser())
    data = fetch_subscription(url, args.proxy)
    if not looks_like_yaml(data):
        raise SystemExit("Subscription did not look like Mihomo/Clash YAML")

    if not db_is_empty() and not args.force:
        raise SystemExit(f"{DB_PATH} already contains profiles. Re-run with --force after backing it up.")

    write_db(args.profile, url)

    PROFILES_DIR.mkdir(parents=True, exist_ok=True)
    profile_path = PROFILES_DIR / f"{args.profile}.yaml"
    profile_path.write_bytes(data)
    os.chmod(profile_path, 0o600)

    print(f"profile_registered={args.profile}")
    update = run(["clashtui", "profile", "update", "--name", args.profile], check=False)
    if update.returncode != 0:
        print("WARN: profile update failed; using already downloaded local YAML.", file=sys.stderr)

    select = run(["clashtui", "profile", "select", "--name", args.profile], check=True)
    print(select.stdout.strip())

    test = run(["sudo", "-u", "mihomo", "/opt/clashtui/mihomo/mihomo", "-t", "-d", "/opt/clashtui/mihomo/config"])
    print(test.stdout.strip())

    run(["sudo", "systemctl", "enable", "--now", "clashtui_mihomo"])

    explicit = run(
        [
            "curl",
            "-x",
            "http://127.0.0.1:7890",
            "-L",
            "-o",
            "/dev/null",
            "-sS",
            "--connect-timeout",
            "8",
            "--max-time",
            "25",
            "-w",
            "%{http_code}",
            "https://api.openai.com/v1/models",
        ],
        check=False,
    )
    print(f"openai_via_explicit_proxy={explicit.stdout.strip()}")
    if explicit.stdout.strip() not in {"401", "403"}:
        raise SystemExit("Explicit proxy did not reach OpenAI as expected")

    if CORE_CONFIG.exists():
        run(["sudo", "chown", "mihomo:mihomo", str(CORE_CONFIG)], check=False)
        run(["sudo", "chmod", "660", str(CORE_CONFIG)], check=False)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
