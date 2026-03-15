#!/bin/bash
# One-click setup for xiami on OpenClaw
# Usage: bash openclaw/setup.sh

set -e
echo "🦞 Setting up xiami for OpenClaw..."

# 1. Install Python dependencies
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt
playwright install chromium

# 2. Copy skills to OpenClaw
SKILL_DIR="${OPENCLAW_SKILLS_DIR:-$HOME/.openclaw/skills}"
echo "📋 Copying skills to $SKILL_DIR..."
mkdir -p "$SKILL_DIR"
cp -r openclaw/skills/* "$SKILL_DIR/"
echo "   ✅ 6 skills installed"

# 3. Copy AGENTS.md to workspace
WORKSPACE="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}"
echo "📝 Copying AGENTS.md to $WORKSPACE..."
mkdir -p "$WORKSPACE"
cp openclaw/AGENTS.md "$WORKSPACE/AGENTS.md"
echo "   ✅ AGENTS.md installed"

# 4. Copy memory files
MEMORY_DIR="$WORKSPACE/memory"
echo "🧠 Copying memory files to $MEMORY_DIR..."
mkdir -p "$MEMORY_DIR"
cp openclaw/memory/*.md "$MEMORY_DIR/"
echo "   ✅ Memory files installed"

# 5. XHS MCP setup hint
echo ""
echo "⚠️  XHS scraping requires login cookies:"
echo "   mkdir -p ~/.mcp/rednote"
echo "   # Then run the cookie export script in README"
echo ""
echo "✅ Setup complete! Start OpenClaw and try:"
echo '   /scrape-xhs 曼谷美食攻略'
echo '   /scrape-ctrip-flights 上海 曼谷 2026-10-01'
echo '   /build-slides 曼谷美食之旅'
