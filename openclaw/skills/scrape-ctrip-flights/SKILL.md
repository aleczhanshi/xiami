---
name: scrape-ctrip-flights
description: 从携程查询指定日期和航线的精确机票价格。当需要查机票价格时使用。
---

# 携程机票精确价格查询

查询航线 "$ARGUMENTS" 的精确机票价格。

## 参数格式
`/scrape-ctrip-flights 深圳 胡志明 2026-04-30`
- $ARGUMENTS[0]: 出发城市
- $ARGUMENTS[1]: 到达城市
- $ARGUMENTS[2]: 出发日期 (YYYY-MM-DD)

## 步骤

### 1. 构造携程 URL
```
https://flights.ctrip.com/online/list/oneway-{出发城市代码}-{到达城市代码}?depdate={日期}
```

常用城市代码：
- 深圳 SZX / 广州 CAN / 北京 PEK / 上海 SHA
- 胡志明 SGN / 河内 HAN / 岘港 DAD / 芽庄 CXR / 富国岛 PQC

### 2. Playwright 抓取
```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto(url)
    # 等待航班列表加载（通常 class 包含 "flight-item" 或 "list-item"）
    # 提取每个航班的：航班号、航空公司、起降时间、价格
    # 价格通常在包含 "price" class 的元素内
```

### 3. 数据提取
对每个航班提取：
- 航班号（如 ZH117）
- 航空公司（深航/南航/越捷等）
- 起飞时间 → 降落时间
- **精确价格**（不要区间，要具体数字如 ¥1,298）
- 是否经停/转机

### 4. 输出格式
```
## ✈️ 航班查询结果
**航线**: 深圳 → 胡志明 · 2026-04-30

| 航班 | 航空公司 | 时间 | 价格/人 | 备注 |
|------|---------|------|---------|------|
| ZH117 | 深航 | 00:15→01:50 | ¥1,298 | ⭐最省 |
| CZ8465 | 南航 | 11:30→13:30 | ¥1,498 | |

💡 推荐：[给出最佳选择及理由]
```

## 注意事项
- **必须给精确价格**，不能给区间或估算
- 携程页面可能有反爬，必要时加等待时间、模拟滚动
- 越南国内段航班（越捷 VietJet、越南航空）需要单独查
- 如果携程抓取失败，备选方案：Trip.com 国际版
