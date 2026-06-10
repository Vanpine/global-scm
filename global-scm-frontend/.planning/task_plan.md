# 任务计划

> 阶段、进度与决策记录

---

## 目标

2026-06-10：全项目中英双语 i18n — 静态文本已完成（vue-i18n 标准方案），**动态内容（后端 API 数据）英文切换待实现**。

---

## 当前阶段

**阶段 2：后端 API 动态数据双语支持** — 规划中

## 任务列表

| # | 任务 | 状态 | 备注 |
|---|------|------|------|
| 1 | 前端静态文本 i18n（vue-i18n） | ✅ 完成 | 21 个文件，NavBar 语言按钮可用 |
| 2 | 后端 API 动态数据双语 | ⏳ 规划中 | hero、sections、cards、articles 等 |
| 3 | 联调测试 | ⏳ 待开始 | |

## 前端已完成概况

- **方案**：vue-i18n v11 + Composition API（legacy: false）
- **翻译文件**：`src/i18n/locales/zh-CN.json` + `en-US.json`（各 ~80 个 key）
- **Axios 拦截器**：已自动携带 `Accept-Language` 请求头（zh-CN / en-US）
- **语言切换**：NavBar 按钮，locale 响应式切换，localStorage 持久化
- **覆盖范围**：8 个 View + 5 个全局/业务组件

## 后端待改造（动态数据）

所有通过 API 返回的页面内容需要根据 `Accept-Language` 返回对应语言：

| API | 路径 | 涉及字段 |
|-----|------|---------|
| HomeController | `/api/home/hero` | title, highlight, subtitle, tagsJson, cta |
| HomeController | `/api/home/crisis-cards` | tag, title, description, itemsJson |
| HomeController | `/api/home/carousel` | eyebrow, title, description |
| HomeController | `/api/home/sections` | title, subtitle, itemsJson（5 个区块） |
| PageController | `/api/page/sections?page=xxx` | title, subtitle, itemsJson（products/solutions/why-us/pain-points/contact） |
| ArticleController | `/api/articles?cat=xxx` | title, summary, meta |
| ArticleController | `/api/articles/{id}` | title, summary, blocks.content, tags |

## 决策记录

| 日期 | 决策 | 原因 |
|------|------|------|
| 2026-06-09 | useI18n 采用模块级 ref 单例 | 轻量、零依赖 |
| 2026-06-10 | **迁移到 vue-i18n v11** | 用户选择标准方案，生态成熟、API 简洁 |
| 2026-06-10 | 无 URL 路由（不区分 /en/ /zh/） | 用户要求实现最简单 |
| 2026-06-10 | 动态内容翻译放后端 | 内容存数据库，前端只传语言标识 |

## 遇到的错误

| 错误 | 原因 | 解决 |
|------|------|------|
| vue-i18n 解析 `@` 崩溃 | `name@company.com` 被当成链接消息 `@:key` | 改用不含 `@` 的 placeholder |
| `<select>` 切语言无限渲染循环 | `<option>` 无 `value`，文本就是值，切语言后 v-model 脱钩 | 加固定 `value` 属性 |
| NavBar `computed` 包裹 `t()` 引发连锁渲染 | computed 重建数组对象 | 改为静态数组 + 模板内 `t(link.key)` |
| Globe3D `parentNode` 错误 | Three.js canvas 未在 onUnmounted 清理 | 加 `parentNode.removeChild` |
