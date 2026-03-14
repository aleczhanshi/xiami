# u-life: AI-Powered Travel Guide Generator

Use Claude Code + custom Skills to automatically research, plan, and generate beautiful travel guides.

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

- [Claude Code](https://claude.ai/code) CLI installed
- Python 3 + Playwright (`pip install playwright && playwright install`)
- XHS login cookies at `~/.mcp/rednote/cookies.json` (for XHS scraping)
- A server with nginx for deployment (optional)

## Quick Start

```bash
# 1. Copy skills to your Claude Code
cp -r skills/* ~/.claude/skills/

# 2. Copy memory/feedback rules (optional but recommended)
mkdir -p ~/.claude/projects/$(pwd | sed 's|/|-|g')/memory
cp memory/*.md ~/.claude/projects/$(pwd | sed 's|/|-|g')/memory/

# 3. Start Claude Code and use the skills
claude

# Example: research food in Ho Chi Minh City
> /scrape-xhs 胡志明美食攻略

# Example: check flight prices
> /scrape-ctrip-flights 深圳 胡志明 2026-04-30

# Example: build a presentation from your research
> /build-slides 越南美食之旅
```

## License

MIT
