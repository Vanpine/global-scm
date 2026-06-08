# 全球供应链大平台 API 接口文档

> 后端地址：`http://120.26.30.114:8080`
> Knife4j 文档：启动后访问 `http://120.26.30.114:8080/doc.html`

---

## 统一响应格式

所有接口返回 JSON，结构如下：

```json
{
  "code": 200,
  "message": "success",
  "data": { }
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| code | int | 200 成功，404 未找到，500 服务器错误 |
| message | string | 提示信息 |
| data | object/array/null | 业务数据 |

---

## 一、首页 API

### 1.1 获取 Hero 区数据

```
GET /api/home/hero
```

**响应示例：**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "id": 1,
    "title": "全球供应链",
    "highlight": "大平台",
    "subtitle": "赋能地方资源 · 连接全球市场",
    "tagsJson": "[{\"icon\":\"trending-up\",\"text\":\"降本增效\"},{\"icon\":\"shield\",\"text\":\"抗风险\"},{\"icon\":\"cpu\",\"text\":\"AI 赋能\"}]",
    "ctaPrimaryText": "申请加入 →",
    "ctaPrimaryHref": "/contact",
    "ctaSecondaryText": "了解产品 →",
    "ctaSecondaryHref": "/products",
    "videoUrl": "assets/vedio.mp4",
    "updatedAt": "2026-06-08 12:00:00"
  }
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| title | string | 主标题 |
| highlight | string | 高亮词 |
| subtitle | string | 引导语 |
| tagsJson | string | 标签行 JSON 数组 |
| ctaPrimaryText | string | 主按钮文字 |
| ctaPrimaryHref | string | 主按钮链接 |
| ctaSecondaryText | string | 次按钮文字 |
| ctaSecondaryHref | string | 次按钮链接 |
| videoUrl | string | 背景视频地址 |

### 1.2 获取危机卡片列表

```
GET /api/home/crisis-cards
```

**响应示例：**

```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "tag": "贸易政策",
      "title": "政策、关税与监管突变",
      "description": "美国 Section 232、301 关税频繁调整...",
      "itemsJson": "[\"关税一日三变，到岸成本难以预估\",\"出口管制与制裁清单持续扩大\",\"ESG 合规、碳关税成为新贸易壁垒\"]",
      "imgUrl": "https://images.unsplash.com/photo-1681505531034-8d67054e07f6?auto=format&fit=crop&w=1400&q=85",
      "sortOrder": 1
    }
  ]
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| tag | string | 卡片分类标签（贸易政策/地缘政治/物流瓶颈/需求风险/供应风险/网络安全） |
| title | string | 标题 |
| description | string | 描述 |
| itemsJson | string | 要点列表 JSON 数组 |
| imgUrl | string | 配图 URL |
| sortOrder | int | 排序（1-6） |

### 1.3 获取轮播图列表

```
GET /api/home/carousel
```

**响应示例：**

```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "imgUrl": "https://images.unsplash.com/photo-1606185540834-d6e7483ee1a4?auto=format&fit=crop&w=1920&q=80",
      "eyebrow": "END-TO-END VISIBILITY",
      "title": "一张地图，掌控全球每一票货",
      "description": "所有在途柜子、所有仓库库存、所有 PO 履约进度 —— 实时控制塔，一眼看清全盘。",
      "sortOrder": 1
    }
  ]
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| imgUrl | string | 图片 URL |
| eyebrow | string | 眉题（英文标签） |
| title | string | 标题 |
| description | string | 描述 |
| sortOrder | int | 排序（1-4） |

### 1.4 获取首页所有区块

```
GET /api/home/sections
```

**响应示例：**

```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "section": "stats",
      "title": null,
      "subtitle": null,
      "itemsJson": "[{\"label\":\"需求预测准确率（目标）\",\"value\":\"90%+\"},...]",
      "sortOrder": 1
    },
    {
      "id": 2,
      "section": "mission",
      "title": "让全球供应链，没有断链之忧",
      "subtitle": "在地缘冲突与贸易保护主义频发的时代，用 AI 重构供应链的连接方式与抗风险能力。",
      "itemsJson": "[{\"icon\":\"globe\",\"title\":\"赋能地方基层资源...\",...}]",
      "sortOrder": 2
    }
  ]
}
```

区块标识（section）说明：

| section | 内容 | itemsJson 结构 |
|---------|------|----------------|
| stats | 四项关键指标 | `[{"label":"指标名","value":"目标值"},...]` |
| mission | 使命愿景（2 卡片） | `[{"icon":"","title":"","desc":"","tags":[]},...]` |
| ai-empowerment | AI 赋能（3 卡片） | `[{"icon":"","title":"","sub":"","desc":""},...]` |
| risk-feed | 风险快讯（6 条） | `[{"title":"","cat":"","meta":"","href":""},...]` |
| cta | 底部行动号召 | `[{"text":"","href":"","primary":true/false},...]` |

---

## 二、页面区块 API

### 2.1 按页面标识获取区块列表

```
GET /api/page/{page}
```

**路径参数：**

| 参数 | 可选值 | 说明 |
|------|--------|------|
| page | products / solutions / why-us / intel / contact / pain-points | 页面标识 |

**响应示例 `GET /api/page/products`：**

```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "page": "products",
      "section": "hero",
      "title": "六大模块协同运转",
      "subtitle": "从供应商到终端客户，全链路数字化",
      "itemsJson": "[{\"icon\":\"package\",\"text\":\"采购\"},...]",
      "sortOrder": 1
    }
  ]
}
```

**各页面区块明细：**

| page | section | 说明 |
|------|---------|------|
| products | hero | 产品页 Hero |
| products | pain-points-flow | 采购到签收流程图 |
| products | modules | 六大模块介绍 |
| products | beyond-core | 分销 + 报表 |
| products | ai-everywhere | 六套 AI 引擎 |
| products | cta | 底部 CTA |
| solutions | hero | 解决方案页 Hero |
| solutions | scenarios | 四大业务场景 |
| solutions | fulfillment | 四种履约通道 |
| solutions | stages | 三个成长阶段 |
| solutions | perspectives | 四个观点 |
| solutions | outcomes | 目标成效（3 指标） |
| solutions | cta | 底部 CTA |
| why-us | hero | 为什么选我们 Hero |
| why-us | comparison | 传统 vs AI 对比表 |
| why-us | copilot | AI Copilot 时间线 |
| why-us | difference | 六个差异化维度 |
| intel | hero | 情报页 Hero |
| intel | news-groups | 新闻分组（4 组 × 多篇） |
| contact | hero | 联系我们 Hero |
| contact | offices | 全球办公室 |
| pain-points | hero | 痛点页 Hero |
| pain-points | preview | 四个痛点预览 |

---

## 三、文章 API

### 3.1 获取文章列表

```
GET /api/articles
GET /api/articles?category=policy
```

**查询参数：**

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| category | string | 否 | war / logi / energy / policy |

**响应示例：**

```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "title": "红海危机延续：主力班轮默认绕行好望角",
      "summary": "CMA CGM、马士基等已把好望角作为亚欧默认航线...",
      "category": "logi",
      "coverImg": "https://images.unsplash.com/photo-1605745341112-85968b19335b?auto=format&fit=crop&w=1600&q=75",
      "source": "Reuters",
      "sourceUrl": null,
      "meta": "Reuters · Container News · 海运 · 今日",
      "status": "published",
      "publishedAt": "2026-06-08 12:00:00",
      "createdAt": "2026-06-08 12:00:00",
      "updatedAt": "2026-06-08 12:00:00"
    }
  ]
}
```

| 字段 | 类型 | 说明 |
|------|------|------|
| id | long | 文章 ID |
| title | string | 标题 |
| summary | string | 摘要 |
| category | string | 分类：war（战争）/ logi（物流）/ energy（能源）/ policy（政策） |
| coverImg | string | 封面图 URL |
| source | string | 来源名称 |
| sourceUrl | string | 来源链接 |
| meta | string | 元信息 |
| status | string | published（已发布）/ draft（草稿）/ archived（归档） |
| publishedAt | datetime | 发布时间 |

### 3.2 获取文章详情

```
GET /api/articles/{id}
```

**路径参数：**

| 参数 | 类型 | 说明 |
|------|------|------|
| id | long | 文章 ID |

**响应示例：**

```json
{
  "code": 200,
  "message": "success",
  "data": {
    "article": {
      "id": 1,
      "title": "红海危机延续：主力班轮默认绕行好望角",
      "summary": "...",
      "category": "logi",
      "coverImg": "...",
      "source": "Reuters",
      "sourceUrl": null,
      "meta": "Reuters · Container News · 海运 · 今日",
      "status": "published",
      "publishedAt": "2026-06-08 12:00:00",
      "createdAt": "2026-06-08 12:00:00",
      "updatedAt": "2026-06-08 12:00:00"
    },
    "blocks": [
      {
        "id": 1,
        "articleId": 1,
        "blockType": "kt",
        "content": "胡塞袭扰常态化，好望角成为亚欧默认航线...",
        "sortOrder": 1
      },
      {
        "id": 2,
        "articleId": 1,
        "blockType": "lead",
        "content": "截至 2026 年年中，胡塞武装对红海航运的袭扰...",
        "sortOrder": 2
      }
    ],
    "tags": [
      { "id": 1, "articleId": 1, "tagName": "红海" },
      { "id": 2, "articleId": 1, "tagName": "好望角" }
    ]
  }
}
```

内容块类型（blockType）：

| blockType | 含义 | 样式说明 |
|-----------|------|----------|
| kt | 关键信息 Key Takeaways | 顶部要点列表，深色背景 |
| lead | 引导语 | 加粗引导段落 |
| p | 正文段落 | 普通段落 |
| quote | 引用 | 左侧带竖线的引用块 |

---

## 四、联系我们 API

### 4.1 提交联系表单

```
POST /api/contact
Content-Type: application/json
```

**请求体：**

```json
{
  "name": "张三",
  "company": "某科技有限公司",
  "email": "zhangsan@example.com",
  "phone": "13800138000",
  "message": "我们公司想了解跨境物流解决方案..."
}
```

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| name | string | 否 | 姓名 |
| company | string | 否 | 公司名称 |
| email | string | 否 | 邮箱 |
| phone | string | 否 | 电话 |
| message | string | 否 | 需求描述 |

**响应示例：**

```json
{
  "code": 200,
  "message": "success",
  "data": null
}
```

---

## 五、错误响应

```json
{
  "code": 404,
  "message": "文章不存在",
  "data": null
}
```

```json
{
  "code": 500,
  "message": "服务器异常",
  "data": null
}
```

---

## 六、前端调用示例

```javascript
// 获取首页全部数据一次性渲染
const [hero, crisisCards, carousel, sections] = await Promise.all([
  fetch('/api/home/hero').then(r => r.json()),
  fetch('/api/home/crisis-cards').then(r => r.json()),
  fetch('/api/home/carousel').then(r => r.json()),
  fetch('/api/home/sections').then(r => r.json())
]);

// 获取产品页区块
const { data } = await fetch('/api/page/products').then(r => r.json());
const heroSection = data.find(s => s.section === 'hero');
const modulesSection = data.find(s => s.section === 'modules');

// 获取文章详情（含内容块和标签）
const { data } = await fetch('/api/articles/1').then(r => r.json());
// data.article  - 文章信息
// data.blocks   - 内容块数组（按 sort_order 排序）
// data.tags     - 标签数组
```
