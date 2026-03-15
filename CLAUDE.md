# CLAUDE.md

## Project Overview

This is a toolkit for generating AI-powered travel guides using Claude Code. It combines web scraping (XHS, Ctrip, Booking.com), data analysis, and HTML presentation generation.

## Available Skills

6 skills are registered in `skills/` directory:
- `/scrape-xhs` — Search Xiaohongshu and summarize + download images
- `/summarize-xhs-note` — Summarize a single XHS note by URL
- `/scrape-ctrip-flights` — Get exact flight prices from Ctrip
- `/scrape-hotel-prices` — Get exact hotel prices from Trip.com/Booking.com
- `/build-slides` — Generate HTML slide presentations
- `/plan-route` — Generate map routes with Leaflet.js

## Quality Standards

See `memory/feedback_presentation.md` for 10 presentation rules and `memory/feedback_workflow.md` for 10 workflow rules. Key principles:
- Images must match text content — verify visually before using
- Give clear recommendations, not just options
- Use exact prices, not ranges
- Use white/light backgrounds
- Large fonts, fill every page

## How to Use

1. Pick a destination and dates
2. Run `/scrape-xhs` to research blogger recommendations
3. Run `/scrape-ctrip-flights` to get flight prices
4. Run `/scrape-hotel-prices` to get hotel prices + images
5. Run `/build-slides` to generate the HTML presentation
6. Run `/plan-route` to add interactive maps
