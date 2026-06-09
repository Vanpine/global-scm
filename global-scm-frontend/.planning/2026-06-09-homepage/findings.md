# 技术发现与注意事项

## GDACS 数据解析
- **数据源**: `https://www.gdacs.org/xml/rss.xml`（RSS/XML 格式，非 JSON）
- **CORS**: 无 CORS 头，必须通过 Vite 代理（`/gdacs` → `https://www.gdacs.org`）
- **解析方式**: 浏览器 `DOMParser` + `getElementsByTagNameNS` 处理命名空间
  - `geoNS = 'http://www.w3.org/2003/01/geo/wgs84_pos#'`
  - `gdacsNS = 'http://www.gdacs.org'`
- **坐标**: 优先用 `<georss:point>`（格式 `"lat lng"`），备选 `<geo:Point>` 子元素
- **事件类型**: FL(洪水), TC(气旋), VO(火山), DR(干旱), WF(野火), EQ(地震-跳过), TS(海啸)
- **预警等级**: Green → normal, Orange → watch, Red → high
- **过滤**: EQ 类型跳过（USGS 更精确），坐标必须 lat∈[-90,90], lng∈[-180,180]

## USGS 数据解析
- **数据源**: `https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson`
- **CORS**: ✅ 支持
- **坐标顺序**: GeoJSON 是 `[lng, lat, depth]`，需要交换为 `{lat, lng}`
- **震级映射**: ≥6→high, ≥4.5→watch, 其余→normal

## Globe.gl (Three-globe) 关键 API
- **数据格式**: 所有数据方法接受对象数组，通过 `.pointLat('lat')` 等指定字段名
- **Builder 模式**: `Globe().method1().method2()...(el)` 链式调用
- **动态更新**: 通过 `.pointsData()`、`.arcsData()` 等方法重新设置数据
- **COMREF 陷阱**: Vue 的 `computed`/`ref` 传给 Globe.gl 时必须 `.value` 解包，否则 lib 收到 RefImpl 对象
- **中文字体**: Globe.gl 默认位图字体不支持中文，标签显示为 `???`，需用英文
- **呼吸动画**: `pointAltitude(getterFn)` 的 getter 每帧调用，可用 `Date.now()` 做时间驱动

## CarouselBanner 无限循环机制
- 扩展数组: `[last, ...slides, first]`，初始 index=1
- 过渡结束后检测是否在克隆位置，是则瞬间跳转（transition: none）
- `isTransitioning` 锁防止快速点击越界白屏

## StatsBar 数值解析
- 后端返回 `{"value": "≤55天"}` 等含前缀/后缀的字符串
- 不能用 `parseInt()`，必须用正则 `/(\d+\.?\d*)/` 提取数字
- `parseStatValue()` 返回 `{num, prefix, suffix}` 分别渲染

## Vite 配置
- 端口: 5173
- `/api` → `http://localhost:8080`（后端代理）
- `/gdacs` → `https://www.gdacs.org`（GDACS CORS 代理）
