# 研究发现

> 调研、分析与发现记录

---

## 发现列表

| # | 日期 | 发现 | 影响 |
|---|------|------|------|
| 1 | 2026-06-09 | 项目 `src/assets/style.css` 已包含原型所有 CSS 类，无需新增样式 | 直接复用现有 CSS |
| 2 | 2026-06-09 | Vue Router 同组件跳转时 `onMounted` 不触发，需 `watch(route.params.id)` | NewsDetail 继续阅读跳转修复 |
| 3 | 2026-06-09 | Leaflet 未安装，地图 `<div>` 存在但无 JS 初始化 | 需从头安装 leaflet + 写初始化逻辑 |
| 4 | 2026-06-09 | `noWrap: true` + `minZoom: 2` 导致缩小地图左右黑边 | 改为 `noWrap: false` + `worldCopyJump: true` |
| 5 | 2026-06-09 | 项目无 i18n 系统，NavBar 语言按钮是空壳（无 click 事件） | 新建 `useI18n.js` 轻量方案 |
| 6 | 2026-06-09 | 无用户登录系统，不能用后端去重点赞/阅读 | 前端 localStorage 做 30 分钟阅读去重 + 点赞列表持久化 |
| 7 | 2026-06-09 | 标准项目用 vue-i18n 集中管理翻译 JSON | 当前方案翻译散落模板，后续可迁移 |
| 8 | 2026-06-09 | Git 未 commit 的修改跟着用户跨分支 | 提醒用户先 commit 再 checkout |

## 数据源清单

| 名称 | URL | 代理 | 用途 |
|------|-----|------|------|
| GDACS RSS | `/gdacs/xml/rss.xml` → `www.gdacs.org` | Vite 代理 | 洪水/气旋/野火/火山/干旱 |
| USGS GeoJSON | `earthquake.usgs.gov/.../2.5_day.geojson` | 直连 | 全球 2.5 级以上地震 |
| CartoDB 瓦片 | `basemaps.cartocdn.com` | 直连 | 2D 地图浅色/暗色瓦片 |

## 涉及的关键文件

- `src/composables/useI18n.js` — **新建** 轻量 i18n
- `src/composables/useArticleInteraction.js` — **新建** localStorage 互动工具
- `src/views/IntelView.vue` — 新闻台 + 2D 地图
- `src/views/NewsDetail.vue` — 新闻详情
- `src/components/global/NavBar.vue` — 导航栏 + 语言按钮
- `src/router/index.js` — 路由 scrollBehavior
- `src/api/article.js` — 文章 API
- 后端 `Article.java` / `ArticleService.java` / `ArticleController.java`
