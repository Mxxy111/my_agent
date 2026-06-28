---
name: obsidian-feed
description: Send processed content (PDF summaries, literature notes, project updates, web clippings) to the Obsidian vault's "外部投喂" inbox folder via Obsidian CLI. Use when the user asks to summarize a PDF, extract content, or feed/send/push notes to Obsidian, or when 外部投喂 is mentioned.
---

# Obsidian Feed — 外部投喂工作流

通过 Obsidian CLI 将外部整理的内容写入 vault 的 `外部投喂/` 收件箱文件夹。

## 环境

| 项 | 值 |
|----|-----|
| CLI | `D:\obsidian\Obsidian.com` |
| Vault | `Asukas respository` |
| Vault 路径 | `D:\obsidian\repo\Asukas respository` |
| 投喂目标 | `外部投喂/` |

> 需要 Obsidian 正在运行。用 `obsidian vault` 验证连接。

## 核心命令

```powershell
# 创建笔记
& "D:\obsidian\Obsidian.com" create path="外部投喂/<文件名>.md" content="<markdown>" silent

# 追加到已有笔记
& "D:\obsidian\Obsidian.com" append path="外部投喂/<文件名>.md" content="<追加内容>"

# 读取验证
& "D:\obsidian\Obsidian.com" read path="外部投喂/<文件名>.md"

# 搜索投喂内容
& "D:\obsidian\Obsidian.com" search query="<关键词>" path="外部投喂"

# 列出已有文件
& "D:\obsidian\Obsidian.com" files path="外部投喂"
```

## 笔记模板

```markdown
---
type: inbox
title: <标题>
source_type: <PDF|网页|论文|项目|其他>
original: <原始文件名或 URL>
created: <YYYY-MM-DD HH:mm>
processed: false
processed_at:
target:
  - <医学知识库|英语学习库|AI知识库|书库|research|其他>
tags:
  - 外部投喂
  - <领域标签>
---

# <标题>

## 摘要

<一段话概括>

## 要点

- <要点>

## 详细内容

<正文>

---
*由 <工具名称> 投喂 · <日期>*
```

## 工作流程

1. **读取源材料** — PDF / 网页 / 文本
2. **整理为 markdown** — 填充上方模板，保留关键结构
3. **命名** — `<YYYY-MM-DD>-<简短标题>.md`（如 `2026-05-26-RCC分期综述.md`）
4. **写入**：
   ```powershell
   & "D:\obsidian\Obsidian.com" create path="外部投喂/2026-05-26-RCC分期综述.md" content="---`ntype: inbox`ntitle: RCC 分期综述`nsource_type: PDF`noriginal: xxx.pdf`ncreated: 2026-05-26 13:00`nprocessed: false`nprocessed_at:`ntarget:`n  - 医学知识库`ntags:`n  - 外部投喂`n  - 医学`n---`n`n# RCC 分期综述`n`n## 摘要`n`n..." silent
   ```
5. **验证** — `read` 确认内容完整
6. **分流** — 用户复核后，把内容沉淀到目标知识库，并将投喂页改为 `processed: true`

## 长内容处理

CLI 单次 `content` 参数有长度限制。超长内容策略：

1. **分段 append**：先 `create` 写入 frontmatter + 摘要，再分段 `append` 正文
2. **直接写文件**：直接写入 vault 文件系统路径
   ```powershell
   Set-Content -Path "D:\obsidian\repo\Asukas respository\外部投喂\<文件名>.md" -Value $content -Encoding UTF8
   ```

## PowerShell 转义

| 场景 | 写法 |
|------|------|
| 换行 | `` `n `` |
| 制表符 | `` `t `` |
| 双引号 | `` `" `` 或用单引号包裹 |
| 反引号本身 | ``` `` ``` |

## 子文件夹组织

当投喂量增大时，可在 `外部投喂/` 下建子文件夹：

```powershell
& "D:\obsidian\Obsidian.com" create path="外部投喂/文献/<文件名>.md" content="..." silent
& "D:\obsidian\Obsidian.com" create path="外部投喂/项目/<文件名>.md" content="..." silent
```

## 配合其他 Obsidian Skills

- 用 **obsidian-markdown** skill 的语法（wikilinks、callouts、embeds）丰富笔记格式
- 用 **obsidian-cli** skill 的高级命令（property:set、tags、backlinks）管理元数据
- 用 **obsidian-bases** skill 创建投喂内容的数据库视图
