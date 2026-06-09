<script setup>
/**
 * RiskDashboard.vue — 全球风险地图控制塔（数据中枢）
 *
 * 职责：
 *   1. 从 GDACS 拉取实时灾害数据（洪水/气旋/野火/干旱/火山），替换原有的静态港口风险点
 *   2. 从 USGS 拉取实时地震数据（纯前端直连，无后端中转）
 *   3. 通过 provide() 将数据下发给子组件 Globe3D 和 RiskFeed
 * 子组件关系：
 *   RiskDashboard (provide 数据)
 *     ├── Globe3D   — 3D 地球可视化（inject 数据后渲染）
 *     └── RiskFeed  — 右侧地震快讯面板（inject 数据后列表展示）
 */

import { ref, computed, onMounted, onUnmounted, provide } from 'vue'
import Globe3D from './Globe3D.vue'
import RiskFeed from './RiskFeed.vue'

defineProps({
  feedItems: { type: Array, default: () => [] }  // 后端推送的要闻（当前未使用，保留扩展接口）
})

// ═══════════════════════════════════════════════════════
// 一、GDACS 全球灾害数据（动态——免费、无需密钥）
// ═══════════════════════════════════════════════════════

// GDACS 事件类型 → 中文名
const GDACS_TYPE_ZH = {
  EQ: '地震',
  FL: '洪水',
  TC: '热带气旋',
  VO: '火山喷发',
  DR: '干旱',
  WF: '野火',
  TS: '海啸',
}

// GDACS alert level → 我们的风险等级
function gdacsLevel(alertLevel) {
  if (alertLevel === 'Red')    return 'high'
  if (alertLevel === 'Orange') return 'watch'
  return 'normal'
}

const disasterPoints = ref([])  // GDACS 实时灾害数据（直接提供给 Globe3D 作为 riskPoints）

// ═══════════════════════════════════════════════════════
// 二、全球主要贸易航线（路径固定，颜色动态响应灾害）
// ═══════════════════════════════════════════════════════

// 7 条核心供应链航线（起点 → 终点 + 默认渐变色）
const ARCS = [
  { startLat: 31.23, startLng: 121.47, endLat: 33.75, endLng: -118.19, name: '上海→洛杉矶' },     // 跨太平洋
  { startLat: 31.23, startLng: 121.47, endLat: 53.55, endLng: 9.99,    name: '上海→汉堡' },       // 苏伊士航线
  { startLat: 1.29,  startLng: 103.85, endLat: 51.95, endLng: 4.4,     name: '新加坡→鹿特丹' },   // 马六甲-苏伊士
  { startLat: 31.23, startLng: 121.47, endLat: 1.29,  endLng: 103.85,  name: '上海→新加坡' },     // 亚太支线
  { startLat: 25.27, startLng: 55.30,  endLat: 53.55, endLng: 9.99,    name: '迪拜→汉堡' },       // 中东→欧洲
  { startLat: 35.10, startLng: 129.03, endLat: 33.75, endLng: -118.19, name: '釜山→洛杉矶' },     // 韩美航线
  { startLat: 29.75, startLng: -95.35, endLat: 51.95, endLng: 4.4,     name: '休斯顿→鹿特丹' },   // 跨大西洋
]

// 枢纽港口：航线的起止点去重后作为地球上的核心节点标注
const HUB_PORTS = [
  { lat: 31.23, lng: 121.47, zh: '上海港', en: 'Shanghai' },
  { lat: 33.75, lng: -118.19, zh: '洛杉矶港', en: 'Los Angeles' },
  { lat: 53.55, lng: 9.99, zh: '汉堡港', en: 'Hamburg' },
  { lat: 1.29, lng: 103.85, zh: '新加坡港', en: 'Singapore' },
  { lat: 51.95, lng: 4.4, zh: '鹿特丹港', en: 'Rotterdam' },
  { lat: 25.27, lng: 55.30, zh: '迪拜港', en: 'Dubai' },
  { lat: 35.10, lng: 129.03, zh: '釜山港', en: 'Busan' },
  { lat: 29.75, lng: -95.35, zh: '休斯顿港', en: 'Houston' },
]

// Haversine 球面距离（km）
function haversineKm(lat1, lng1, lat2, lng2) {
  const R = 6371
  const dLat = (lat2 - lat1) * Math.PI / 180
  const dLng = (lng2 - lng1) * Math.PI / 180
  const a = Math.sin(dLat / 2) ** 2 +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLng / 2) ** 2
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
}

// 大圆弧插值：沿航线等距采样 5 个点，用于灾害邻近检测
function sampleGreatCircle(lat1, lng1, lat2, lng2, n = 5) {
  const points = []
  for (let i = 0; i <= n; i++) {
    const t = i / n
    // slerp 在单位球面上插值
    const φ1 = lat1 * Math.PI / 180, λ1 = lng1 * Math.PI / 180
    const φ2 = lat2 * Math.PI / 180, λ2 = lng2 * Math.PI / 180
    const x1 = Math.cos(φ1) * Math.cos(λ1), y1 = Math.cos(φ1) * Math.sin(λ1), z1 = Math.sin(φ1)
    const x2 = Math.cos(φ2) * Math.cos(λ2), y2 = Math.cos(φ2) * Math.sin(λ2), z2 = Math.sin(φ2)
    const dot = x1 * x2 + y1 * y2 + z1 * z2
    const omega = Math.acos(Math.min(1, Math.max(-1, dot)))
    if (Math.abs(omega) < 1e-10) { points.push({ lat: lat1, lng: lng1 }); continue }
    const sinO = Math.sin(omega)
    const a = Math.sin((1 - t) * omega) / sinO
    const b = Math.sin(t * omega) / sinO
    const x = a * x1 + b * x2, y = a * y1 + b * y2, z = a * z1 + b * z2
    points.push({
      lat: Math.atan2(z, Math.sqrt(x * x + y * y)) * 180 / Math.PI,
      lng: Math.atan2(y, x) * 180 / Math.PI,
    })
  }
  return points
}

// 检测航线是否被灾害影响：沿航线采样点，任一灾害在阈值内则命中
const AFFECT_KM = 1200  // 影响半径（公里）

function arcAffectedLevel(arc, disasters) {
  const samples = sampleGreatCircle(arc.startLat, arc.startLng, arc.endLat, arc.endLng, 5)
  let worst = 'normal'
  for (const d of disasters) {
    for (const s of samples) {
      if (haversineKm(s.lat, s.lng, d.lat, d.lng) < AFFECT_KM) {
        if (d.level === 'high') return 'high'
        if (d.level === 'watch') worst = 'watch'
      }
    }
  }
  return worst
}

// 动态航线：默认蓝色，途经灾害区域自动变色
const dynamicArcs = computed(() => {
  const disasters = disasterPoints.value
  return ARCS.map(arc => {
    const level = disasters.length ? arcAffectedLevel(arc, disasters) : 'normal'
    if (level === 'high')   return { ...arc, color: ['#ff3b30', '#ff3b30'] }  // 红色：高危灾害经过
    if (level === 'watch')  return { ...arc, color: ['#ff9500', '#ff9500'] }  // 橙色：关注级灾害
    return { ...arc, color: ['#2997ff', '#5e5ce6'] }                          // 蓝色：畅通
  })
})

// ═══════════════════════════════════════════════════════
// 三、USGS 实时地震数据（纯前端 fetch，每 60 秒刷新）
// ═══════════════════════════════════════════════════════

// USGS 公开 API：返回过去 1 天内全球 2.5 级以上的地震（GeoJSON 格式）
const USGS_URL = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson'

const quakePoints = ref([])   // 地震数据数组（响应式，变化时 Globe3D 自动更新）
const lastUpdated = ref(null) // 最后一次成功获取数据的时间戳
const liveOK      = ref(false)// 数据源是否可用（控制状态指示灯的绿/橙色）

let refreshTimer = null       // 定时器 ID，用于组件销毁时清理

// ── 震级 → 风险等级映射（给地球上的点染色）───────────
function magLevel(m) {
  return m >= 6 ? 'high' : (m >= 4.5 ? 'watch' : 'normal')
}

// ── 拉取 USGS 数据 ───────────────────────────────────
async function fetchQuakes() {
  try {
    const res = await fetch(USGS_URL)              // 前端直连 USGS，无后端代理
    const geo = await res.json()                   // 解析 GeoJSON
    const feats = (geo.features || [])
      .sort((a, b) => b.properties.time - a.properties.time)  // 按时间倒序：最新的在前

    // 取前 80 条，转为 Globe3D 需要的格式
    quakePoints.value = feats.slice(0, 80).map(f => {
      const c   = f.geometry.coordinates           // GeoJSON: [lng, lat, depth]
      const mag = f.properties.mag || 0            // 震级
      return {
        lat: c[1],                                 // 纬度（GeoJSON 坐标数组第 2 位）
        lng: c[0],                                 // 经度（GeoJSON 坐标数组第 1 位）
        level: magLevel(mag),                      // 据震级映射风险等级
        type: 'quake',
        mag,                                       // 震级数值（RiskFeed 展示用）
        time: f.properties.time,                   // 发震时间戳（RiskFeed 展示用）
        place: f.properties.place || 'Unknown',    // 地名（RiskFeed 展示用）
        url: f.properties.url || '',               // USGS 详情页链接
        zh: 'M' + mag.toFixed(1) + ' 地震 · ' + (f.properties.place || ''),  // 悬浮提示中文
        en: 'M' + mag.toFixed(1) + ' quake · ' + (f.properties.place || '')  // 悬浮提示英文
      }
    })

    liveOK.value = true          // 标记数据源正常
    lastUpdated.value = Date.now()  // 记录更新时间
  } catch {
    liveOK.value = false         // 网络异常或 USGS 挂了，显示离线提示
  }
}

// ── 拉取 GDACS 灾害数据（通过 Vite 代理绕过 CORS）───
async function fetchGDACS() {
  try {
    const res = await fetch('/gdacs/xml/rss.xml')
    const xmlText = await res.text()
    const parser = new DOMParser()
    const doc = parser.parseFromString(xmlText, 'text/xml')

    // XML 命名空间
    const geoNS   = 'http://www.w3.org/2003/01/geo/wgs84_pos#'
    const gdacsNS = 'http://www.gdacs.org'

    const disasters = []
    doc.querySelectorAll('item').forEach(item => {
      const eventType = item.getElementsByTagNameNS(gdacsNS, 'eventtype')[0]?.textContent
      if (!eventType || eventType === 'EQ') return

      // ── 坐标：优先用 georss:point（格式 "lat lng"），备选 geo:Point 子元素 ──
      let lat, lng
      const georssEl = item.getElementsByTagNameNS('http://www.georss.org/georss', 'point')[0]
      if (georssEl?.textContent) {
        const parts = georssEl.textContent.trim().split(/\s+/)
        lat = parseFloat(parts[0])
        lng = parseFloat(parts[1])
      }
      // 备选：geo:lat / geo:long
      if (isNaN(lat) || isNaN(lng)) {
        lat = parseFloat(item.getElementsByTagNameNS(geoNS, 'lat')[0]?.textContent)
        lng = parseFloat(item.getElementsByTagNameNS(geoNS, 'long')[0]?.textContent)
      }

      // 严格边界校验：纬度 [-90, 90]，经度 [-180, 180]
      if (isNaN(lat) || isNaN(lng) || lat < -90 || lat > 90 || lng < -180 || lng > 180) return

      // 预警等级、标题、链接
      const alertLevel = item.getElementsByTagNameNS(gdacsNS, 'alertlevel')[0]?.textContent || 'Green'
      const title = item.querySelector('title')?.textContent || ''
      const link  = item.querySelector('link')?.textContent || ''
      const country  = item.getElementsByTagNameNS(gdacsNS, 'country')[0]?.textContent || ''
      const fromDate = item.getElementsByTagNameNS(gdacsNS, 'fromdate')[0]?.textContent || ''
      const populationEl = item.getElementsByTagNameNS(gdacsNS, 'population')[0]
      const population   = populationEl?.textContent || ''
      const severityEl   = item.getElementsByTagNameNS(gdacsNS, 'severity')[0]
      const severity     = severityEl?.textContent || ''

      const typeZh = GDACS_TYPE_ZH[eventType] || eventType
      const time   = new Date(fromDate).getTime()

      disasters.push({
        lat, lng,
        level: gdacsLevel(alertLevel),
        type: eventType,
        typeZh,
        zh: typeZh + ' · ' + country + (severity ? ' · ' + severity : ''),
        en: eventType + ' · ' + country + ' · ' + title,
        url: link,
        time: isNaN(time) ? 0 : time,
        population,
        severity,
      })
    })

    // 按时间倒序，取前 50 条在 3D 地球上展示
    disasters.sort((a, b) => b.time - a.time)
    disasterPoints.value = disasters.slice(0, 50)
  } catch (e) {
    console.warn('GDACS 灾害数据获取失败', e)
  }
}

// ═══════════════════════════════════════════════════════
// 三、依赖注入：将数据下发给所有子组件
// ═══════════════════════════════════════════════════════
provide('riskPoints', disasterPoints)   // GDACS 动态灾害数据（ref 响应式）
provide('riskArcs', dynamicArcs)       // 航线（颜色随灾害动态变化）
provide('hubPorts', HUB_PORTS)         // 枢纽港口标注
provide('quakePoints', quakePoints)   // 响应式 ref，子组件能感知数据变化
provide('liveOK', liveOK)
provide('lastUpdated', lastUpdated)

// ═══════════════════════════════════════════════════════
// 四、生命周期
// ═══════════════════════════════════════════════════════
onMounted(async () => {
  await Promise.all([fetchQuakes(), fetchGDACS()]) // 首次并行拉取 USGS + GDACS
  refreshTimer = setInterval(() => {
    fetchQuakes()
    fetchGDACS()
  }, 60000)  // 每 60 秒自动刷新
})

onUnmounted(() => {
  clearInterval(refreshTimer)  // 组件销毁时清除定时器，防止内存泄漏
})
</script>

<template>
  <section class="section bg-black" id="risk">
    <div class="container">
      <!-- 顶部标题区 -->
      <div class="text-center reveal" style="margin-bottom:48px;">
        <div class="eyebrow">CONTROL TOWER · 全球风险地图</div>
        <h2 class="section-title">实时洞察全球供应链风险</h2>
        <p class="section-sub">实时接入 GDACS 全球灾害（洪水/气旋/野火/干旱/火山）与 USGS 地震数据，高危区域自动高亮预警。</p>
      </div>

      <!-- 主体：3D 地球（左） + 轮播面板（右）-->
      <div class="risk-map reveal">
        <div class="globe-wrap">
          <div id="globeViz"></div>
          <Globe3D />
          <div class="globe-legend">
            <span><i style="background:#ff3b30"></i>高危</span>
            <span><i style="background:#ff9500"></i>关注</span>
            <span><i style="background:#34c759"></i>正常</span>
          </div>
          <div class="globe-hint">拖动旋转 · 悬停查看详情</div>
        </div>

        <!-- 右侧地震快讯面板 -->
        <RiskFeed :feed-items="feedItems" />
      </div>

      <!-- 底部数据来源说明 -->
      <p class="section-sub reveal" style="font-size:13px;margin-top:18px;opacity:0.7;">* 全球灾害数据来自 GDACS（每 60 秒刷新），地震数据来自 USGS，点击条目可跳转官网详情页。</p>
    </div>
  </section>
</template>
