# Global SCM Frontend - 首页开发任务

## 目标
优化全球供应链前端首页，包含 3D 地球可视化、实时灾害/地震数据、轮播图、统计指标等模块。

## 数据源
- **GDACS RSS** → 全球灾害（洪水/气旋/野火/干旱/火山），通过 Vite 代理 `/gdacs` 绕过 CORS
- **USGS GeoJSON** → 全球地震（2.5 级以上），前端直连

---

## Phase 1: RiskFeed 卡片优化 ✅
- 减少留白，flex column + space-evenly 分布 7 条地震数据
- mag-badge 加宽 (54×34px)，字体缩小 (12.5px)
- "更新于" 时间戳移到右侧（justify-content: space-between）

## Phase 2: 3D 地球优化 ✅
- 隐藏经纬网格（showGraticules(false)）
- 柔和大气层
- 鼠标悬停暂停旋转，离开恢复
- 中文注释所有代码

## Phase 3: Hero 视频 ✅
- 使用本地 MP4：`public/vedio.mp4`，路径 `/vedio.mp4`

## Phase 4: StatsBar 数值解析修复 ✅
- `parseInt("≤55天")` 返回 NaN 导致显示 0
- 修复：用正则 `/(\d+\.?\d*)/` 提取数字，支持 `≤55天`、`90%+`、`≤4h` 等格式

## Phase 5: 轮播图优化 ✅
- 鼠标悬停暂停计时（@mouseenter/@mouseleave）
- 无限循环：首尾克隆 + transitionend 检测 + 瞬间跳转
- 快速点击防越界白屏（isTransitioning 锁）

## Phase 6: 数据动态化 ✅
- 删除所有静态港口/风险点
- 接入 GDACS XML → 解析为 disasterPoints（ref）
- 接入 USGS → quakePoints（ref）
- 每 60 秒并行刷新
- 使用 georss:point 为主要坐标源，严格边界校验 [-90,90] [-180,180]

## Phase 7: 点状柱呼吸动画 ✅
- 统一频率，振幅按风险等级区分：
  - high: ±0.035, watch: ±0.022, normal: ±0.012
- 移除常驻文字标签，仅保留悬停 tooltip
- pointResolution 提升到 48

## Phase 8: 动态航线 ✅
- 7 条核心贸易航线（上海→洛杉矶、上海→汉堡 等）
- 航线颜色随 GDACS 灾害数据动态变化：
  - 默认蓝色 → 灾害附近(watch) → 橙色 → 灾害附近(high) → 红色
- Haversine 公式计算灾害点到航线采样点的距离（阈值 1200km）
- 8 个枢纽港口英文标注（Shanghai, Los Angeles 等）

## Phase 9: 待定
- 暂无

---

## 关键文件
| 文件 | 用途 |
|------|------|
| `src/components/home/Globe3D.vue` | 3D 地球渲染（Three-globe） |
| `src/components/home/RiskDashboard.vue` | 数据中枢（provide GDACS + USGS + 动态航线） |
| `src/components/home/RiskFeed.vue` | 右侧地震快讯面板 |
| `src/components/home/CarouselBanner.vue` | 无限循环轮播图 |
| `src/components/home/StatsBar.vue` | 统计指标条（含 parseStatValue） |
| `src/components/home/HeroSection.vue` | 首页视频头图 |
| `src/views/HomeView.vue` | 首页主视图 |
| `src/assets/style.css` | 全局样式（含 carousel-track transition） |
| `vite.config.js` | Vite 配置（含 /api 和 /gdacs 代理） |
