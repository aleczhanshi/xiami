---
name: plan-route
description: 根据多个地点规划最优游览路线，生成 Google Maps 路线链接。当需要串联餐厅/景点/酒店做行程规划时使用。
allowed-tools: Bash, Read, Write, WebFetch
---

# 地图路线规划

根据 "$ARGUMENTS" 中的地点列表，搜索坐标、规划最优路线、生成 Google Maps 链接。

## 参数格式
`/plan-route 胡志明 Day2: Pho Viet Nam, 西贡大教堂, The Workshop Coffee, 粉红教堂, A O Show`

- 第一个词：城市名
- 后面：按天分组的地点列表

## 步骤

### 1. 地点搜索 — 获取坐标
用 Playwright 或 WebFetch 搜索每个地点的精确坐标：

**方法 A：Google Maps 搜索（海外城市优先）**
```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    for place in places:
        # 搜索 "place name, city"
        page.goto(f"https://www.google.com/maps/search/{place}+{city}")
        page.wait_for_timeout(3000)
        # 从 URL 中提取坐标 @lat,lng
        url = page.url
        # 解析 @12.345,67.890 格式的坐标
```

**方法 B：高德地图 API（国内城市优先）**
```python
import requests
# 高德 Web API（需要 key）
url = f"https://restapi.amap.com/v3/place/text?keywords={place}&city={city}&key={AMAP_KEY}"
# 返回 location: "lng,lat"
```

**方法 C：Nominatim 免费地理编码（无需 API key）**
```python
import requests
url = f"https://nominatim.openstreetmap.org/search?q={place},{city}&format=json&limit=1"
headers = {"User-Agent": "TravelPlanner/1.0"}
resp = requests.get(url, headers=headers).json()
lat, lng = resp[0]["lat"], resp[0]["lon"]
```

### 2. 路线优化
按每天的地点列表，用最近邻算法排出最优游览顺序：

```python
from math import radians, sin, cos, sqrt, atan2

def haversine(p1, p2):
    """计算两点间距离（km）"""
    R = 6371
    lat1, lon1 = radians(p1[0]), radians(p1[1])
    lat2, lon2 = radians(p2[0]), radians(p2[1])
    dlat, dlon = lat2-lat1, lon2-lon1
    a = sin(dlat/2)**2 + cos(lat1)*cos(lat2)*sin(dlon/2)**2
    return R * 2 * atan2(sqrt(a), sqrt(1-a))

def optimize_route(places_with_coords):
    """贪心最近邻排序"""
    route = [places_with_coords[0]]
    remaining = places_with_coords[1:]
    while remaining:
        last = route[-1]
        nearest = min(remaining, key=lambda p: haversine(last["coords"], p["coords"]))
        route.append(nearest)
        remaining.remove(nearest)
    return route
```

### 3. 生成 Google Maps 路线链接
```python
def generate_maps_url(route):
    """生成 Google Maps 多点路线 URL"""
    origin = f"{route[0]['coords'][0]},{route[0]['coords'][1]}"
    destination = f"{route[-1]['coords'][0]},{route[-1]['coords'][1]}"
    waypoints = "|".join(f"{p['coords'][0]},{p['coords'][1]}" for p in route[1:-1])

    if waypoints:
        return f"https://www.google.com/maps/dir/{'/'.join(p['name'] for p in route)}"
    else:
        return f"https://www.google.com/maps/dir/{route[0]['name']}/{route[1]['name']}"
```

**更简单的方式 — 直接用地名拼 URL：**
```
https://www.google.com/maps/dir/Pho+Viet+Nam+Ho+Chi+Minh/Notre+Dame+Cathedral+Saigon/The+Workshop+Coffee/Tan+Dinh+Church
```
这种方式不需要坐标，Google Maps 会自动解析地名。

### 4. 输出格式
```
## 📍 Day 2 路线规划 · 胡志明

### 游览顺序（已按距离优化）
1. 🍜 Pho Viet Nam (河粉) — 起点
2. ⛪ 西贡大教堂 — 步行 800m / 10min
3. ☕ The Workshop Coffee — 步行 500m / 7min
4. 💒 粉红教堂 — Grab 3.2km / 10min
5. 🎭 A O Show — Grab 2.1km / 8min

### 总距离：6.6km
### 建议交通：步行 + Grab 混合

### Google Maps 路线
🔗 [点击打开路线](https://www.google.com/maps/dir/Pho+Viet+Nam+14+Pham+Hong+Thai/Notre+Dame+Cathedral+Saigon/The+Workshop+Coffee+27+Ngo+Duc+Ke/Tan+Dinh+Church/Saigon+Opera+House)
```

## 适用场景
- **旅行行程规划**：把每天要去的餐厅/景点串成路线
- **美食地图**：把 TOP 10 餐厅标在地图上看分布
- **城市选择**：Google Maps 默认步行/驾车/公交可选
- **国内用高德**：生成高德地图链接 `https://uri.amap.com/navigation?to=lng,lat,name`

## 注意事项
- 海外城市用 Google Maps（越南、泰国、日本等）
- 国内城市用高德地图（百度地图也行）
- Nominatim 免费但有速率限制（1次/秒），批量查询加 sleep
- 地址尽量用英文或越南语原名，中文名搜不准
- 餐厅建议加上街道地址提高准确率
