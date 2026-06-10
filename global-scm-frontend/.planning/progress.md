# 会话日志

> 每次会话的执行记录

---

## 会话历史

| 日期 | 摘要 | 关键产出 |
|------|------|----------|
| 2026-06-09 | WhyUs UI 对齐蓝图 | CSS同步、模板对比、死代码清理 |
| 2026-06-09 | Contact 页面 UI 改造 | ContactForm 重写、ContactView page-hero + contact-grid + stats |
| 2026-06-09 | 新闻详情 + 点赞 + 2D地图 + i18n | 4 大模块并行推进 |

## 2026-06-09 本次会话详细记录

### 模块一：NewsDetail 对齐原型

1. **kt-box 渲染修复** — `<div v-html>` → `<ul><li>`，新增 `parseKtItems()` 按换行拆分
2. **继续阅读跳转修复** — 添加 `watch(() => route.params.id)` 解决同组件内路由切换不刷新
3. **hero 间距微调** — 返回链接 `margin-right: 12px`，保持左右结构

### 模块二：文章点赞与阅读计数

1. **数据库** — articles 表加 `view_count`、`like_count` 字段
2. **后端** — Article 实体加字段、Service 加 `incrementViewCount`/`toggleLike`、Controller 加 `POST /{id}/view` 和 `POST /{id}/like`
3. **前端** — 新建 `useArticleInteraction.js`（localStorage 30 分钟去重 + 点赞列表）、NewsDetail 接入动态计数和点赞按钮

### 模块三：2D Leaflet 风险地图

1. **安装 leaflet**，在 IntelView.vue 新增地图初始化
2. **数据源** — GDACS RSS（通过 `/gdacs` 代理）+ USGS GeoJSON（直连）
3. **功能** — 白天/黑夜瓦片切换、缩放边界限制、悬浮 tooltip、高危/关注脉冲 CSS 动画
4. **文案优化** — 标题「全球供应链风险热力图」、眉标「RISK HEATMAP」、底部数据来源说明

### 模块四：全项目中英双语 i18n

1. **新建 `useI18n.js`** — 模块级 ref 单例，`t({ zh, en })` 取值，`toggleLang()` 切换
2. **NavBar 接线** — 语言按钮调用 `toggleLang()`，显示「中」/「EN」
3. **覆盖 19 个文件** — 所有 views 和 components 接入 useI18n
4. **地图区域** — 标题、图例、tooltip 全部双语，`watch(lang)` 切语言即时刷新标记

### 遇到的错误

| 错误 | 原因 | 解决 |
|------|------|------|
| NavBar 全部导航失效 | `closeMenu` 函数被错误覆盖 | 恢复 `closeMenu` 函数 |
| 工作流子 agent 语法错误 | 正则替换时引入多余符号 | 批量修复 `useI18n` | 导入语句 |
| git checkout main 代码跟过来 | 修改未 commit 就切分支 | 等待用户确认后用 stash 处理 |

### 当前状态

- 所有改动已 commit 在 main 分支
- i18n 全局可用，点右上角 中/EN 切换
- 2D 地图显示正常，数据每 60s 刷新
