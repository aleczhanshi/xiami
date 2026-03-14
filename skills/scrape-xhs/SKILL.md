---
name: scrape-xhs
description: 搜索小红书笔记并总结内容、下载图片。当需要调研旅行、美食、酒店、产品等话题时使用。
allowed-tools: Bash, Read, Write, Glob, Grep
---

# 小红书搜索 + 总结 + 图片下载

搜索小红书关键词 "$ARGUMENTS"，提取高赞笔记内容并下载配图。

## 步骤

### 1. 搜索笔记
使用 `mcp__rednote-mcp__search_notes` 搜索关键词 "$ARGUMENTS"，获取：
- 笔记标题、赞数、xsec_token、笔记 ID
- 优先选 **图文笔记**（非视频），按赞数排序取 TOP 10

### 2. 提取笔记内容
对每篇高赞笔记，使用 `mcp__rednote-mcp__get_note_content` 获取：
- 正文全文
- 博主名称
- 点赞/收藏/评论数

### 3. 下载配图
使用 Playwright 脚本下载笔记中的高清图片：

**关键技术要点：**
- 需要登录 cookies：`~/.mcp/rednote/cookies.json`
- 必须用 desktop User-Agent（不能用 mobile）
- 通过网络请求拦截抓取 `sns-webpic` 域名的图片 URL
- xsec_token 从搜索结果中获取，拼接到笔记 URL

**Playwright 脚本模板：**
```python
from playwright.sync_api import sync_playwright
import json, requests, os

cookies = json.load(open(os.path.expanduser("~/.mcp/rednote/cookies.json")))
# 设置 desktop UA
# 拦截 network requests，过滤 sns-webpic 域名
# 访问 https://www.xiaohongshu.com/explore/{note_id}?xsec_token={token}
# 等待页面加载，收集图片 URL
# 下载并保存为 webp/jpg
```

### 4. 结构化总结
输出格式：
```
## 搜索结果总结：$ARGUMENTS

### 关键发现
- [3-5 条核心结论]

### 笔记详情
| 博主 | 赞数 | 核心内容 | 图片数 |
|------|------|---------|--------|
| @xxx | 1,234 | "原话引用..." | 3 |

### 下载的图片
- 保存位置：output/images/
- 命名规则：{主题}_{序号}.webp
```

## 注意事项
- 保留博主原话作为引用，标注 @博主名 和赞数
- 图文笔记的图片质量最好，视频笔记主要能拿到封面
- 如果 cookies 过期，提示用户重新登录获取
