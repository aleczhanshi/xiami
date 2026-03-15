---
name: data-scraping-and-presentation-capabilities
description: Proven capabilities for scraping XHS/Ctrip/Booking, extracting images, building HTML presentations, and deploying to servers — validated in the Vietnam travel guide project (2026-03)
type: reference
---

## 已验证的核心能力（越南攻略项目实战）

### 1. 小红书（XHS）内容搜索与总结

**工具链**: `mcp__rednote-mcp__search_notes` → `Playwright` 内容提取 + 图片下载

- **搜索**: MCP 工具按关键词搜笔记，获取标题、赞数、xsec_token
- **内容提取**: 访问笔记页 → `window.__INITIAL_STATE__` 解析正文/博主名/互动数据
- **图片下载**: 需要登录 cookies (`~/.mcp/rednote/cookies.json`) + desktop UA + 网络请求拦截 `sns-webpic` 域名
- **总结**: 从多篇笔记提炼结构化信息，保留博主原话作引用
- **脚本位置**: `scripts/extract_xhs_images.py`, `scripts/extract_xhs_images_batch2.py`

### 2. 携程/Trip.com 机票价格查询

**工具**: Playwright 自动化

- 携程航班搜索页，指定城市 + 日期
- 提取航班号、起降时间、精确票价（非区间）
- 可同时查国际段和越南国内段（越捷 VietJet 等廉航）
- **脚本位置**: `ctrip_scrape.py`

### 3. 酒店价格与可用性查询

**工具**: Playwright → Trip.com / Booking.com

- 按酒店 ID 或名称 + 精确入住/退房日期
- 提取: 精确每晚价格、总价、房型名称、剩余房间数
- 能发现已订满/低库存的关键信息
- 多平台对比取最可靠数据
- **脚本位置**: `ctrip_hotels.py`

### 4. 酒店/景点图片抓取

**来源**: Booking.com (`#photo_wrapper` 或 `og:image`) / XHS 笔记

- Booking.com: 按酒店 URL 抓主图，1024px+ 高清
- XHS: 用 cookies + xsec_token + 网络拦截抓图文笔记原图

### 5. HTML 幻灯片制作

**技术**: 纯 HTML/CSS/JS，无框架依赖

- `scroll-snap-type: y mandatory` 全屏翻页
- `IntersectionObserver` 触发 reveal 动画
- `clamp()` 响应式字号
- `flex:1 + justify-content: space-evenly` 内容铺满
- 进度条 + 导航圆点 + 键盘翻页
- 暗色系设计 + Google Fonts (Cormorant + IBM Plex Sans)

### 6. 云服务器部署

**配置**: `~/.ssh/config` → Host `your-server` (your-server-ip, root, PEM key)

- `scp -r` 上传 → nginx 静态托管
- 文件位置: `/var/www/vietnam-guide/` → symlink 到 nginx html 目录
- 注意: 安全组只开了 80/8888 端口，其他端口外网不可访问

### 7. 多任务并行模式

- 后台 Agent 跑耗时任务（图片抓取 ~6min, 价格查询 ~22min）
- 前台同时编辑 HTML / 部署 / 响应用户
- 多个 Edit 调用可并行修改不同代码段
