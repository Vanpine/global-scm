# 任务计划

> 阶段、进度与决策记录

---

## 目标

2026-06-10：后端 API 动态数据双语支持 — 根据 `Accept-Language` 请求头返回对应语言内容。

---

## 当前阶段

**阶段 2：后端 API 动态数据双语改造** — 规划中

## 任务列表

| # | 任务 | 状态 | 备注 |
|---|------|------|------|
| 1 | 首页 Hero CRUD | ✅ 完成 | GET /api/home/hero |
| 2 | 首页危机卡片 API | ✅ 完成 | GET /api/home/crisis-cards |
| 3 | 首页轮播图 API | ✅ 完成 | GET /api/home/carousel |
| 4 | 首页五大区块 API | ✅ 完成 | GET /api/home/sections |
| 5 | 页面区块 API | ✅ 完成 | GET /api/page/sections?page=xxx |
| 6 | 文章列表与详情 API | ✅ 完成 | GET /api/articles + /{id} |
| 7 | 文章分类筛选 | ✅ 完成 | GET /api/articles?cat=xxx |
| 8 | 文章点赞与阅读计数 | ✅ 完成 | POST /api/articles/{id}/view + /like |
| 9 | 联系表单提交 | ✅ 完成 | POST /api/contact |
| 10 | MySQL 字符集修复 | ✅ 完成 | utf8mb4 → UTF-8 |
| 11 | SQL 日志输出 | ✅ 完成 | StdOutImpl |
| **12** | **数据库添加双语字段** | ⏳ 规划中 | 8 张表需加 `_zh` / `_en` 后缀列 |
| **13** | **Controller 读取 Accept-Language 并路由** | ⏳ 待开始 | 已有的 Axios 请求头 |
| **14** | **Service 层语言解析逻辑** | ⏳ 待开始 | 封装公共方法 |
| 15 | 数据库建表 SQL 脚本 | ⏳ 待做 | 含双语字段的完整 DDL |
| 16 | 联调测试 | ⏳ 待开始 | 前后端中英文切换验证 |
| 17 | 统一分页支持 | ⏸️ 暂缓 | |
| 18 | 全局异常处理 | ⏸️ 暂缓 | |
| 19 | CORS 生产收紧 | ⏸️ 暂缓 | |

## 后端待改造清单（动态数据双语）

前端 Axios 拦截器已自动发送 `Accept-Language: zh-CN` 或 `en-US`，后端需据此返回对应语言：

| API | 路径 | 涉及字段 |
|-----|------|---------|
| HomeController | `/api/home/hero` | title, highlight, subtitle, tagsJson, ctaPrimaryText, ctaSecondaryText |
| HomeController | `/api/home/crisis-cards` | tag, title, description, itemsJson |
| HomeController | `/api/home/carousel` | eyebrow, title, description |
| HomeController | `/api/home/sections` | title, subtitle, itemsJson（5 个区块） |
| PageController | `/api/page/sections?page=xxx` | title, subtitle, itemsJson |
| ArticleController | `/api/articles?cat=xxx` | title, summary, meta |
| ArticleController | `/api/articles/{id}` | title, summary, blocks.content, tags.tagName |

## 双语存储方案对比

| 方案 | 优点 | 缺点 | 适合场景 |
|------|------|------|----------|
| **A. 双列** `title_zh` + `title_en` | SQL 简单、无 JSON 解析 | 列数量翻倍 | 字段少、查询简单 |
| **B. JSON 列** `title: {"zh":"...","en":"..."}` | 列数不变、灵活扩展 | 需要 JSON 解析、索引困难 | 字段多、需要灵活扩展 |
| **C. 按行分语言** 加 `lang` 列 | 不改表结构、可加更多语言 | 查询需加 WHERE lang=xxx、ID 体系变化 | 未来支持多语言 |

**当前推荐：方案 A（双列）** — 项目只有中英两种语言，8 张表文本字段不超过 30 个，双列最简单，SQL 改造成本最低。

## 决策记录

| 日期 | 决策 | 原因 |
|------|------|------|
| 2026-06-09 | 首页区块用 section 字段区分类型而非分表 | 5 个区块结构相同，单表更灵活 |
| 2026-06-09 | 文章内容用 article_blocks 拆块存储 | 支持文本/图片/引用/视频等多种块类型 |
| 2026-06-09 | 点赞/阅读无鉴权，前端 localStorage 去重 | 无用户系统 |
| 2026-06-10 | JDBC URL 字符集用 UTF-8 而非 utf8mb4 | utf8mb4 是 MySQL 字符集名，Java 不识别 |
| 2026-06-10 | **前端迁移到 vue-i18n v11**（用户决定） | 生态成熟、API 简洁，后端只需读 Accept-Language |
| 2026-06-10 | **动态内容翻译放后端**（用户决定） | 内容存数据库，前端只传语言标识，不改 API 路径 |
