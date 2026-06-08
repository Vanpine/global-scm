<script setup>
/**
 * RiskDashboard.vue — 全球风险地图控制塔（数据中枢）
 *
 * 职责：
 *   1. 定义静态演示数据（全球主要港口、风险区域、航线）
 *   2. 从 USGS 拉取实时地震数据（纯前端直连，无后端中转）
 *   3. 通过 provide() 将数据下发给子组件 Globe3D 和 RiskFeed
 *
 * 子组件关系：
 *   RiskDashboard (provide 数据)
 *     ├── Globe3D   — 3D 地球可视化（inject 数据后渲染）
 *     └── RiskFeed  — 右侧地震快讯面板（inject 数据后列表展示）
 */

import { ref, onMounted, onUnmounted, provide } from 'vue'
import Globe3D from './Globe3D.vue'
import RiskFeed from './RiskFeed.vue'

defineProps({
  feedItems: { type: Array, default: () => [] }  // 后端推送的要闻（当前未使用，保留扩展接口）
})

// ═══════════════════════════════════════════════════════
// 一、静态演示数据（写死在前端，不依赖后端）
// ═══════════════════════════════════════════════════════

// ── 全球关键节点（港口 / 风险区域）────────────────────
// level 等级：high=高危  watch=关注  normal=正常
// 这些数据会被 Globe3D 渲染为地球上的点状柱子、脉冲圈和文字标签
const POINTS = [
  { lat: 48.4,  lng: 35.0,   level: 'high',   zh: '黑海航线中断风险',       en: 'Black Sea route disruption' },
  { lat: 15.0,  lng: 42.0,   level: 'high',   zh: '红海 / 曼德海峡航线告警',  en: 'Red Sea / Bab-el-Mandeb alert' },
  { lat: 33.75, lng: -118.19, level: 'high',   zh: '美西长滩港罢工 · 滞港',   en: 'Long Beach strike · congestion' },
  { lat: 9.1,   lng: -79.7,  level: 'watch',  zh: '巴拿马运河干旱限航',       en: 'Panama Canal drought limits' },
  { lat: 30.0,  lng: 32.35,  level: 'watch',  zh: '苏伊士运河通航关注',       en: 'Suez Canal transit watch' },
  { lat: 24.5,  lng: 119.5,  level: 'watch',  zh: '台湾海峡局势关注',         en: 'Taiwan Strait watch' },
  { lat: 1.29,  lng: 103.85, level: 'normal', zh: '新加坡枢纽港',             en: 'Singapore' },
  { lat: 31.23, lng: 121.47, level: 'normal', zh: '上海港',                   en: 'Shanghai' },
  { lat: 53.55, lng: 9.99,   level: 'normal', zh: '汉堡港',                   en: 'Hamburg' },
  { lat: 25.27, lng: 55.30,  level: 'normal', zh: '迪拜杰贝阿里港',           en: 'Dubai' }
]

// ── 航线弧线（起点 → 终点 + 渐变色）──────────────────
// color 数组 [起始色, 结束色] 给 arcDashAnimateTime 动画用
const ARCS = [
  { startLat: 31.23, startLng: 121.47, endLat: 33.75, endLng: -118.19, color: ['#ff3b30', '#ff9500'] },  // 上海→长滩
  { startLat: 31.23, startLng: 121.47, endLat: 53.55, endLng: 9.99,    color: ['#ff9500', '#ff3b30'] },  // 上海→汉堡
  { startLat: 1.29,  startLng: 103.85, endLat: 51.95, endLng: 4.4,     color: ['#ff9500', '#ff3b30'] },  // 新加坡→鹿特丹
  { startLat: 31.23, startLng: 121.47, endLat: 1.29,  endLng: 103.85,  color: ['#2997ff', '#2997ff'] },  // 上海→新加坡
  { startLat: 25.27, startLng: 55.30,  endLat: 53.55, endLng: 9.99,    color: ['#2997ff', '#5e5ce6'] }   // 迪拜→汉堡
]

// ═══════════════════════════════════════════════════════
// 二、USGS 实时地震数据（纯前端 fetch，每 60 秒刷新）
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

// ═══════════════════════════════════════════════════════
// 三、依赖注入：将数据下发给所有子组件
// ═══════════════════════════════════════════════════════
// provide(key, value) — 父组件"提供"数据
// 子组件用 inject(key) 获取，无需层层传递 props
provide('riskPoints', POINTS)
provide('riskArcs', ARCS)
provide('quakePoints', quakePoints)   // 响应式 ref，子组件能感知数据变化
provide('liveOK', liveOK)
provide('lastUpdated', lastUpdated)

// ═══════════════════════════════════════════════════════
// 四、生命周期
// ═══════════════════════════════════════════════════════
onMounted(async () => {
  await fetchQuakes()                              // 首次加载立刻拉取
  refreshTimer = setInterval(fetchQuakes, 60000)   // 之后每 60 秒自动刷新
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
        <p class="section-sub">实时监测地缘冲突、港口拥堵、极端天气与政策变化，高危区域自动高亮预警。</p>
      </div>

      <!-- 主体：3D 地球（左） + 地震快讯面板（右）-->
      <div class="risk-map reveal">
        <div class="globe-wrap">
          <!-- 地球挂载容器：Globe3D 组件会在这个 div 里渲染 Three.js 画布 -->
          <div id="globeViz"></div>
          <Globe3D />

          <!-- 地球左下角图例 -->
          <div class="globe-legend">
            <span><i style="background:#ff3b30"></i>高危</span>
            <span><i style="background:#ff9500"></i>关注</span>
            <span><i style="background:#34c759"></i>正常</span>
          </div>
          <!-- 地球右上角操作提示 -->
          <div class="globe-hint">拖动旋转 · 悬停查看详情</div>
        </div>

        <!-- 右侧地震快讯面板 -->
        <RiskFeed :feed-items="feedItems" />
      </div>

      <!-- 底部数据来源说明 -->
      <p class="section-sub reveal" style="font-size:13px;margin-top:18px;opacity:0.7;">* 全球地震数据来自 USGS 实时接口（纯前端直连，每 60 秒自动刷新），点击条目可跳转 USGS 官网详情页。</p>
    </div>
  </section>
</template>
