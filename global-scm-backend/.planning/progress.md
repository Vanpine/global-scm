# 会话日志

> 每次会话的执行记录

---

## 会话历史

| 日期 | 摘要 | 关键产出 |
|------|------|----------|
| 2026-06-09 | 后端 API 基础 CRUD 搭建 | 9 实体 + 9 Mapper + 9 Service + 4 Controller |
| 2026-06-09 | 文章点赞阅读计数 | Article 加 view_count/like_count，SQL 增量更新 |
| 2026-06-10 | 字符集修复 + SQL 日志 | utf8mb4→UTF-8，StdOutImpl |
| 2026-06-10 | 后端规划初始化 + 双语需求分析 | .planning 三个文件，8 表双语改造方案 |

---

## 2026-06-10 前端变更分析（影响后端）

### 前端重大变更：vue-i18n v11 迁移

| 变更项 | 详情 |
|--------|------|
| i18n 方案 | 轻量 useI18n → **vue-i18n v11**（Composition API，21 个文件） |
| 翻译文件 | `zh-CN.json` + `en-US.json`（各 ~80 key） |
| 请求头 | Axios 拦截器自动发 **`Accept-Language: zh-CN` / `en-US`** |
| 语言切换 | NavBar 按钮，locale 响应式，localStorage 持久化 |
| 路由 | **无 URL 区分**，不区分 /en/ /zh/ |

### 后端需要做的事

1. **数据库加双语列** — name_en / name_zh 或 JSON 列
2. **Controller 读 Accept-Language** — 从请求头取语言
3. **Service 加语言解析** — 根据语言返回对应字段
4. **8 张表涉及** — 约 25 个文本字段需要双语

## 2026-06-10 本次会话记录

### 前端 vue-i18n 迁移过程（供参考）

1. 安装 vue-i18n v11 → 新建 i18n 基础设施
2. 改造 21 个文件（全局组件 + View + 工具层）
3. 遇到 4 个错误：`@` 解析崩溃、`<select>` 无限渲染、computed 连锁更新、Three.js parentNode
4. 所有错误已解决，构建 120 modules 零错误

### 后端 .planning 文件更新

- **task_plan.md** — 新增双语改造任务（#12 #13 #14 #16），补充三种存储方案对比
- **findings.md** — 新增前端能力清单、数据库改造分析、工作量估算
- **progress.md** — 本文件，记录前端变更对后端的影响

### 当前状态

- 前端：静态文本 i18n ✅，动态数据仍为中文 ⏳
- 后端：基础 CRUD ✅，双语改造规划中 ⏳
- 下一步：确认数据库改造方案（双列 A / JSON B），开始实施
