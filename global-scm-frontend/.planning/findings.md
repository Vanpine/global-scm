# 研究发现

> 调研、分析与发现记录

---

## 发现列表

| # | 日期 | 发现 | 影响 |
|---|------|------|------|
| 1 | 2026-06-09 | 项目 `src/assets/style.css` 已包含原型所有 CSS 类（contact-grid、contact-form-card、contact-info-card、stats-grid 等），无需新增样式 | 直接复用现有 CSS 即可 |
| 2 | 2026-06-09 | ContactForm.vue 原本只有简陋的内联样式表单，缺标签、角色下拉、隐私声明 | 需完整重写 |
| 3 | 2026-06-09 | ContactView.vue 原本 hero 使用 60vh 视频背景 + API 动态数据，与原型 page-hero 浅色渐变不符 | 改为静态 page-hero |
| 4 | 2026-06-09 | 原型 office 数据是硬编码的 4 个全球办公室（英/新/港/马），用户确认走硬编码 | API 的 officesSection 保留在 script 中但不渲染 |

## 涉及文件

- `src/views/ContactView.vue` — 页面主体
- `src/components/contact/ContactForm.vue` — 表单组件
- `src/assets/style.css` — 设计系统（未修改）
