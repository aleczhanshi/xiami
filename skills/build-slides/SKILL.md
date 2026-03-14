---
name: build-slides
description: 从结构化数据生成精美的 HTML 幻灯片演示文稿。当需要制作展示、攻略、汇报等可视化内容时使用。
allowed-tools: Bash, Read, Write, Edit, Glob
---

# HTML 幻灯片制作

根据 "$ARGUMENTS" 主题生成精美的 HTML 幻灯片。

## 设计原则（铁律，必须遵守）

### 1. 以图为主导
- 每一页都必须有图片，不能全是文字
- 图片占页面主体面积（≥40%），文字精简辅助
- 图片必须和当前页面内容对应——酒店页用酒店图，美食页用美食图

### 2. 每页内容铺满
- 不留大片空白，用 `flex:1` + `justify-content: space-evenly` 撑满
- 内容页用 `.fill` class（`justify-content: flex-start`）
- 子元素用 `flex:1` 自动分配空间

### 3. 必须给明确推荐
- 不能只列选项，要拍板说"选这个"并给理由
- 在总览后加推荐页，标注 ⭐首选 / 备选 / ❌不推荐
- 推荐要有依据（价格、评分、可用性、适合场景）

### 4. 价格/数据必须精确
- 所有价格给具体数字，不给区间
- 标注数据来源和查询时间
- 已售罄/库存紧张要明确标注

### 5. 不能捡芝麻丢西瓜
- 每次改版后检查所有核心模块是否保留
- 核心模块清单：总览、推荐、详情、行程安排、实用信息

## 技术方案

### 配色方案：浅色系（默认）
```css
:root{
  --bg:#fafaf8;--card:rgba(0,0,0,0.03);
  --t1:#1a1a1a;--t2:#555;--dim:#999;
  --gold:#b8960c;--pink:#c4547a;--warm:#b87333;--teal:#2a8a7a;--coral:#c45040;
  --serif:'Cormorant',serif;--sans:'IBM Plex Sans',sans-serif;
}
```
- 白底黑字，可读性优先
- 强调色用在标签、价格、推荐标记上
- 图片用 `border-radius:12px` + 轻微阴影

### 核心 CSS 结构
```css
/* 全屏翻页 */
html{scroll-snap-type:y mandatory;scroll-behavior:smooth}
.slide{width:100vw;height:100vh;height:100dvh;scroll-snap-align:start;display:flex;flex-direction:column;overflow:hidden}

/* 内容容器 */
.slide-content{flex:1;display:flex;flex-direction:column;justify-content:center;padding:var(--pad);overflow:hidden}
.slide-content.fill{justify-content:flex-start;gap:clamp(0.3rem,0.7vh,0.7rem)}

/* 响应式字号 */
--h1:clamp(2.8rem,6.5vw,5.5rem);
--h2:clamp(1.9rem,4vw,3rem);
--body:clamp(1rem,1.7vw,1.35rem);

/* 图片横排 */
.photo-row{display:flex;gap:6px;height:22vh}
.photo-row img{flex:1;min-width:0;height:100%;object-fit:cover;border-radius:8px}

/* 大图横幅（用于分割页） */
.photo-banner{display:flex;gap:6px;height:50vh}
.photo-banner img{flex:1;min-width:0;height:100%;object-fit:cover;border-radius:10px}
```

### 页面类型模板

**分割页**（目的地/章节入口）：
```html
<section class="slide divider">
  <div class="slide-content">
    <div class="photo-banner reveal">[3张大图 50vh]</div>
    <div class="label reveal">章节标签</div>
    <h1 class="reveal">标题</h1>
    <p class="reveal">副标题</p>
  </div>
</section>
```

**内容页**（航班/酒店/行程）：
```html
<section class="slide">
  <div class="slide-content fill">
    <div class="photo-row reveal">[3张配图 22vh]</div>
    <div class="reveal"><h2>标题</h2></div>
    <div style="flex:1">[主体内容，用 flex:1 撑满]</div>
    <div class="reco-box reveal">[推荐/总结框]</div>
  </div>
</section>
```

**体验页**（引用+图片）：
```html
<section class="slide">
  <div class="slide-content fill">
    <div class="reveal"><h2>标题</h2></div>
    <div class="g2 reveal" style="flex:1">[2个引用卡片]</div>
    <div class="photo-row reveal" style="height:32vh">[3张全宽图]</div>
    <div class="g2 reveal" style="flex:1">[2个引用卡片]</div>
  </div>
</section>
```

### 交互功能
```javascript
// IntersectionObserver 触发 reveal 动画
// 键盘翻页（上下/左右/空格）
// 进度条 + 右侧导航圆点
// scroll-snap 全屏翻页
```

### 幻灯片标准结构
1. **封面**：主题 + 标签
2. **总览**：所有选项一览（带缩略图）
3. **推荐页**：⭐ 明确推荐 + 理由
4. **各方案详情**：分割页 → 航班 → 酒店（带图） → 体验 → 行程安排
5. **实用信息**：Tips / 注意事项
6. **结尾**：数据来源 + 致谢

## 部署
如果用户需要部署：
- `scp -r output/* your-server:/var/www/{project}/`
- nginx 静态托管
- 确认安全组端口开放（80/8888）
