# xiami — OpenClaw Edition

> AI-powered travel guide generator for [OpenClaw](https://github.com/openclaw/openclaw)

This is the OpenClaw-compatible version of xiami. For the Claude Code version, see the [root README](../README.md).

## Differences from Claude Code Version

| | Claude Code | OpenClaw |
|---|---|---|
| Skills location | `~/.claude/skills/` | `~/.openclaw/skills/` |
| Project context | `CLAUDE.md` | `AGENTS.md` (in workspace) |
| Memory | `~/.claude/projects/.../memory/` | `~/.openclaw/workspace/memory/` |
| Frontmatter | `allowed-tools`, `context`, `agent` | `name`, `description` only |

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/aleczhanshi/xiami.git
cd xiami

# 2. One-click setup for OpenClaw
bash openclaw/setup.sh

# This will:
# - Install Python + Playwright
# - Copy 6 skills to ~/.openclaw/skills/
# - Copy AGENTS.md to ~/.openclaw/workspace/
# - Copy memory/*.md to ~/.openclaw/workspace/memory/

# 3. Start OpenClaw and use skills
/scrape-xhs 曼谷美食攻略
/scrape-ctrip-flights 上海 曼谷 2026-10-01
/build-slides 曼谷美食之旅
```

## File Mapping

```
openclaw/
├── README.md              ← You are here
├── setup.sh               ← One-click installer
├── AGENTS.md              ← → ~/.openclaw/workspace/AGENTS.md
├── skills/                ← → ~/.openclaw/skills/
│   ├── scrape-xhs/SKILL.md
│   ├── summarize-xhs-note/SKILL.md
│   ├── scrape-ctrip-flights/SKILL.md
│   ├── scrape-hotel-prices/SKILL.md
│   ├── build-slides/SKILL.md
│   └── plan-route/SKILL.md
└── memory/                ← → ~/.openclaw/workspace/memory/
    ├── MEMORY.md
    ├── feedback_presentation.md   (10 presentation rules)
    ├── feedback_workflow.md       (10 workflow rules)
    ├── reference_capabilities.md  (7 capabilities)
    └── user_profile_example.md    (customize for yourself)
```

## Skills

| Skill | Command | What It Does |
|---|---|---|
| `scrape-xhs` | `/scrape-xhs 富国岛美食` | Search XHS, summarize, download images |
| `summarize-xhs-note` | `/summarize-xhs-note <url>` | Summarize single XHS note |
| `scrape-ctrip-flights` | `/scrape-ctrip-flights 深圳 胡志明 2026-04-30` | Exact flight prices |
| `scrape-hotel-prices` | `/scrape-hotel-prices 希尔顿 岘港 2026-04-30 2026-05-04` | Hotel prices + images |
| `build-slides` | `/build-slides 越南旅行攻略` | HTML slide presentation |
| `plan-route` | `/plan-route 胡志明 Day2: Pho, Cathedral, Coffee` | Leaflet.js map routes |

## Prerequisites

1. **OpenClaw** installed and running
2. **Python 3** + Playwright:
   ```bash
   pip install playwright requests
   playwright install chromium
   ```
3. **XHS cookies** (for `/scrape-xhs`):
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
       os.makedirs(os.path.expanduser('~/.mcp/rednote'), exist_ok=True)
       json.dump(cookies, open(os.path.expanduser('~/.mcp/rednote/cookies.json'), 'w'))
       browser.close()
   "
   ```

## Demo Output

The `output/` folder (in repo root) contains a complete Vietnam food guide:
- `vietnam-food-guide.html` — Desktop (scroll-snap + Leaflet maps)
- `vietnam-food-mobile.html` — Mobile (landscape screenshots)
