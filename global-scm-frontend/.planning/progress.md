# 会话日志

> 每次会话的执行记录

---

## 会话历史

| 日期 | 摘要 | 关键产出 |
|------|------|----------|
| 2026-06-09 | WhyUs UI 对齐蓝图 | CSS同步、模板对比、死代码清理 |
| 2026-06-09 | Contact 页面 UI 改造 | ContactForm 重写、ContactView page-hero + contact-grid + stats |
| 2026-06-09 | 新闻详情 + 点赞 + 2D地图 + i18n | 4 大模块并行推进 |
| 2026-06-10 | **迁移到 vue-i18n v11 标准方案** | 21 个文件改造，中英双语切换可用 |

---

## 2026-06-10 本次会话详细记录

### 阶段一：vue-i18n 标准方案迁移

1. **安装 vue-i18n v11** — `npm install vue-i18n@11`
2. **新建 i18n 基础设施** — `src/i18n/index.js` + `locales/zh-CN.json` + `locales/en-US.json`
3. **注册到 Vue** — `main.js` 中 `app.use(i18n)`
4. **改造 21 个文件**：
   - 全局组件：NavBar、FooterSection、RiskDashboard、ContactForm
   - View：HomeView、ContactView、NewsDetail、IntelView、WhyUsView、ProductsView、SolutionsView、PainPointsView
   - 工具层：Axios 拦截器（Accept-Language 请求头）、Globe3D（Three.js 清理）
5. **构建通过** — 120 modules，0 errors

### 遇到的错误（vue-i18n 迁移）

| 错误 | 尝试次数 | 解决方案 |
|------|---------|---------|
| vue-i18n `@` 解析崩溃（`name@company.com`） | 2（`@@` 转义无效） | 改用不含 `@` 的 placeholder 文本 |
| `<select>` 切语言无限渲染循环 → 表单消失 + Router 崩溃 + Hero 堆积 | 1 | 给所有 `<option>` 加固定 `value` 属性 |
| NavBar `computed` 包裹 `t()` 引发连锁渲染 | 1 | 改为静态数组 + 模板内 `t(link.key)` |
| Globe3D `parentNode` 错误 | 1 | onUnmounted 清理 Three.js renderer DOM |

### 当前状态

- 前端静态文本 i18n ✅ 完成
- NavBar 语言按钮可用，localStorage 持久化
- Axios 已发送 `Accept-Language` 请求头
- **动态内容（API 数据）仍为中文**，待后端改造

### 下一步

规划后端 API 双语改造方案
