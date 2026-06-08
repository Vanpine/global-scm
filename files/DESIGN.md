# 全球供应链大平台 · 系统设计文档

> 版本：1.0  
> 更新日期：2026-06-08  
> 状态：后端已完成 / 前端待开发

---

## 一、项目概述

将"全球供应链大平台"官网从纯静态 HTML/CSS/JS 改造为**前后端分离的动态网站**：

- **后端**：Spring Boot 3 + MyBatis-Plus，负责数据管理与 API 输出
- **前端**：Vue 3 + Vite，负责页面渲染与用户交互
- **数据库**：MySQL 8.0，存储所有可动态编辑的内容

**核心目标**：页面内容不再硬编码在 HTML 中，而是从数据库读取，通过 API 输出给前端渲染。运营人员可通过后台管理系统（后续开发）修改内容，无需改代码。

---

## 二、技术栈

| 层 | 技术 | 版本 | 说明 |
|----|------|------|------|
| 后端框架 | Spring Boot | 3.2.7 | Java 17 |
| ORM | MyBatis-Plus | 3.5.7 | LambdaQueryWrapper 类型安全查询 |
| 数据库 | MySQL | 8.0 | utf8mb4，JSON 列 |
| API 文档 | Knife4j | 4.5.0 | OpenAPI 3 / Swagger 增强 |
| 工具库 | Hutool | 5.8.29 | 通用工具 |
| 依赖注入 | Lombok | — | @RequiredArgsConstructor |
| 前端框架 | Vue 3 + Vite | 最新 | JavaScript（非 TypeScript） |
| 前端路由 | Vue Router | 4.x | 8 条路由 |
| HTTP 客户端 | Axios | 最新 | 拦截器 + 统一错误处理 |
| 3D 地球 | globe.gl | CDN | Three.js 封装库 |
| 2D 地图 | Leaflet | CDN | OpenStreetMap 瓦片 |
| 实时地震 | USGS GeoJSON API | — | 纯前端直连，每 60s 刷新 |

---

## 三、数据库设计

> 完整建表语句见 [schema.sql](schema.sql)

### 3.1 表结构总览（9 张表）

| 表名 | 用途 | 关键字段 |
|------|------|----------|
| `home_hero` | 首页 Hero 区（单行配置） | title, highlight, subtitle, tags_json, video_url |
| `home_crisis_cards` | 首页多重危机卡片（6 张） | tag, title, description, items_json, img_url, sort_order |
| `home_carousel` | 首页轮播图（4 张） | img_url, eyebrow, title, description, sort_order |
| `home_sections` | 首页其他区块 | section, title, subtitle, items_json, sort_order |
| `page_sections` | 子页面区块内容 | page, section, title, subtitle, items_json, sort_order |
| `articles` | 新闻文章 | title, summary, category, cover_img, source, status |
| `article_blocks` | 文章内容块 | article_id, block_type, content, sort_order |
| `article_tags` | 文章标签 | article_id, tag_name |
| `contacts` | 联系表单提交记录 | name, company, email, phone, message |

### 3.2 设计原则

1. **数据库只存中文**，英文走前端 i18n（暂未实现，预留）
2. **灵活内容用 JSON 列**：标签行、要点列表、卡片组、快讯列表等结构多变的数据存为 JSON，兼顾灵活性和查询性能
3. **列名避开 MySQL 保留字**：如 `lead` → `subtitle`
4. **软删除不使用**：当前业务不需要，直接物理删除即可

### 3.3 区块标识（section）枚举

**首页区块（home_sections.section）：**

| section | 内容 | items_json 结构 |
|---------|------|----------------|
| stats | 四项关键指标 | `[{"label":"指标名","value":"目标值"}, ...]` |
| mission | 使命愿景（2 卡片） | `[{"icon":"","title":"","desc":"","tags":[]}, ...]` |
| ai-empowerment | AI 赋能（3 卡片） | `[{"icon":"","title":"","sub":"","desc":""}, ...]` |
| risk-feed | 风险快讯（6 条） | `[{"title":"","cat":"","meta":"","href":""}, ...]` |
| cta | 底部行动号召 | `[{"text":"","href":"","primary":true/false}, ...]` |

**子页面区块（page_sections.section）：**

| page | section | 说明 |
|------|---------|------|
| products | hero, pain-points-flow, modules, beyond-core, ai-everywhere, cta | 产品功能页 |
| solutions | hero, scenarios, fulfillment, stages, perspectives, outcomes, cta | 解决方案页 |
| why-us | hero, comparison, copilot, difference | 为什么选我们 |
| intel | hero, news-groups | 供应链新闻台 |
| contact | hero, offices | 联系我们 |
| pain-points | hero, preview | 痛点与方案 |

### 3.4 文章内容块类型（block_type）

| block_type | 含义 | 前端样式 |
|------------|------|----------|
| kt | 关键信息 Key Takeaways | 深色背景要点列表，文章顶部 |
| lead | 引导语 | 加粗引导段落 |
| p | 正文段落 | 普通段落 |
| quote | 引用 | 左侧竖线引用块 |

### 3.5 文章分类（category）

| category | 含义 |
|----------|------|
| war | 地缘冲突 |
| logi | 交通物流 |
| energy | 能源与环境 |
| policy | 贸易政策 |

---

## 四、后端架构

### 4.1 包结构

```
com.globalscm
├── Application.java                 # Spring Boot 启动类 + @MapperScan
├── config/
│   ├── Knife4jConfig.java           # OpenAPI 文档配置
│   ├── MyBatisPlusConfig.java       # 分页插件
│   └── WebConfig.java               # CORS 跨域配置
├── entity/
│   ├── pojo/                        # 数据库实体（9 个）
│   │   ├── HomeHero.java            # @Data @Accessors(chain = true)
│   │   ├── HomeCrisisCard.java
│   │   ├── HomeCarousel.java
│   │   ├── HomeSection.java
│   │   ├── PageSection.java
│   │   ├── Article.java
│   │   ├── ArticleBlock.java
│   │   ├── ArticleTag.java
│   │   └── Contact.java
│   ├── dto/
│   │   └── Result.java              # 统一响应 {code, message, data}
│   └── vo/                          # 视图对象（预留）
├── mapper/                          # MyBatis-Plus Mapper（9 个）
├── service/                         # 服务接口（9 个）
├── service/impl/                    # 服务实现（9 个）
└── controller/                      # 控制器（4 个）
    ├── HomeController.java          # 首页 API
    ├── PageController.java          # 页面区块 API
    ├── ArticleController.java       # 文章 API
    └── ContactController.java       # 联系表单 API
```

### 4.2 分层规范

- **Controller**：接收请求、参数校验、调用 Service、返回 Result
- **Service**：业务逻辑、数据组装（如文章详情 = 文章 + 内容块 + 标签）
- **Mapper**：数据访问，继承 `BaseMapper<T>`，使用 `LambdaQueryWrapper` 构建查询

### 4.3 依赖注入规范

所有类统一使用 Lombok `@RequiredArgsConstructor` 进行构造器注入：

```java
@Service
@RequiredArgsConstructor
public class HomeHeroServiceImpl implements HomeHeroService {
    private final HomeHeroMapper homeHeroMapper;
    // Spring 自动注入 final 字段
}
```

### 4.4 统一响应格式

```json
{
  "code": 200,
  "message": "success",
  "data": { }
}
```

| code | 含义 |
|------|------|
| 200 | 成功 |
| 404 | 资源不存在 |
| 500 | 服务器异常 |

---

## 五、API 设计

> 完整接口文档见 [API.md](API.md)，Knife4j 在线文档：`http://120.26.30.114:8080/doc.html`

### 5.1 接口总览

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/home/hero` | 首页 Hero 区数据 |
| GET | `/api/home/crisis-cards` | 首页危机卡片列表 |
| GET | `/api/home/carousel` | 首页轮播图列表 |
| GET | `/api/home/sections` | 首页所有区块 |
| GET | `/api/page/{page}` | 按页面标识获取区块列表 |
| GET | `/api/articles` | 文章列表（可选 ?category=） |
| GET | `/api/articles/{id}` | 文章详情（含内容块和标签） |
| POST | `/api/contact` | 提交联系表单 |

### 5.2 前端调用策略

首页采用**并行请求**策略，一次加载全部数据：

```javascript
const [hero, crisisCards, carousel, sections] = await Promise.all([
  fetch('/api/home/hero').then(r => r.json()),
  fetch('/api/home/crisis-cards').then(r => r.json()),
  fetch('/api/home/carousel').then(r => r.json()),
  fetch('/api/home/sections').then(r => r.json())
]);
```

子页面按需加载各自区块数据：

```javascript
const { data } = await fetch('/api/page/products').then(r => r.json());
```

---

## 六、前端架构

### 6.1 技术选型理由

| 决策 | 选择 | 理由 |
|------|------|------|
| 框架 | Vue 3 + Vite | 轻量、快速、生态成熟 |
| 语言 | JavaScript | 项目规模适中，JS 开发效率更高 |
| UI 库 | 不用 | 保留原始 `style.css` 设计体系，避免样式冲突 |
| 状态管理 | 不用 Pinia | 各页面数据独立请求，无全局共享状态需求 |
| CSS 方案 | 原始 CSS | 迁移原站 style.css，保持视觉一致性 |

### 6.2 路由规划

```
/                  → HomeView.vue         首页
/products          → ProductsView.vue     产品功能
/solutions         → SolutionsView.vue    解决方案
/why-us            → WhyUsView.vue        为什么选我们
/intel             → IntelView.vue        供应链新闻台
/news/:id          → NewsDetail.vue       文章详情
/pain-points       → PainPointsView.vue   痛点与方案
/contact           → ContactView.vue      联系我们
```

### 6.3 项目结构

```
global-scm-frontend/
├── index.html                      # Vite 入口 HTML
├── vite.config.js                  # Vite 配置（代理 /api 到后端）
├── src/
│   ├── main.js                     # Vue 入口：注册路由、全局组件
│   ├── App.vue                     # 根组件：NavBar + <router-view> + FooterSection
│   ├── router/
│   │   └── index.js                # Vue Router 配置（8 条路由）
│   ├── api/                        # API 请求层
│   │   ├── request.js              # Axios 实例 + 拦截器
│   │   ├── home.js                 # 首页 API
│   │   ├── page.js                 # 页面区块 API
│   │   ├── article.js              # 文章 API
│   │   └── contact.js              # 联系表单 API
│   ├── composables/                # 组合式函数
│   │   └── useRiskData.js          # 风险数据管理（静态点 + USGS 实时地震）
│   ├── views/                      # 页面视图（8 个）
│   │   ├── HomeView.vue
│   │   ├── ProductsView.vue
│   │   ├── SolutionsView.vue
│   │   ├── WhyUsView.vue
│   │   ├── IntelView.vue
│   │   ├── NewsDetail.vue
│   │   ├── PainPointsView.vue
│   │   └── ContactView.vue
│   ├── components/                 # 复用组件
│   │   ├── global/                 # 全局组件
│   │   │   ├── NavBar.vue          # 导航栏
│   │   │   └── FooterSection.vue   # 页脚
│   │   ├── home/                   # 首页专用组件
│   │   │   ├── HeroSection.vue     # Hero 区（视频背景）
│   │   │   ├── CrisisCards.vue     # 危机卡片列表
│   │   │   ├── CarouselBanner.vue  # 轮播图
│   │   │   ├── StatsBar.vue        # 数据指标条（数字滚动动画）
│   │   │   ├── MissionCards.vue    # 使命愿景卡片
│   │   │   ├── AiEmpowerment.vue   # AI 赋能卡片
│   │   │   ├── RiskDashboard.vue   # 风险地图总控（3D + 2D + 快讯）
│   │   │   │   ├── Globe3D.vue     #   3D 地球子组件
│   │   │   │   ├── Leaflet2D.vue   #   2D 地图子组件
│   │   │   │   └── RiskFeed.vue    #   实时快讯面板子组件
│   │   │   └── CtaSection.vue      # 底部 CTA
│   │   ├── page/                   # 子页通用组件
│   │   │   ├── PageHero.vue        # 页面 Hero 区
│   │   │   ├── BlockRenderer.vue   # JSON 区块通用渲染器
│   │   │   └── ArticleCard.vue     # 文章卡片
│   │   └── contact/
│   │       └── ContactForm.vue     # 联系表单
│   └── assets/                     # 静态资源（从原项目迁移）
│       ├── style.css               # 主样式表
│       ├── icons.svg               # SVG 图标集
│       ├── logo.png
│       ├── logo-icon.png
│       ├── vedio.mp4               # 首页背景视频
│       └── ...
```

### 6.4 组件渲染策略

页面区块使用**数据驱动渲染**模式。每个页面的区块数据从 API 获取后，根据 `section` 标识匹配对应组件：

```
API 返回: [{ section: "modules", title: "...", items_json: "[...]" }, ...]
                    │
                    ▼
          BlockRenderer.vue  (根据 section 值动态选择组件)
                    │
    ┌───────────────┼───────────────┐
    ▼               ▼               ▼
 ModulesPanel   StatsBar        AiCards
```

对于结构固定的区块（如首页 Hero、轮播），使用专用组件直接绑定数据；对于结构灵活的区块，使用通用渲染器 + JSON 配置驱动。

---

## 七、3D 地球 + 2D 地图 + 实时新闻 设计

> 这是首页风险控制塔区域的核心功能，也是整个网站技术复杂度最高的部分。

### 7.1 当前实现

原站点 [risk-globe.js](../原型+蓝图/蓝图/官网/js/risk-globe.js) 已同时实现了三样东西：

| 可视化 | 依赖库 | 加载方式 |
|--------|--------|----------|
| 3D 地球 | `globe.gl`（Three.js 封装） | CDN `<script>` |
| 2D 地图 | Leaflet + OpenStreetMap | CDN `<script>` + `<link>` |
| 实时快讯面板 | 纯 DOM 操作 | 无依赖 |

三者**共享同一份数据源**：
- **10 个静态供应链风险点**（硬编码演示数据）：黑海、红海、长滩港、巴拿马运河等
- **5 条静态航线弧线**（硬编码演示数据）
- **USGS 全球地震实时数据**（API 直连，每 60s 刷新）

### 7.2 架构设计

```
┌──────────────────────────────────────────────────────────┐
│  RiskDashboard.vue  （总控组件）                           │
│                                                          │
│  ┌─────────────────┐  ┌──────────────┐  ┌────────────┐  │
│  │   Globe3D.vue   │  │ Leaflet2D.vue│  │ RiskFeed.vue│  │
│  │   (3D 地球)     │  │ (2D 地图)    │  │ (快讯面板)  │  │
│  │                 │  │              │  │             │  │
│  │  globe.gl 实例  │  │  Leaflet 实例│  │  响应式列表 │  │
│  │  (命令式操作)   │  │  (命令式操作)│  │  (v-for)    │  │
│  └────────┬────────┘  └──────┬───────┘  └─────┬───────┘  │
│           │                  │                │          │
│           └──────────────────┴────────────────┘          │
│                              │                           │
│                  useRiskData()  composable                │
│                  ├─ riskPoints  静态风险点（硬编码）       │
│                  ├─ arcs        静态航线（硬编码）         │
│                  ├─ quakePoints USGS 地震（fetch 直连）   │
│                  ├─ lastUpdated 上次刷新时间              │
│                  └─ liveOK      实时数据是否可用           │
└──────────────────────────────────────────────────────────┘
```

### 7.3 关键设计决策

#### 决策 1：3D 地球和 2D 地图不走 Vue 响应式渲染

`globe.gl` 和 Leaflet 都是直接操作 DOM/Canvas/WebGL 的库，与 Vue 的虚拟 DOM 机制不兼容。做法：

- 在 Vue 组件 `onMounted` 中初始化库实例
- 在 `onUnmounted` 中销毁实例、解绑事件
- 数据更新通过**命令式调用**（如 `globeWorld.pointsData(newData)`），不通过 `v-for` 或 `ref` 绑定
- 组件在 `<template>` 中只提供一个空的 `<div ref="container">` 作为挂载点

```javascript
// Globe3D.vue 核心逻辑示意
import { ref, onMounted, onUnmounted, watch } from 'vue'

const container = ref(null)
let globeWorld = null

onMounted(() => {
  globeWorld = Globe()(container.value)
    .pointsData(props.riskPoints)
    // ... 配置
})

watch(() => props.riskPoints, (newData) => {
  globeWorld.pointsData(newData)  // 命令式更新
})

onUnmounted(() => {
  globeWorld._destructor?.()      // 清理
})
```

#### 决策 2：globe.gl 和 Leaflet 走 CDN，不 npm 安装

- `globe.gl` 包体积大，且其 Three.js 依赖版本与 Vite 的 ESM 打包存在兼容问题
- Leaflet 的 CSS 和图标路径在打包时需要额外配置
- CDN 加载方式与原站完全一致，迁移风险最低

在 `index.html` 中添加：

```html
<!-- 3D 地球 -->
<script src="https://cdn.jsdelivr.net/npm/globe.gl"></script>
<!-- 2D 地图 -->
<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css">
<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
```

#### 决策 3：USGS 地震数据纯前端直连，不走后端

USGS 提供公开的 GeoJSON API（CORS 已开启）：

```
https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson
```

- 返回过去 24 小时全球 M2.5+ 地震数据
- 完全免费、无需 API Key、无请求频率限制
- 数据从浏览器直接获取，后端无需代理（避免增加服务器负载）
- 每 60 秒自动刷新一次

地震数据按震级分三级显示：

| 震级 | 风险等级 | 颜色 |
|------|----------|------|
| M ≥ 6.0 | high（高危） | 红色 #ff3b30 |
| M 4.5–5.9 | watch（关注） | 橙色 #ff9500 |
| M < 4.5 | normal（正常） | 绿色 #34c759 |

#### 决策 4：快讯面板数据来自两个来源

```
┌─────────────────────────────────────────────┐
│           首页快讯面板 (RiskFeed)            │
│                                             │
│  ┌─ 供应链要闻链接（6条）─────────────────┐ │
│  │  数据来源: 后端 /api/home/sections      │ │
│  │  section = "risk-feed"                 │ │
│  │  每条: { title, cat, meta, href }      │ │
│  │  点击跳转 → /news/:id                  │ │
│  └────────────────────────────────────────┘ │
│                                             │
│  ┌─ USGS 实时地震（动态条数）──────────────┐ │
│  │  数据来源: 前端直连 USGS API             │ │
│  │  显示高/关注级别地震（最多 4 条）        │ │
│  │  纯展示，不可点击                        │ │
│  └────────────────────────────────────────┘ │
│                                             │
│  ┌─ 状态指示行 ───────────────────────────┐ │
│  │  实时数据可用: "● 实时数据已接入 · USGS"  │ │
│  │  实时数据不可用: "● 显示演示事件"        │ │
│  └────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

### 7.4 首页完整数据流

```
页面加载
  │
  ├─→ /api/home/hero          → HeroSection      (Hero 区)
  ├─→ /api/home/crisis-cards  → CrisisCards       (危机卡片)
  ├─→ /api/home/carousel      → CarouselBanner    (轮播图)
  ├─→ /api/home/sections      → 解析 section 字段:
  │       ├─ stats            → StatsBar          (数据条)
  │       ├─ mission          → MissionCards      (使命愿景)
  │       ├─ ai-empowerment   → AiEmpowerment     (AI 赋能)
  │       ├─ risk-feed        → RiskDashboard     (风险地图 + 快讯)
  │       └─ cta              → CtaSection        (底部 CTA)
  │
  └─→ (前端直连) USGS API     → useRiskData()     (实时地震)
         │
         └─→ Globe3D / Leaflet2D / RiskFeed 共享
```

### 7.5 情报页（Intel）数据流

```
/intel 页面加载
  │
  └─→ /api/page/intel
        │
        ├─ section: "hero"        → PageHero
        └─ section: "news-groups" → 新闻分组列表
              │
              ├─ 分组 1: 地缘冲突 (3 篇文章)
              ├─ 分组 2: 交通物流 (3 篇文章)
              ├─ 分组 3: 贸易政策 (7 篇文章)
              └─ 分组 4: 能源与供应链安全 (2 篇文章)
                    │
                    点击文章卡片 → 跳转 /news/:id
```

### 7.6 文章详情页数据流

```
/news/:id 页面加载
  │
  └─→ /api/articles/:id
        │
        ├─ data.article     → 文章信息（标题、来源、时间等）
        ├─ data.blocks[]    → 内容块数组（按 sort_order 排序）
        │     ├─ blockType: "kt"    → 深色背景要点框
        │     ├─ blockType: "lead"  → 加粗引导语
        │     ├─ blockType: "p"     → 普通段落
        │     └─ blockType: "quote" → 左侧竖线引用块
        └─ data.tags[]      → 标签列表
```

---

## 八、部署架构

```
┌────────────────────────────────────────────────────┐
│  服务器: 120.26.30.114                              │
│                                                    │
│  ┌──────────────────┐   ┌──────────────────────┐  │
│  │  Spring Boot      │   │  MySQL 8.0           │  │
│  │  :8080            │──→│  :3306               │  │
│  │  global-scm-      │   │  global_scm 库       │  │
│  │  backend.jar      │   │  9 张表 + 初始数据    │  │
│  └──────────────────┘   └──────────────────────┘  │
│           ↑                                        │
│           │ /api/*                                 │
│           │                                        │
│  ┌──────────────────┐                              │
│  │  Nginx :80        │                              │
│  │  ├─ /api/* → :8080│  (反向代理到后端)           │
│  │  └─ /*     → 静态文件 (Vue 构建产物)            │
│  └──────────────────┘                              │
│           ↑                                        │
│           │ HTTPS                                  │
│    用户浏览器                                       │
└────────────────────────────────────────────────────┘
```

- **开发环境**：Vite dev server (`:5173`) 通过 `vite.config.js` 的 `proxy` 转发 `/api` 到后端 `:8080`
- **生产环境**：`npm run build` 生成静态文件，Nginx 统一服务，`/api` 反向代理到 Spring Boot

---

## 九、后续规划

| 阶段 | 内容 | 状态 |
|------|------|------|
| ✅ 数据库设计 | 9 张表建表 + 初始数据 | 已完成 |
| ✅ 后端开发 | Spring Boot + MyBatis-Plus + API | 已完成 |
| 🔜 前端开发 | Vue 3 + Vite + 8 页面 | 待开发 |
| ⏳ 后台管理 | 内容管理后台（CMS） | 后续 |
| ⏳ i18n | 中英文切换 | 后续 |
| ⏳ 搜索 | 文章全文搜索 | 后续 |

---

> **相关文档：**
> - [schema.sql](schema.sql) — 完整建表语句 + 初始数据
> - [API.md](API.md) — 接口文档（含请求/响应示例）
