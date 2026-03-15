# xiami 🦐 — OpenClaw Edition 🦞

> AI 旅行攻略生成器，OpenClaw 版本。给一个目的地，自动出攻略。

## 30 秒上手

```bash
# 1. 克隆
git clone https://github.com/aleczhanshi/xiami.git
cd xiami

# 2. 一键安装（装依赖 + 注册 Skills + 配置 AGENTS.md + 复制 Memory）
bash openclaw/setup.sh

# 3. 启动 OpenClaw，开始用
/scrape-xhs 曼谷美食攻略
```

就这三步。下面是详细说明。

---

## setup.sh 做了什么

| 步骤 | 干了什么 | 装到哪里 |
|---|---|---|
| ① 装 Python 依赖 | `pip install playwright requests` + `playwright install chromium` | 系统 Python |
| ② 注册 6 个 Skills | 复制 `openclaw/skills/*` | `~/.openclaw/skills/` |
| ③ 配置 AGENTS.md | 复制 `openclaw/AGENTS.md` | `~/.openclaw/workspace/AGENTS.md` |
| ④ 导入 Memory | 复制 `openclaw/memory/*.md` | `~/.openclaw/workspace/memory/` |

安装后你的 OpenClaw 目录结构变成：

```
~/.openclaw/
├── skills/                          ← 6 个 Skills 在这里
│   ├── scrape-xhs/SKILL.md         ← 搜小红书
│   ├── summarize-xhs-note/SKILL.md ← 总结单篇笔记
│   ├── scrape-ctrip-flights/SKILL.md ← 查机票
│   ├── scrape-hotel-prices/SKILL.md  ← 查酒店
│   ├── build-slides/SKILL.md       ← 生成 HTML
│   └── plan-route/SKILL.md         ← 地图路线
└── workspace/
    ├── AGENTS.md                    ← 项目上下文（自动加载）
    └── memory/
        ├── MEMORY.md                ← 索引
        ├── feedback_presentation.md ← 10 条展示铁律
        ├── feedback_workflow.md     ← 10 条流程经验
        └── reference_capabilities.md ← 能力清单
```

---

## 6 个 Skills 详解

### 1. `/scrape-xhs` — 搜小红书

```bash
/scrape-xhs 富国岛美食
```

做什么：搜索小红书 → 提取 TOP 10 高赞笔记 → 下载配图 → 输出结构化总结（餐厅名+价格+博主引用）

**前置条件**：需要小红书登录 cookies（见下方"XHS Cookies 获取方法"）

### 2. `/summarize-xhs-note` — 总结单篇笔记

```bash
/summarize-xhs-note https://www.xiaohongshu.com/explore/xxxxx
```

做什么：给一个小红书链接，提取正文/博主名/赞数，输出结构化摘要

### 3. `/scrape-ctrip-flights` — 查机票

```bash
/scrape-ctrip-flights 深圳 胡志明 2026-04-30
```

做什么：用 Playwright 打开携程 → 提取所有航班的航班号+时间+**精确价格**（不是区间）

### 4. `/scrape-hotel-prices` — 查酒店

```bash
/scrape-hotel-prices 希尔顿花园 岘港 2026-04-30 2026-05-04
```

做什么：在 Trip.com/Booking.com 搜酒店 → 提取精确价格+房型+剩余房间数 → 下载酒店主图

### 5. `/build-slides` — 生成 HTML 攻略

```bash
/build-slides 越南美食之旅
```

做什么：从调研数据生成 scroll-snap 翻页式 HTML 幻灯片，白底、大字、图文对应、有推荐、有预算表

### 6. `/plan-route` — 生成地图路线

```bash
/plan-route 胡志明 Day2: Pho Viet Nam, 西贡大教堂, The Workshop Coffee
```

做什么：用 Leaflet.js + OpenStreetMap 生成交互地图，标记景点/餐厅/酒店/机场，画路线，标距离

---

## XHS Cookies 获取方法

`/scrape-xhs` 需要小红书登录态。两种方式获取：

### 方式 A：浏览器插件（推荐）

1. Chrome 安装 [EditThisCookie](https://chrome.google.com/webstore/detail/editthiscookie/fngmhnnpilhplaeedifhccceomclgfbg) 扩展
2. 打开 https://www.xiaohongshu.com 并登录
3. 点击 EditThisCookie 图标 → 导出为 JSON
4. 保存到 `~/.mcp/rednote/cookies.json`

### 方式 B：Playwright 脚本

```bash
mkdir -p ~/.mcp/rednote
python3 -c "
from playwright.sync_api import sync_playwright
import json, os
with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    page = browser.new_page()
    page.goto('https://www.xiaohongshu.com')
    input('Login in browser, then press Enter...')
    cookies = page.context.cookies()
    path = os.path.expanduser('~/.mcp/rednote/cookies.json')
    json.dump(cookies, open(path, 'w'))
    print(f'Saved {len(cookies)} cookies to {path}')
    browser.close()
"
```

---

## 完整使用示例：从零做一份曼谷攻略

```bash
# Step 1: 调研美食
/scrape-xhs 曼谷美食攻略
# → 输出 TOP 10 餐厅 + 下载 15-20 张美食图

# Step 2: 查机票
/scrape-ctrip-flights 上海 曼谷 2026-10-01
# → 输出每个航班的精确价格

# Step 3: 查酒店
/scrape-hotel-prices 曼谷万豪 曼谷 2026-10-01 2026-10-05
# → 输出精确每晚价格 + 下载酒店图

# Step 4: 生成 HTML 攻略
/build-slides 曼谷美食之旅
# → 生成 output/bangkok-food-guide.html

# Step 5: 加地图
/plan-route 曼谷 Day1: Chatuchak Market, Wat Phra Kaew, Khao San Road
# → 在 HTML 里嵌入 Leaflet 交互地图

# Step 6: 部署（可选）
scp -r output/* your-server:/var/www/guide/
```

---

## 和 Claude Code 版的区别

| | Claude Code | OpenClaw |
|---|---|---|
| Skills 路径 | `~/.claude/skills/` | `~/.openclaw/skills/` |
| 项目上下文 | `CLAUDE.md`（项目根目录） | `AGENTS.md`（workspace 目录） |
| Memory 路径 | `~/.claude/projects/.../memory/` | `~/.openclaw/workspace/memory/` |
| SKILL.md frontmatter | 支持 `allowed-tools`, `context: fork` | 只用 `name`, `description` |
| 安装脚本 | `bash setup.sh` | `bash openclaw/setup.sh` |

如果你同时用 Claude Code 和 OpenClaw，两套可以共存，互不影响。

---

## Demo

`output/` 目录有完整的越南美食攻略 Demo：
- `vietnam-food-guide.html` — 电脑版（scroll-snap + Leaflet 地图 + 预算表）
- `vietnam-food-mobile.html` — 手机横屏版（适合截图发公众号）

直接用浏览器打开就能看效果。

---

## 常见问题

**Q: 搜小红书报错 "cookies expired"**
A: Cookies 有效期约 30 天，过期后重新登录导出即可。

**Q: 携程/Booking 抓取失败**
A: 这些网站有反爬机制，Playwright 有时需要等待更久。技巧：加 `page.wait_for_timeout(5000)` 等待加载。

**Q: HTML 里的图片显示不出来**
A: 检查 `output/images/` 里的文件名和 HTML 里引用的路径是否一致。用 `ls output/images/` 确认实际文件名。

**Q: 地图不显示**
A: Leaflet.js 需要联网加载 CDN。离线环境无法使用。
