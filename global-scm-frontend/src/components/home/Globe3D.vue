<script setup>
/**
 * Globe3D.vue — 3D 地球可视化组件
 *
 * 基于 three-globe (Globe.gl) 库，在页面上渲染一个可交互的 3D 地球。
 *
 * 地球上的视觉元素：
 *   · 点状标记（ports/事件）     → 港口 & 地震事件
 *   · 脉冲圈（rings）            → 高危/关注区域向外扩散的涟漪
 *   · 飞线（arcs）               → 航线弧线
 *   · 标签（labels）             → 正常港口的文字标签
 *
 * 数据来源：通过 Vue 的 inject 从父组件 RiskDashboard 注入
 *   - riskPoints  : 静态港口 & 风险点（黑海、红海、上海港等）
 *   - riskArcs    : 静态航线弧线
 *   - quakePoints : USGS 实时地震数据（动态刷新）
 *
 * 交互特性：
 *   - 自动旋转（鼠标悬停时暂停，离开后恢复）
 *   - 滚轮缩放
 *   - 拖拽旋转视角
 *   - 悬停点状元素弹出详情提示框
 */

import { ref, onMounted, onUnmounted, inject, watch } from 'vue'

// ── 从父组件注入数据 ──────────────────────────────────
// inject(key, 默认值)  —— Vue3 的依赖注入，类似 React 的 Context
// 父组件 RiskDashboard 通过 provide() 提供这些数据
const riskPoints = inject('riskPoints', [])       // 静态风险点/港口
const riskArcs   = inject('riskArcs', [])         // 静态航线弧线
const quakePoints = inject('quakePoints', ref([])) // USGS 地震点（响应式）

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

  // 筛选"正常"等级的点作为文字标签展示
  const HUBS = riskPoints.filter(d => d.level === 'normal')

  // 链式调用创建 Globe 实例 —— 每个方法都返回 globe 实例本身（Builder 模式）
  globeWorld = Globe()

    // ── 地球纹理贴图 ────────────────────────────────
    .globeImageUrl('https://unpkg.com/three-globe/example/img/earth-blue-marble.jpg')  // 地球卫星图
    .bumpImageUrl('https://unpkg.com/three-globe/example/img/earth-topology.png')      // 凹凸纹理（山脉立体感）
    .backgroundImageUrl('https://unpkg.com/three-globe/example/img/night-sky.png')     // 背景星空

    // ── 大气层（隐藏经纬网格，画面更干净）────────────
    .showGraticules(false)
    .showAtmosphere(true).atmosphereColor('#4da6ff').atmosphereAltitude(0.22)  // 柔和蓝色大气光晕

    // ── 点状数据（港口 + 地震）──────────────────────
    // allPoints() 合并静态点和动态地震点
    .pointsData(allPoints())
    .pointLat('lat').pointLng('lng')           // 指定数据中经纬度字段名
    .pointColor(d => COLORS[d.level])           // 据风险等级染色
    .pointAltitude(d => ALT[d.level] || 0.045)  // 据风险等级决定柱子高度
    .pointRadius(d => d.level === 'high' ? 0.55 : (d.level === 'watch' ? 0.4 : 0.3))  // 等级越大柱越粗
    .pointResolution(32)                        // 多边形面数（更高→更圆滑精致）
    // 悬停时弹出的 HTML 提示框（毛玻璃 + 发光边框风格）
    .pointLabel(d =>
      '<div style="font:500 12.5px sans-serif;color:#fff;' +
      'background:rgba(10,14,26,0.92);padding:6px 10px;border-radius:10px;' +
      'border:1px solid ' + COLORS[d.level] + ';' +
      'box-shadow:0 0 14px ' + COLORS[d.level] + '44;">' +
      d.zh + '</div>'
    )

    // ── 飞线（航线弧线）────────────────────────────
    .arcsData(riskArcs)
    .arcColor('color')                            // 使用数据中的 color 字段（渐变数组）
    .arcStroke(0.55)                              // 线宽
    .arcDashLength(0.5).arcDashGap(0.2)           // 虚线样式：实线长度 / 间隔
    .arcDashAnimateTime(2200)                     // 虚线流动动画周期（ms）
    .arcAltitudeAutoScale(0.42)                   // 弧线高度自动缩放

    // ── 脉冲圈（高危/关注区域的涟漪预警）──────────
    .ringsData(riskPoints.filter(d => d.level !== 'normal'))  // 只给非正常点加脉冲
    // ringColor 接受一个函数，参数 t 从 0→1 表示涟漪从内到外
    .ringColor(d => { const c = COLORS[d.level]; return t => hexToRgba(c, 1 - t) })
    .ringMaxRadius(5.5)                           // 最大扩散半径
    .ringPropagationSpeed(2.8)                    // 扩散速度
    .ringRepeatPeriod(900)                        // 重复周期（ms）

    // ── 标签（正常港口的文字标注）──────────────────
    .labelsData(HUBS)
    .labelLat('lat').labelLng('lng')
    .labelText(d => d.zh)                         // 显示中文名
    .labelSize(0.8).labelDotRadius(0.26)
    .labelColor(() => 'rgba(180,210,255,0.7)')
    .labelResolution(2)

    // 挂载到 DOM 节点
    (el)  // ← Globe() 返回一个函数，传入 DOM 元素完成挂载

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

// ── 合并静态点 + 动态地震点 ─────────────────────────
function allPoints() {
  return [...riskPoints, ...quakePoints.value]
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
    globeWorld.pointsData(all)                          // 更新全部点
    globeWorld.ringsData(all.filter(d => d.level !== 'normal'))  // 更新脉冲圈
  }
}

// watch: 监听 quakePoints 变化（USGS 每60秒拉取一次），自动刷新地球
watch(quakePoints, () => {
  refreshGlobe()
}, { deep: true })  // deep: true 表示深度监听数组/对象内部变化

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
