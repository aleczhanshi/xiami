# xiami 🦐 — AI-Powered Travel Guide Generator

> 给一个目的地和日期，自动调研小红书、查机票酒店实价、生成带地图的 HTML 攻略

**Choose your platform / 选择你的平台：**

| Platform | Setup | README |
|---|---|---|
| 🤖 **Claude Code** | `bash setup.sh` | 👇 You are here |
| 🦞 **OpenClaw** | `bash openclaw/setup.sh` | [openclaw/README.md](openclaw/README.md) |

## What This Project Does

Given a destination and dates, this toolkit can:

1. **Research** — Search Xiaohongshu (XHS/RED) for blogger recommendations, extract quotes and download photos
2. **Price** — Scrape exact flight prices from Ctrip and hotel prices from Trip.com/Booking.com
3. **Plan** — Generate optimized daily itineraries with Google Maps route links
4. **Build** — Create interactive HTML presentations with Leaflet maps, food grids, budget tables
5. **Deploy** — Upload to any server via SCP + nginx

## Demo

The `output/` folder contains a complete Vietnam food travel guide:
- `vietnam-food-guide.html` — Desktop version (scroll-snap slides + interactive maps)
- `vietnam-food-mobile.html` — Mobile version (landscape screenshots for WeChat articles)

## Skills (6 Reusable Claude Code Skills)

Copy `skills/` to `~/.claude/skills/` to use them in any project.

| Skill | Command | What It Does |
|---|---|---|
| `scrape-xhs` | `/scrape-xhs 富国岛美食` | Search XHS, summarize top notes, download images |
| `summarize-xhs-note` | `/summarize-xhs-note <url>` | Summarize a single XHS note by link |
| `scrape-ctrip-flights` | `/scrape-ctrip-flights 深圳 胡志明 2026-04-30` | Get exact flight prices from Ctrip |
| `scrape-hotel-prices` | `/scrape-hotel-prices 希尔顿 岘港 2026-04-30 2026-05-04` | Get exact hotel prices + availability |
| `build-slides` | `/build-slides 越南旅行攻略` | Generate HTML slide presentation |
| `plan-route` | `/plan-route 胡志明 Day2: Pho Viet Nam, 大教堂, Coffee` | Generate map routes with distances |

## Memory System (Best Practices)

The `memory/` folder contains hard-won lessons from iterative development:

### Presentation Rules (`feedback_presentation.md`) — 10 Rules
1. Images must match text content — never use random photos
2. Fill every page — no empty space
3. Give clear recommendations — don't just list options
4. Exact prices only — no ranges
5. Don't lose core content when optimizing details
6. Use light background (white/off-white)
7. Font sizes: bigger is better, especially on mobile
8. Balance overflow vs. fill — use `overflow-y:auto` as safety net
9. Navigation should be visible but not block content
10. Keep numbering sequential after deletions

### Workflow Rules (`feedback_workflow.md`) — 10 Rules
1. Always visit detail pages for prices — search page prices are fake
2. Download hotel images from booking platforms directly
3. Background agents shouldn't run too long (< 5 min)
4. Ship first, optimize later
5. Check all modules after major rewrites
6. Image filenames from scrapers are unreliable — always visually verify
7. `onerror` handlers hide problems — don't use during development
8. Always `ls` to confirm actual filenames before referencing
9. Global find-replace needs grep verification for edge cases
10. Price unit changes (per-person vs total) must be updated everywhere

## Tech Stack

- **Claude Code** — AI agent orchestration
- **Playwright** — Browser automation for scraping
- **Leaflet.js** — Interactive maps (no API key needed)
- **OpenStreetMap** — Map tiles (free)
- **XHS MCP** — Xiaohongshu search integration
- **Pure HTML/CSS/JS** — No frameworks, single-file output

## Prerequisites

### 1. Claude Code CLI
```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code
```

### 2. Python + Playwright (for web scraping)
```bash
pip install playwright
playwright install chromium
```

### 3. XHS (Xiaohongshu) MCP Server + Cookies
The `/scrape-xhs` skill requires the rednote MCP server and login cookies:

```bash
# Install rednote MCP server (see https://github.com/anthropics/claude-code for MCP setup)
# Then login to XHS and export cookies:

# Option A: Use browser extension "EditThisCookie" to export cookies from xiaohongshu.com
# Save as JSON to: ~/.mcp/rednote/cookies.json

# Option B: Use Playwright to login and save cookies programmatically
python3 -c "
from playwright.sync_api import sync_playwright
import json, os
with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    page = browser.new_page()
    page.goto('https://www.xiaohongshu.com')
    input('Login in browser, then press Enter...')
    cookies = page.context.cookies()
    os.makedirs(os.path.expanduser('~/.mcp/rednote'), exist_ok=True)
    json.dump(cookies, open(os.path.expanduser('~/.mcp/rednote/cookies.json'), 'w'))
    print(f'Saved {len(cookies)} cookies')
    browser.close()
"
```

### 4. Server for deployment (optional)
Any server with nginx. The skills use `scp` + nginx static hosting.

## Quick Start

```bash
# 1. Clone and setup (one command)
git clone https://github.com/aleczhanshi/xiami.git
cd xiami
bash setup.sh

# 2. Start Claude Code
claude

# That's it! Skills are auto-registered, CLAUDE.md is auto-loaded.
```

### What `setup.sh` does:
- Installs Python dependencies (`playwright`, `requests`)
- Installs Chromium browser for Playwright
- Copies 6 skills to `~/.claude/skills/`
- Checks if XHS MCP server is configured (gives instructions if not)

## Example: Build a Travel Guide from Scratch

```bash
# Step 1: Research food recommendations
> /scrape-xhs 曼谷美食攻略

# Step 2: Get flight prices
> /scrape-ctrip-flights 上海 曼谷 2026-10-01

# Step 3: Get hotel prices
> /scrape-hotel-prices 曼谷万豪 曼谷 2026-10-01 2026-10-05

# Step 4: Generate the presentation
> /build-slides 曼谷美食之旅

# Step 5: Add route maps
> /plan-route 曼谷 Day1: Chatuchak Market, Wat Phra Kaew, Khao San Road

# Step 6: Deploy (optional)
> scp -r output/* your-server:/var/www/guide/
```

## How It Works

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  /scrape-xhs │────▶│  Structured  │────▶│ /build-slides│
│  /scrape-    │     │  Data (JSON/ │     │             │
│   ctrip-     │     │  Markdown)   │     │  HTML + CSS │
│   flights    │     │              │     │  + Leaflet  │
│  /scrape-    │     │  + Images    │     │  + Maps     │
│   hotel-     │     │              │     │             │
│   prices     │     └──────────────┘     └──────┬──────┘
└─────────────┘                                  │
                                                 ▼
┌─────────────┐                          ┌──────────────┐
│ /plan-route  │─────────────────────────▶│  Final HTML  │
│              │  Leaflet.js maps         │  (Desktop +  │
└─────────────┘                          │   Mobile)    │
                                         └──────────────┘
```

## License

MIT
