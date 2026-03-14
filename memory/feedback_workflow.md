---
name: feedback-workflow-process
description: Process-level learnings — scraping, image verification, agent management, iterative delivery, naming conventions
type: feedback
---

工作流程层面的经验教训：

1. **搜价格必须进详情页** — 搜索列表页的价格经常是假的/默认值
   **Why:** Trip.com 搜索页对未匹配的酒店显示统一的 ¥2,000，不是真实价格
   **How to apply:** 有酒店 ID 的直接访问详情页 URL；没有的先搜索再点进去

2. **酒店图片直接从预订平台抓** — 不要用通用目的地照片代替
   **Why:** 用户说"你找酒店的时候，那不就有酒店的图片吗？"
   **How to apply:** 访问 Booking.com 酒店页面 → `#photo_wrapper` img 或 `og:image` meta

3. **后台 Agent 不要跑太久** — 超过 5 分钟用户就会催
   **Why:** 用户说"都拿了一辈子了"
   **How to apply:** 如果 Agent 任务可拆分，分成多个小 Agent 并行。定期检查进度，有部分结果就先用上

4. **先出结果再优化** — 不要等所有数据都完美才展示
   **Why:** 用户喜欢迭代式工作（出初版→反馈→改→再反馈）
   **How to apply:** 用已有数据先做出初版，标注待更新的部分，后台继续搜集

5. **每次改版要做检查清单** — 防止优化时丢核心功能
   **Why:** 多次重写 HTML 时丢失了行程安排页
   **How to apply:** 改版前列出当前所有模块，改版后逐一对照确认

6. **图片文件名不可信，必须逐张目视验证** — Agent 下载的图片文件名和实际内容经常完全不对应
   **Why:** XHS 下载 Agent 给文件命名时是按笔记标题/顺序编号的，但一篇笔记里可能包含多家餐厅的图，或者图片顺序和文字顺序不一致。在越南攻略项目中，15张HCM图里只有1张（cafe_linh）文件名和内容对应，其余14张全部错位
   **How to apply:**
   - 下载完图片后，必须用 Read 工具逐张打开查看实际内容
   - 根据图片中的文字标注（餐厅名、菜品名）建立真实映射表
   - 如果图片中没有文字标注，根据视觉内容判断（如石锅=Pho、披萨=Pizza 4P's）
   - 宁可不放图，也不放错图——用户说"否则就是误导我"
   - 没有对应图的条目用渐变色背景替代，不要用 onerror 静默隐藏

7. **onerror="this.style.display='none'" 会掩盖问题** — 图片加载失败时静默隐藏，导致看不到报错
   **Why:** 在越南攻略中，所有HCM食物图因文件名错误加载失败，但 onerror 处理让图片直接消失，用户看到的是"没有图"而不是"图片路径错误"
   **How to apply:** 开发阶段不加 onerror，先确保所有图片都能正确加载；只在最终版本中加容错处理

8. **引用文件名前先 ls 确认** — 实际文件名可能带描述后缀
   **Why:** Agent 下载保存为 `food_hcm_01_pizza4ps.webp`，但代码中写的是 `food_hcm_01.webp`，导致 404
   **How to apply:** 在 HTML 中引用任何图片前，先 `ls output/images/` 确认完整文件名

9. **D→C 类编号变更要全局检查** — replace_all 可能遗漏部分写法
   **Why:** 用户说"你还有的地方写的D，应该是C"，replace_all "方案 D" 没覆盖到"首选：D 富国岛"这种写法
   **How to apply:** 改完后用 grep 搜索所有可能的写法（"方案 D"、"D ·"、"首选：D"等）确认无遗漏

10. **两人/人均切换要覆盖所有位置** — 预算相关的数字散布在总览、推荐、分割页、预算表、结尾等多处
    **Why:** 用户要求改回两人后发现部分位置仍是人均
    **How to apply:** 改完后 grep "两人|人均|× 2|2人" 确认所有相关位置一致
