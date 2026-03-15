---
name: feedback-presentation-quality
description: Visual presentation rules — image-text matching, fill pages, give recommendations, use light theme, font sizes, navigation
type: feedback
---

做可视化内容（HTML/幻灯片）时必须遵守的规则：

1. **图片必须和文字内容对应** — 酒店页用酒店实拍图，美食页用对应餐厅的图，不能瞎贴
   **Why:** 用户说"图片跟文字根本就不对应，那怎么行呢"、"否则就是误导我"
   **How to apply:** 每张图都要用 Read 工具打开目视确认内容后再引用。宁可不放图也不放错图

2. **每页内容必须铺满** — 不留大片空白
   **Why:** 用户说"空荡荡的"、"右半边全空"、"每一页HTML的内容用满"
   **How to apply:** 内容页用 `.fill` class + `flex:1`。同时用 `min-height:0; flex-shrink:1` 防止溢出

3. **必须给明确推荐** — 要拍板说"选这个"，并给理由
   **Why:** 用户说"领导都是要对吧？你不能光列选项"
   **How to apply:** 在总览后加推荐页，标注⭐首选/备选/不推荐，附理由和行动建议

4. **价格要精确数字** — 不给区间，要给 exactly 多少钱
   **Why:** 用户说"不要给我范围，我要 exactly 多少钱"
   **How to apply:** 用 Playwright 去 Trip.com/Booking.com 实际查询，进详情页取真实价格

5. **不能捡了芝麻丢了西瓜** — 优化细节时不能丢核心内容（如行程安排）
   **Why:** 用户指出行程安排页被优化掉了
   **How to apply:** 核心模块清单：总览、推荐、航班、酒店、美食、行程安排、地图、预算、Tips

6. **用白底** — 默认用白色背景
   **Why:** 用户说"白底会不会更好？黑底有点看不清楚"
   **How to apply:** `--bg:#fafaf8`，`--t1:#1a1a1a`

7. **字号宁大勿小** — 尤其是小字体，缩小屏幕后要依然可读
   **Why:** 用户多次说"字太小了"、"看不清楚"
   **How to apply:** `--body` 最小值 ≥ 1.15rem，`--sm` 最小值 ≥ 1.05rem。加大字号后要检查是否溢出 100vh

8. **溢出 vs 铺满要平衡** — 加大字号后内容可能超出视口
   **Why:** 用户说"好几页超出了底下的边界"
   **How to apply:** 所有 flex 子元素加 `min-height:0; flex-shrink:1`，photo-banner 用 `flex:3` 而不是固定 `height:50vh`

9. **导航要清晰但不挡内容** — 用户需要知道自己在看哪个章节
   **Why:** 用户说"最好在某个地方把结构标注一下"，但又说"固定在左侧不行"
   **How to apply:** 把进度条改造成章节导航栏（顶部横排），当前章节高亮，可点击跳转。不要遮挡内容

10. **编号要连续** — 删掉选项后重新编号，不要跳号
    **Why:** 用户说"你为什么管它叫D？要不就按ABC的顺序来"
    **How to apply:** 每次增删选项后检查所有编号是否连续
