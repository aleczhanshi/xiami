---
name: scrape-hotel-prices
description: 从Trip.com/Booking.com查询指定酒店在指定日期的精确价格和可用性。当需要查酒店价格时使用。
---

# 酒店精确价格与可用性查询

查询酒店 "$ARGUMENTS" 的精确价格。

## 参数格式
`/scrape-hotel-prices 希尔顿花园 岘港 2026-04-30 2026-05-04`
- $ARGUMENTS[0]: 酒店名称
- $ARGUMENTS[1]: 城市
- $ARGUMENTS[2]: 入住日期
- $ARGUMENTS[3]: 退房日期

## 步骤

### 1. 查找酒店 ID
**Trip.com（携程国际版）优先**：
- 搜索 URL：`https://www.trip.com/hotels/list?checkin={入住}&checkout={退房}&searchValue={酒店名+城市}`
- 如果已知 Ctrip 酒店 ID，直接用详情页：`https://www.trip.com/hotels/detail/?hotelId={ID}&checkIn={入住}&checkOut={退房}&adult=2&curr=CNY`

**Booking.com 备选**：
- `https://www.booking.com/hotel/vn/{slug}.html?checkin={入住}&checkout={退房}`

### 2. Playwright 抓取价格
```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto(url)
    # Trip.com: 等待房型列表加载
    # 查找包含 "Total price" 或 "CNY" 的元素
    # 提取最便宜房型的：房型名、每晚价格、总价
    # 注意区分含早/不含早的价格
```

### 3. 提取信息
对每个酒店获取：
- 酒店名称（确认是正确的酒店）
- **精确每晚价格**（CNY）
- **总价**（含税费）
- 最便宜可用房型名称
- 剩余房间数（如有显示）
- 是否含早餐

### 4. 同时下载酒店主图
```python
# Booking.com: 找 #photo_wrapper 内的 img 或 og:image meta 标签
# 保存为 hotel_{shortname}.jpg
```

### 5. 输出格式
```
## 🏨 酒店价格查询结果

**酒店**: 希尔顿花园酒店 · 岘港
**日期**: 2026-04-30 至 2026-05-04（4晚）

| 房型 | 每晚 | 总价 | 含早 | 剩余 |
|------|------|------|------|------|
| King Room | ¥748 | ¥3,391 | ❌ | 有房 |
| Sea View King | ¥1,050 | ¥4,620 | ✅ | ⚠️剩3间 |

💡 推荐：[给出最佳选择及理由]

📷 酒店图片已保存至 output/images/hotel_hilton_danang.jpg
```

## 注意事项
- **必须给精确价格**，不能给区间
- 如果酒店已订满，明确标注 ❌ 已订满
- 剩余房间少（≤5间）时标注 ⚠️
- Trip.com 搜索页有时返回默认值（如 ¥2,000），这是假数据——必须进详情页取真实价格
- Booking.com 有弹窗，需要用 Playwright 关闭后再提取
- 五一/国庆等假期价格会比平时高很多，要提醒用户
