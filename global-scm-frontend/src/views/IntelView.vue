<script setup>
import { ref, reactive, watch, onMounted, onUnmounted, nextTick } from 'vue'
import { getArticles } from '@/api/article'
import { useScrollReveal } from '@/composables/useScrollReveal'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

const { t, locale } = useI18n()
const router = useRouter()
const loading = ref(true)

// ==================== 分类映射 ====================
const CAT_LABELS = { war: 'intel.catWar', logi: 'intel.catLogi', energy: 'intel.catEnergy', policy: 'intel.catPolicy' }
const CAT_MAP = {
  war:    { css: 'war',    icon: `<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>` },
  logi:   { css: 'logi',   icon: `<rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/>` },
  energy: { css: 'energy', icon: `<polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/>` },
  policy: { css: 'policy', icon: `<line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>` },
}
const CAT_ORDER = ['war', 'logi', 'energy', 'policy']

// ==================== 每个分类的文章数据 ====================
const catState = reactive({})
for (const cat of CAT_ORDER) {
  catState[cat] = { articles: [] }
}

const { refresh: refreshReveal } = useScrollReveal()

// ═══════════════════════════════════════════════════════
// 2D Leaflet 地图 — GDACS 灾害 + USGS 地震
// ═══════════════════════════════════════════════════════

let mapInstance = null
let disasterLayer = null
let quakeLayer = null
let tileLayer = null
let mapTimer = null

const darkMode = ref(false)

const TILE_DARK  = 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
const TILE_LIGHT = 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png'

const GDACS_TYPE_ZH = { EQ: '地震', FL: '洪水', TC: '热带气旋', VO: '火山喷发', DR: '干旱', WF: '野火', TS: '海啸' }
const USGS_URL = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson'

function gdacsLevel(alertLevel) {
  if (alertLevel === 'Red') return 'high'
  if (alertLevel === 'Orange') return 'watch'
  return 'normal'
}

function magLevel(m) {
  return m >= 6 ? 'high' : (m >= 4.5 ? 'watch' : 'normal')
}

// 风险等级 → 圆圈颜色
const LEVEL_COLOR = { high: '#ff3b30', watch: '#ff9500', normal: '#34c759' }
const LEVEL_RADIUS = { high: 9, watch: 7, normal: 5 }

function makeCircleMarker(lat, lng, level, popupHtml) {
  const color = LEVEL_COLOR[level] || LEVEL_COLOR.normal
  const classes = level !== 'normal' ? 'pulse-marker pulse-' + level : ''
  return L.circleMarker([lat, lng], {
    radius: LEVEL_RADIUS[level] || 5,
    fillColor: color,
    color: '#fff',
    weight: 1.5,
    fillOpacity: 0.85,
    className: classes,
  }).bindTooltip(popupHtml, {
    direction: 'top',
    offset: [0, -8],
    opacity: 0.92,
    sticky: true,
  })
}

// ── 拉取 GDACS 灾害数据 ──
async function fetchGDACS() {
  try {
    const res = await fetch('/gdacs/xml/rss.xml')
    const xmlText = await res.text()
    const parser = new DOMParser()
    const doc = parser.parseFromString(xmlText, 'text/xml')
    const geoNS = 'http://www.w3.org/2003/01/geo/wgs84_pos#'
    const gdacsNS = 'http://www.gdacs.org'

    const markers = []
    doc.querySelectorAll('item').forEach(item => {
      const eventType = item.getElementsByTagNameNS(gdacsNS, 'eventtype')[0]?.textContent
      if (!eventType || eventType === 'EQ') return

      const pointEl = item.getElementsByTagNameNS(geoNS, 'Point')[0]
      const latEl = pointEl?.getElementsByTagNameNS(geoNS, 'lat')[0]
      const lngEl = pointEl?.getElementsByTagNameNS(geoNS, 'long')[0]
      const lat = parseFloat(latEl?.textContent)
      const lng = parseFloat(lngEl?.textContent)
      if (isNaN(lat) || isNaN(lng) || lat < -90 || lat > 90 || lng < -180 || lng > 180) return

      const alertLevel = item.getElementsByTagNameNS(gdacsNS, 'alertlevel')[0]?.textContent || 'Green'
      const title = item.querySelector('title')?.textContent || ''
      const country = item.getElementsByTagNameNS(gdacsNS, 'country')[0]?.textContent || ''
      const typeZh = GDACS_TYPE_ZH[eventType] || eventType
      const level = gdacsLevel(alertLevel)
      const popup = `<b>${typeZh}</b><br>${title}<br><small>${country} · ${alertLevel}</small>`

      markers.push(makeCircleMarker(lat, lng, level, popup))
    })
    return markers
  } catch (e) {
    console.warn('GDACS 灾害数据获取失败', e)
    return []
  }
}

// ── 拉取 USGS 地震数据 ──
async function fetchUSGS() {
  try {
    const res = await fetch(USGS_URL)
    const geo = await res.json()
    return (geo.features || []).slice(0, 60).map(f => {
      const [lng, lat] = f.geometry.coordinates
      const mag = f.properties.mag || 0
      const place = f.properties.place || ''
      const level = magLevel(mag)
      const popup = `<b>M${mag.toFixed(1)} 地震</b><br>${place}`
      return makeCircleMarker(lat, lng, level, popup)
    })
  } catch (e) {
    console.warn('USGS 地震数据获取失败', e)
    return []
  }
}

// ── 刷新地图数据 ──
async function refreshMap() {
  if (!mapInstance) return
  const [disasters, quakes] = await Promise.all([fetchGDACS(), fetchUSGS()])
  if (disasterLayer) mapInstance.removeLayer(disasterLayer)
  if (quakeLayer) mapInstance.removeLayer(quakeLayer)
  disasterLayer = L.layerGroup(disasters).addTo(mapInstance)
  quakeLayer = L.layerGroup(quakes).addTo(mapInstance)
}

// ── 初始化地图 ──
function initMap() {
  const el = document.getElementById('riskLeaflet')
  if (!el) return
  mapInstance = L.map(el, {
    center: [20, 0],
    zoom: 2,
    minZoom: 2,
    maxZoom: 12,
    maxBounds: [[-85, -180], [85, 180]],
    maxBoundsViscosity: 0.8,
    zoomControl: true,
    attributionControl: false,
    scrollWheelZoom: true,
    worldCopyJump: true,
  })

  // 地图瓦片（默认暗色）
  tileLayer = L.tileLayer(darkMode.value ? TILE_DARK : TILE_LIGHT, {
    maxZoom: 18,
    noWrap: false,
  }).addTo(mapInstance)

  refreshMap()
  mapTimer = setInterval(refreshMap, 60000)
}

function toggleMapTheme() {
  if (!tileLayer || !mapInstance) return
  darkMode.value = !darkMode.value
  mapInstance.removeLayer(tileLayer)
  tileLayer = L.tileLayer(darkMode.value ? TILE_DARK : TILE_LIGHT, {
    maxZoom: 18,
    noWrap: false,
  }).addTo(mapInstance)
}

function destroyMap() {
  clearInterval(mapTimer)
  if (mapInstance) {
    mapInstance.remove()
    mapInstance = null
  }
}

// ═══════════════════════════════════════════════════════

async function loadData() {
  loading.value = true
  const promises = CAT_ORDER.map(async cat => {
    const result = await getArticles(cat)
    if (result && result.records) {
      catState[cat].articles = result.records
    }
  })
  await Promise.all(promises)
  loading.value = false
  await nextTick()
  refreshReveal()
}

onMounted(async () => {
  await loadData()
  initMap()
})

watch(locale, loadData)

onUnmounted(() => {
  destroyMap()
})
</script>

<template>
  <!-- ═══ Hero ═══ -->
  <section class="hero" style="min-height:100vh; height:100vh;">
    <img class="hero-video" src="https://images.unsplash.com/photo-1450101499163-c8848c66ca85?auto=format&fit=crop&w=1920&q=85" alt="" style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none;">
    <div class="hero-overlay"></div>
    <div class="hero-content">
      <h1>{{ t('intel.heroTitle1') }}<span>{{ t('intel.heroTitle2') }}</span></h1>
      <p class="lead">{{ t('intel.heroLead') }}</p>
      <p class="hero-sub">
        <span><svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 6h16"/><path d="M4 10h16"/><path d="M4 14h8"/><path d="M4 18h5"/><rect x="14" y="14" width="6" height="6" rx="1"/></svg> {{ t('intel.policy') }}</span>
        <span><svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg> {{ t('intel.geo') }}</span>
        <span><svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg> {{ t('intel.logistics') }}</span>
      </p>
    </div>
  </section>

  <!-- ═══ 全球情报要闻 ═══ -->
  <section class="section news-hub" id="news" style="padding-bottom:56px;">
    <div class="container">
      <!-- 加载中 -->
      <div v-if="loading" style="text-align:center;padding:80px 0;color:var(--text-secondary);">{{ t('intel.loading') }}</div>

      <div v-else class="news-group reveal" v-for="(cat, gi) in CAT_ORDER" :key="gi">
        <!-- 只渲染有文章的分类，空分类不显示空白区域 -->
        <template v-if="catState[cat].articles.length">
          <h3 class="news-group-title">
            <svg class="icon-svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="CAT_MAP[cat].icon"></svg>
            {{ t(CAT_LABELS[cat]) }}
          </h3>
          <div class="news-grid">
            <div class="news-card" v-for="(article, ai) in catState[cat].articles" :key="ai"
                 @click="router.push('/news/' + article.id)" style="cursor:pointer;">
              <div class="news-thumb">
                <img :src="article.coverImg" alt="" loading="lazy" onerror="this.onerror=null;this.style.display='none';this.parentNode.classList.add('noimg')">
                <span :class="'news-cat ' + CAT_MAP[cat].css">{{ t(CAT_LABELS[cat]) }}</span>
              </div>
              <div class="news-info">
                <h3>{{ article.title }}</h3>
                <p class="news-sum">{{ article.summary }}</p>
                <div class="news-foot">
                  <span class="news-meta">{{ article.meta }}</span>
                  <span class="news-more">{{ t('intel.readDetail') }}</span>
                </div>
              </div>
            </div>
          </div>
        </template>
      </div>
      <p class="news-disclaimer reveal">{{ t('intel.disclaimer') }}</p>
    </div>
  </section>

  <!-- ═══ 可缩放世界地图 ═══ -->
  <section class="section" style="padding-top:56px;">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <div class="eyebrow">RISK HEATMAP · REAL-TIME SITUATIONAL AWARENESS</div>
        <h2 class="section-title">{{ t('intel.heatmap') }}</h2>
        <p class="section-sub">{{ t('intel.heatmapDesc') }}</p>
      </div>
      <div class="leaflet-wrap reveal">
        <div id="riskLeaflet"></div>
        <button class="map-theme-btn" @click="toggleMapTheme" :title="darkMode ? t('intel.mapThemeDay') : t('intel.mapThemeNight')">
          {{ darkMode ? '🌙' : '☀️' }}
        </button>
        <div class="map-legend">
          <span><i style="background:#ff3b30"></i>{{ t('intel.high') }}</span>
          <span><i style="background:#ff9500"></i>{{ t('intel.watch') }}</span>
          <span><i style="background:#34c759"></i>{{ t('intel.normal') }}</span>
        </div>
      </div>
      <p class="section-sub reveal" style="font-size:13px;margin-top:18px;opacity:0.7;">{{ t('intel.dataSource') }}</p>
    </div>
  </section>
</template>
