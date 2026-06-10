<script setup>
import { ref, watch, onMounted, nextTick } from 'vue'
import { getPageSections } from '@/api/page'
import { useScrollReveal } from '@/composables/useScrollReveal'
import { useI18n } from 'vue-i18n'

const { t, locale } = useI18n()

const sections = ref([])

async function loadData() {
  sections.value = await getPageSections('products') || []
  await nextTick()
  refreshReveal()
}

onMounted(loadData)
watch(locale, loadData)

const { refresh: refreshReveal } = useScrollReveal()

function findSection(code) {
  return sections.value.find(s => s.section === code)
}

function parseItems(json) {
  try { return JSON.parse(json || '[]') } catch { return [] }
}

// ── 流程节点图标映射（按索引 0–5）────────────────────
const FLOW_ICONS = [
  // 找供应商 — 搜索
  `<circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>`,
  // 下采购单 — 剪贴板
  `<path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><rect x="8" y="2" width="8" height="4" rx="1"/>`,
  // 管仓储 — 箱子
  `<path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/>`,
  // 管订单 — 书本
  `<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/><line x1="8" y1="7" x2="16" y2="7"/><line x1="8" y1="11" x2="16" y2="11"/><line x1="8" y1="15" x2="12" y2="15"/>`,
  // 追物流 — 卡车
  `<rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/>`,
  // 报关务 — 文档
  `<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/>`,
]

// ── 模块卡片图标映射（按 mod.id）────────────────────
const MODULE_ICONS = {
  supplier:   `<path d="M2 20a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8l-7 5V8l-7 5V4l-6 4v12z"/>`,
  procurement:`<path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><rect x="8" y="2" width="8" height="4" rx="1"/>`,
  wms:        `<path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/>`,
  oms:        `<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/><line x1="8" y1="7" x2="16" y2="7"/><line x1="8" y1="11" x2="16" y2="11"/><line x1="8" y1="15" x2="12" y2="15"/>`,
  tms:        `<rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/>`,
  customs:    `<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/>`,
}

// ── Hero 标签图标映射（按 icon 字段）─────────────────
const HERO_ICONS = {
  package:   `<path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/><polyline points="3.27 6.96 12 12.01 20.73 6.96"/><line x1="12" y1="22.08" x2="12" y2="12"/>`,
  warehouse: `<path d="M2 20a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8l-7 5V8l-7 5V4l-6 4v12z"/>`,
  truck:     `<rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/>`,
  'file-text': `<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/>`,
}

// ── 增值模块图标 ──────────────────────────────────
const BEYOND_ICONS = {
  shuffle: `<polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/>`,
  chart:   `<line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>`,
}

// ── AI 引擎图标映射（按索引 0–5）───────────────────
const AI_ICONS = [
  // AI Copilot — CPU/Chip
  `<rect x="4" y="4" width="16" height="16" rx="2"/><rect x="9" y="9" width="6" height="6"/><line x1="9" y1="1" x2="9" y2="4"/><line x1="15" y1="1" x2="15" y2="4"/><line x1="9" y1="20" x2="9" y2="23"/><line x1="15" y1="20" x2="15" y2="23"/><line x1="20" y1="9" x2="23" y2="9"/><line x1="20" y1="14" x2="23" y2="14"/><line x1="1" y1="9" x2="4" y2="9"/><line x1="1" y1="14" x2="4" y2="14"/>`,
  // 需求预测 — Trending Up
  `<polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/>`,
  // 风险识别 — Alert Triangle
  `<path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>`,
  // TCO 优化 — Dollar Sign
  `<line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>`,
  // 排程仿真 — Activity / Pulse
  `<polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>`,
  // 决策推荐 — Crosshair
  `<circle cx="12" cy="12" r="10"/><polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"/>`,
]
</script>

<template>
  <!-- ═══ Hero：全屏图片背景 ═══ -->
  <section class="hero" style="min-height:100vh; height:100vh;" v-if="findSection('hero')">
    <img class="hero-video" src="https://images.unsplash.com/photo-1606964212858-c215029db704?auto=format&fit=crop&w=1920&q=85" alt="" style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none;">
    <div class="hero-overlay"></div>
    <div class="hero-content">
      <h1>{{ t('products.heroTitle1') }}<span>{{ t('products.heroTitle2') }}</span></h1>
      <p class="lead">{{ findSection('hero').subtitle }}</p>
      <p class="hero-sub">
        <span v-for="(item, i) in parseItems(findSection('hero').itemsJson)" :key="i">
          <svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="HERO_ICONS[item.icon] || ''"></svg>
          {{ item.text }}
        </span>
      </p>
    </div>
  </section>

  <!-- ═══ 链路痛点透视（横向流程图） ═══ -->
  <section class="section" v-if="findSection('pain-points-flow')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <div class="eyebrow">{{ t('products.flowEyebrow') }}</div>
        <h2 class="section-title">{{ findSection('pain-points-flow').title }}</h2>
        <p class="section-sub">{{ findSection('pain-points-flow').subtitle }}</p>
      </div>
      <div class="flow reveal">
        <template v-for="(node, i) in parseItems(findSection('pain-points-flow').itemsJson).slice(0, 6)" :key="i">
          <div class="flow-node">
            <div class="ic">
              <svg class="icon-svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="FLOW_ICONS[i]"></svg>
            </div>
            <h4>{{ node.title }}</h4>
            <ul><li v-for="(q, j) in node.items" :key="j">{{ q }}</li></ul>
          </div>
          <div class="flow-arrow" v-if="i < 5">→</div>
        </template>
      </div>
      <div class="crisis-bridge reveal" style="margin-top:32px;">
        <p>{{ t('products.flowBridge') }}<b>{{ t('products.flowBridgeBold') }}</b>{{ t('products.flowBridgeEnd') }}</p>
        <span class="bridge-arrow">↓</span>
      </div>
    </div>
  </section>

  <!-- ═══ 六大模块详解 ═══ -->
  <section class="section bg-gray" v-if="findSection('modules')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <div class="eyebrow">{{ t('products.modulesEyebrow') }}</div>
        <h2 class="section-title">{{ findSection('modules').title }}</h2>
        <p class="section-sub">{{ findSection('modules').subtitle }}</p>
      </div>
      <div class="grid grid-3">
        <div class="card reveal" v-for="mod in parseItems(findSection('modules').itemsJson)" :key="mod.id" :id="mod.id">
          <div class="icon">
            <svg class="icon-svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="MODULE_ICONS[mod.id] || ''"></svg>
          </div>
          <h3>{{ mod.title }}</h3>
          <div class="sub-cn">{{ mod.sub }}</div>
          <p>{{ mod.desc }}</p>
          <div class="tags"><span v-for="(t, j) in mod.tags" :key="j">{{ t }}</span></div>
        </div>
      </div>
    </div>
  </section>

  <!-- ═══ 增值模块：分销 + 报表 ═══ -->
  <section class="section" v-if="findSection('beyond-core')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <div class="eyebrow">{{ t('products.beyondEyebrow') }}</div>
        <h2 class="section-title">{{ findSection('beyond-core').title }}</h2>
        <p class="section-sub">{{ findSection('beyond-core').subtitle }}</p>
      </div>
      <div class="grid grid-2">
        <div class="card reveal" v-for="(item, i) in parseItems(findSection('beyond-core').itemsJson)" :key="i">
          <div class="icon">
            <svg class="icon-svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="BEYOND_ICONS[item.icon] || ''"></svg>
          </div>
          <h3>{{ item.title }}</h3>
          <div class="sub-cn">{{ item.sub }}</div>
          <p>{{ item.desc }}</p>
          <div class="tags"><span v-for="(t, j) in item.tags" :key="j">{{ t }}</span></div>
        </div>
      </div>
    </div>
  </section>

  <!-- ═══ AI 赋能体系 ═══ -->
  <section class="section bg-gray" v-if="findSection('ai-everywhere')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <div class="eyebrow">{{ t('products.aiEyebrow') }}</div>
        <h2 class="section-title">{{ findSection('ai-everywhere').title }}</h2>
        <p class="section-sub" style="letter-spacing:0.06em; line-height:1.8;">{{ findSection('ai-everywhere').subtitle }}</p>
      </div>
      <div class="grid grid-3">
        <div class="card reveal" v-for="(ai, i) in parseItems(findSection('ai-everywhere').itemsJson)" :key="i">
          <div class="icon">
            <svg class="icon-svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="AI_ICONS[i] || ''"></svg>
          </div>
          <h3>{{ ai.title }}</h3>
          <div class="sub-cn">{{ ai.sub }}</div>
          <p>{{ ai.desc }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ═══ CTA：引导到解决方案 ═══ -->
  <section class="section bg-gray" v-if="findSection('cta')">
    <div class="container text-center reveal">
      <h2 class="section-title">{{ findSection('cta').title }}</h2>
      <p class="section-sub" style="margin-bottom:24px;">{{ findSection('cta').subtitle }}</p>
      <a class="btn btn-primary btn-lg" href="/solutions">{{ t('products.viewSolutions') }}</a>
    </div>
  </section>
</template>
