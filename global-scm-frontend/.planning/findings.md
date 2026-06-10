# 研究发现

> 调研、分析与发现记录

---

## 发现列表

| # | 日期 | 发现 | 影响 |
|---|------|------|------|
| 1 | 2026-06-09 | 项目 `src/assets/style.css` 已包含原型所有 CSS 类 | 直接复用现有 CSS |
| 2 | 2026-06-09 | Vue Router 同组件跳转时 `onMounted` 不触发 | NewsDetail 需 `watch(route.params.id)` |
| 3 | 2026-06-09 | Leaflet 未安装，地图 `<div>` 存在但无 JS | 从头安装 leaflet + 初始化 |
| 4 | 2026-06-09 | `noWrap: true` + `minZoom: 2` 导致地图黑边 | 改为 `noWrap: false` + `worldCopyJump: true` |
| 5 | 2026-06-10 | **vue-i18n v11 `@` 是特殊字符**（链接消息语法 `@:key`），翻译文本中出现 `@` 会抛 SyntaxError | 翻译文本避免使用 `@`，或用 `@@` 转义（11.4.5 实测 `@@` 不生效，最终改为不含 `@` 的文本） |
| 6 | 2026-06-10 | **`<select>` + `<option>` 无 value 属性时**，选项值=文本内容。切语言后文本变、值也变，v-model 不匹配任何选项，触发 Vue 无限渲染循环，导致整个渲染管道崩溃 | 所有 `<option>` 加固定 `value` 属性 |
| 7 | 2026-06-10 | **`computed` 包裹 `t()` 会创建新对象引用**，locale 变化时 v-for 收到全新数组，可能引发连锁响应式更新 | 用静态数组 + 模板内 `t(key)` 直接取值 |
| 8 | 2026-06-10 | **Three.js `globeWorld.renderer().domElement`** 在组件卸载时未清理，Vue 后续操作时 parentNode 为 null | onUnmounted 中主动 `parentNode.removeChild(domEl)` |
| 9 | 2026-06-10 | 当前项目**后端无语言字段**，所有 API 返回数据均为中文 | 需要后端数据库改造，存储双语内容 |

## 后端动态数据现状

所有页面主要内容通过以下 API 获取，**全部返回中文**：

- `GET /api/home/hero` → title, highlight, subtitle, tagsJson
- `GET /api/home/crisis-cards` → tag, title, description, itemsJson（6 张卡片）
- `GET /api/home/carousel` → eyebrow, title, description（4 张轮播）
- `GET /api/home/sections` → stats, mission, ai-empowerment, risk-feed, cta（5 个区块）
- `GET /api/page/sections?page=xxx` → 各页面 sections（products/solutions/why-us/pain-points/contact）
- `GET /api/articles?cat=xxx` → 新闻列表
- `GET /api/articles/{id}` → 新闻详情

前端已通过 Axios 拦截器自动发送 `Accept-Language: zh-CN` 或 `en-US`。

## 涉及的关键文件

- `src/i18n/index.js` — vue-i18n 实例
- `src/i18n/locales/zh-CN.json` — 中文翻译（~80 key）
- `src/i18n/locales/en-US.json` — 英文翻译（~80 key）
- `src/api/request.js` — Axios 拦截器（Accept-Language 头）
- `src/components/global/NavBar.vue` — 语言切换按钮
- 所有 View 和 Component — 已接入 `useI18n` + `t()` 调用
