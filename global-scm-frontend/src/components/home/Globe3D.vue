<script setup>
/**
 * Globe3D.vue — 3D 地球可视化组件
 *
 * 基于 three-globe (Globe.gl) 库，在页面上渲染一个可交互的 3D 地球。
 *
 * 地球上的视觉元素：
 *   · 点状柱（points）           → GDACS 灾害 + USGS 地震（动态呼吸起伏）
 *   · 脉冲圈（rings）            → 高危/关注区域向外扩散的涟漪
 *
 * 数据来源：通过 Vue 的 inject 从父组件 RiskDashboard 注入（全部动态，无静态数据）
 *   - riskPoints  : GDACS 实时灾害数据（ref 响应式）
 *   - quakePoints : USGS 实时地震数据（ref 响应式）
 *
 * 交互特性：
 *   - 自动旋转（鼠标悬停时暂停，离开后恢复）
 *   - 滚轮缩放
 *   - 拖拽旋转视角
 *   - 悬停点状元素弹出毛玻璃发光提示框
 */

import { ref, onMounted, onUnmounted, inject, watch } from 'vue'

// ── 从父组件注入数据 ──────────────────────────────────
// inject(key, 默认值)  —— Vue3 的依赖注入，类似 React 的 Context
// 父组件 RiskDashboard 通过 provide() 提供这些数据
const riskPoints = inject('riskPoints', ref([]))  // GDACS 实时灾害点（响应式 ref）
const riskArcs   = inject('riskArcs', ref([]))   // 航线弧线（ComputedRef，颜色随灾害动态变化）
const hubPorts    = inject('hubPorts', [])          // 枢纽港口标注（静态）
const quakePoints = inject('quakePoints', ref([])) // USGS 地震点（响应式 ref）

// ── 颜色 & 高度映射 ──────────────────────────────────
// 根据风险等级返回对应颜色和地球表面凸起高度
const COLORS = { high: '#ff3b30', watch: '#ff9500', normal: '#34c759' }
const ALT = { high: 0.18, watch: 0.11, normal: 0.045 }  // 单位：地球半径比

let globeWorld = null  // 保存 Globe 实例引用，用于后续更新

// ── 工具函数：HEX 颜色 → RGBA（用于脉冲圈渐变）──────
function hexToRgba(hex, a) {
  const n = parseInt(hex.slice(1), 16)
  return 'rgba(' + ((n >> 16) & 255) + ',' + ((n >> 8) & 255) + ',' + (n & 255) + ',' + a + ')'
}

// ── 鼠标事件：悬停暂停旋转 / 离开恢复旋转 ────────────
function onMouseEnter() {
  if (globeWorld && globeWorld.controls()) {
    globeWorld.controls().autoRotate = false
  }
}
function onMouseLeave() {
  if (globeWorld && globeWorld.controls()) {
    globeWorld.controls().autoRotate = true
  }
}

// ── 初始化 3D 地球（核心）────────────────────────────
function initGlobe() {
  // 获取父组件中预留的挂载容器 DOM 节点
  const el = document.getElementById('globeViz')
  if (!el || typeof Globe === 'undefined') return  // Globe 库未加载则退出

  // 链式调用创建 Globe 实例 —— 每个方法都返回 globe 实例本身（Builder 模式）
  const startTime = Date.now()  // 记录初始化时间，用于点状柱呼吸动画
  globeWorld = Globe()

    // ── 地球纹理贴图 ────────────────────────────────
    .globeImageUrl('https://unpkg.com/three-globe/example/img/earth-blue-marble.jpg')
    .bumpImageUrl('https://unpkg.com/three-globe/example/img/earth-topology.png')
    .backgroundImageUrl('https://unpkg.com/three-globe/example/img/night-sky.png')

    // ── 大气层（隐藏经纬网格，画面更干净）────────────
    .showGraticules(false)
    .showAtmosphere(true).atmosphereColor('#4da6ff').atmosphereAltitude(0.22)

    // ── 点状数据（GDACS 灾害 + USGS 地震）───────────
    .pointsData(allPoints())
    .pointLat('lat').pointLng('lng')
    .pointColor(d => COLORS[d.level])
    // 高度动态呼吸：统一频率，振幅按等级区分（高危→大波动，正常→微波动）
    .pointAltitude(d => {
      const base = ALT[d.level] || 0.045
      const t = (Date.now() - startTime) * 0.001                       // 统一时间基准
      const amp = d.level === 'high' ? 0.035 : (d.level === 'watch' ? 0.022 : 0.012)
      return base + Math.sin(t * 2.0) * amp                            // 全点同频同相，等级决定波动大小
    })
    .pointRadius(d => d.level === 'high' ? 0.55 : (d.level === 'watch' ? 0.4 : 0.3))
    .pointResolution(48)  // 更高的面数 → 柱体更圆润光滑
    // 悬停提示框（仅鼠标悬停时弹出，不污染画面）
    .pointLabel(d =>
      '<div style="font:500 12.5px sans-serif;color:#fff;' +
      'background:rgba(10,14,26,0.92);padding:8px 12px;border-radius:10px;' +
      'border:1px solid ' + COLORS[d.level] + ';' +
      'box-shadow:0 0 18px ' + COLORS[d.level] + '55, inset 0 0 8px ' + COLORS[d.level] + '15;">' +
      d.zh + '</div>'
    )

    // ── 航线弧线（默认蓝，途经灾害区域自动变红/橙）──
    .arcsData(riskArcs.value)
    .arcColor('color')
    .arcStroke(0.7)
    .arcDashLength(0.6).arcDashGap(0.25)
    .arcDashAnimateTime(1800)
    .arcAltitudeAutoScale(0.45)

    // ── 枢纽港口文字标注（航线起止点）──────────────
    .labelsData(hubPorts)
    .labelLat('lat').labelLng('lng')
    .labelText(d => d.en)
    .labelSize(1.1).labelDotRadius(0.35)
    .labelColor(() => 'rgba(180,210,255,0.85)')
    .labelResolution(3)

    // ── 脉冲圈（高危/关注区域向外扩散涟漪）──────────
    .ringsData(riskPoints.value.filter(d => d.level !== 'normal'))
    .ringColor(d => { const c = COLORS[d.level]; return t => hexToRgba(c, 1 - t) })
    .ringMaxRadius(5.5)
    .ringPropagationSpeed(2.8)
    .ringRepeatPeriod(900)

    // 挂载到 DOM 节点
    (el)

  // ── 相机控制 ──────────────────────────────────────
  globeWorld.controls().autoRotate = true         // 自动旋转
  globeWorld.controls().autoRotateSpeed = 0.5     // 旋转速度
  globeWorld.controls().enableZoom = true         // 允许缩放
  globeWorld.controls().minDistance = 170         // 最近缩放距离
  globeWorld.controls().maxDistance = 520         // 最远缩放距离
  globeWorld.pointOfView({ lat: 22, lng: 55, altitude: 1.9 })  // 初始视角（中东上空）

  // ── 鼠标悬停暂停旋转 ──────────────────────────────
  el.addEventListener('mouseenter', onMouseEnter)  // 鼠标进入 → 停止旋转
  el.addEventListener('mouseleave', onMouseLeave)  // 鼠标离开 → 恢复旋转

  // 初始大小 & 监听窗口变化自适应
  resize()
  window.addEventListener('resize', resize)
}

// ── 合并灾害点 + 地震点 ─────────────────────────
function allPoints() {
  return [...riskPoints.value, ...quakePoints.value]
}

// ── 响应窗口大小变化 ─────────────────────────────────
function resize() {
  const el = document.getElementById('globeViz')
  if (!el || !globeWorld) return
  const w = el.clientWidth || el.parentElement?.clientWidth || 600
  globeWorld.width(w)
  globeWorld.height(el.clientHeight || 600)
}

// ── 地震数据更新时，刷新地球上的点和脉冲圈 ─────────────
function refreshGlobe() {
  if (globeWorld) {
    const all = allPoints()
    globeWorld.pointsData(all)
    globeWorld.ringsData(all.filter(d => d.level !== 'normal'))
    globeWorld.arcsData(riskArcs.value)  // 航线颜色随灾害动态更新
  }
}

// watch: 监听 quakePoints 和 riskPoints 变化，数据更新时自动刷新地球
watch([quakePoints, riskPoints, riskArcs], () => {
  refreshGlobe()
}, { deep: true })

// ── 生命周期 ────────────────────────────────────────
onMounted(() => {
  // 延迟 200ms 确保 DOM 和 Globe 库都就绪
  setTimeout(initGlobe, 200)
})

onUnmounted(() => {
  window.removeEventListener('resize', resize)  // 清理窗口 resize 监听

  // 清理鼠标悬停监听，防止内存泄漏
  const el = document.getElementById('globeViz')
  if (el) {
    el.removeEventListener('mouseenter', onMouseEnter)
    el.removeEventListener('mouseleave', onMouseLeave)
  }
})
</script>

<template>
  <!-- Globe3D 直接挂载到父组件的 #globeViz 容器上，自己不渲染 DOM -->
  <div style="display:none"></div>
</template>
