# 研究发现

> 调研、分析与发现记录

---

## 发现列表

| # | 日期 | 发现 | 影响 |
|---|------|------|------|
| 1 | 2026-06-10 | JDBC `characterEncoding=utf8mb4` 报错 | 改为 `UTF-8`，驱动自动映射 |
| 2 | 2026-06-10 | 项目无 SQL 建表脚本 | 需导出 DDL 或补写 |
| 3 | 2026-06-10 | 9 个 Mapper 全部继承 BaseMapper | 简单 CRUD 够用，双语需加自定义查询 |
| 4 | 2026-06-10 | 无 @ControllerAdvice 全局异常处理 | 暂缓，双语改造优先 |
| 5 | 2026-06-10 | **前端已迁移到 vue-i18n v11，Axios 发送 Accept-Language 头** | 后端需要读这个请求头 |
| 6 | 2026-06-10 | **当前所有 API 返回数据均为中文**，数据库无英文字段 | 8 张表需要加英文列（~25 个文本字段） |
| 7 | 2026-06-10 | GDACS / USGS 纯前端处理，后端不参与 | 灾害数据无需多语言 |
| 8 | 2026-06-10 | application.yml 密码明文 | 生产需环境变量 |

## 前端已有能力（后端可依赖）

| 能力 | 状态 |
|------|------|
| Axios 拦截器自动发 `Accept-Language: zh-CN` / `en-US` | ✅ 已实现 |
| vue-i18n v11 静态文本切换（~80 key 全覆盖） | ✅ 已实现 |
| NavBar 语言按钮（localStorage 持久化） | ✅ 已实现 |
| 无 URL 路由区分（不区分 /en/ /zh/） | ✅ 用户明确要求 |

## 后端数据库改造分析

### 涉及的表与字段（按优先级）

```
home_hero          (1 行)   — title, highlight, subtitle, tagsJson, ctaPrimaryText, ctaSecondaryText
home_crisis_cards  (6 行)   — tag, title, description, itemsJson
home_carousel      (4 行)   — eyebrow, title, description
home_sections      (5 行)   — title, subtitle, itemsJson
page_sections      (N 行)   — title, subtitle, itemsJson
articles           (N 行)   — title, summary, meta
article_blocks     (N 行)   — content
article_tags       (N 行)   — tagName
contacts           (N 行)   — 无需双语（用户输入）
```

### 改造工作量估算

| 层级 | 改动 | 文件数 |
|------|------|--------|
| 数据库 | ALTER TABLE 加 `_zh` / `_en` 列 | 8 条 SQL |
| Entity | 每个 POJO 加 `_zh` / `_en` 字段 | ~8 个类 |
| Mapper | 可能加语言过滤方法 | 0-2 个 |
| Service | 加 `resolveField(field, lang)` 工具方法 | 1 个工具类 + ~5 个 ServiceImpl |
| Controller | 读取 `Accept-Language` 头传入 Service | ~4 个 Controller |

## API 接口清单

| 方法 | 路径 | 需改造 |
|------|------|--------|
| GET | /api/home/hero | ✅ |
| GET | /api/home/crisis-cards | ✅ |
| GET | /api/home/carousel | ✅ |
| GET | /api/home/sections | ✅ |
| GET | /api/page/sections?page=xxx | ✅ |
| GET | /api/articles?cat=xxx | ✅ |
| GET | /api/articles/{id} | ✅ |
| POST | /api/articles/{id}/view | ❌ 无需 |
| POST | /api/articles/{id}/like | ❌ 无需 |
| POST | /api/contact | ❌ 无需 |
