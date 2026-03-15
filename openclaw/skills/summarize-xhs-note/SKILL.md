---
name: summarize-xhs-note
description: 给定小红书笔记链接，提取内容并总结。当用户分享小红书链接并要求总结时使用。
---

# 小红书笔记总结

用户提供小红书笔记链接 "$ARGUMENTS"，提取完整内容并生成结构化总结。

## 步骤

### 1. 解析链接
从用户提供的链接中提取笔记 ID：
- 完整链接格式：`https://www.xiaohongshu.com/explore/{note_id}` 或 `https://www.xiaohongshu.com/discovery/item/{note_id}`
- 短链接格式：`https://xhslink.com/xxx` → 需要先跳转获取真实 URL
- 提取 `note_id`（通常是 24 位十六进制字符串）

### 2. 获取笔记内容
使用 `mcp__rednote-mcp__get_note_content` 传入笔记 ID，获取：
- 标题、正文
- 博主名称、粉丝数
- 点赞、收藏、评论数
- 发布时间

如果 MCP 工具不可用，使用 Playwright 备选方案：
```python
# 访问笔记页面 → 从 window.__INITIAL_STATE__ 提取数据
# 需要 cookies：~/.mcp/rednote/cookies.json
# 用 desktop UA
```

### 3. 下载配图（可选）
如果用户需要图片，使用网络请求拦截方式下载：
- 拦截 `sns-webpic` 域名的请求
- 保存到 `output/images/` 目录

### 4. 输出总结
```
## 📖 笔记总结

**博主**: @xxx · 粉丝 xx万
**互动**: 👍 xx赞 · ⭐ xx收藏 · 💬 xx评论
**发布**: 2026-xx-xx

### 核心内容
[3-5 句话总结要点]

### 关键信息提取
- [结构化的关键数据点：价格、地点、推荐等]

### 原文金句
> "博主原话引用 1"
> "博主原话引用 2"
```

## 注意事项
- 保留有价值的原话，用引用格式标注
- 提取具体的数据点（价格、地址、评分等）
- 如果是攻略类笔记，整理成可操作的清单
