#!/bin/bash
# One-click setup for xiami travel guide generator
# Usage: bash setup.sh

set -e
echo "🚀 Setting up xiami..."

# 1. Install Python dependencies
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt
playwright install chromium

# 2. Copy skills to Claude Code
echo "📋 Copying skills to ~/.claude/skills/..."
mkdir -p ~/.claude/skills
cp -r skills/* ~/.claude/skills/
echo "   ✅ 6 skills installed"

# 3. Setup MCP config for XHS (rednote)
echo "🔧 Setting up XHS MCP server..."
if [ ! -f ~/.claude/mcp_servers.json ]; then
    echo '{}' > ~/.claude/mcp_servers.json
fi
# Check if rednote-mcp is already configured
if ! grep -q "rednote" ~/.claude/mcp_servers.json 2>/dev/null; then
    echo ""
    echo "⚠️  XHS MCP server needs manual setup:"
    echo "   1. Install: npm install -g rednote-mcp"
    echo "   2. Add to ~/.claude/mcp_servers.json:"
    echo '   {"rednote-mcp": {"command": "rednote-mcp", "args": []}}'
    echo "   3. Login to XHS and export cookies:"
    echo "      python3 -c \""
    echo "      from playwright.sync_api import sync_playwright"
    echo "      import json, os"
    echo "      with sync_playwright() as p:"
    echo "          browser = p.chromium.launch(headless=False)"
    echo "          page = browser.new_page()"
    echo "          page.goto('https://www.xiaohongshu.com')"
    echo "          input('Login in browser, then press Enter...')"
    echo "          cookies = page.context.cookies()"
    echo "          os.makedirs(os.path.expanduser('~/.mcp/rednote'), exist_ok=True)"
    echo "          json.dump(cookies, open(os.path.expanduser('~/.mcp/rednote/cookies.json'), 'w'))"
    echo "          browser.close()\""
    echo ""
else
    echo "   ✅ rednote MCP already configured"
fi

# 4. Verify
echo ""
echo "✅ Setup complete! To start:"
echo "   cd $(pwd)"
echo "   claude"
echo ""
echo "Try these commands in Claude Code:"
echo '   /scrape-xhs 曼谷美食攻略'
echo '   /scrape-ctrip-flights 上海 曼谷 2026-10-01'
echo '   /build-slides 曼谷美食之旅'
