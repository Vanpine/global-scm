<script setup>
import { ref, watch, onMounted, nextTick } from 'vue'
import { getPageSections } from '@/api/page'
import { useScrollReveal } from '@/composables/useScrollReveal'
import { useI18n } from 'vue-i18n'

const { t, locale } = useI18n()

const sections = ref([])

async function loadData() {
  sections.value = await getPageSections('pain-points') || []
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

// ── Hero 标签图标映射 ──────────────────────────────
const HERO_ICONS = {
  globe: `<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>`,
  list:  `<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>`,
  chart: `<line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>`,
  link:  `<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>`,
}

// ── 预览卡片图标映射 ──────────────────────────────
const PREVIEW_ICONS = {
  globe:        `<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>`,
  chart:        `<line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>`,
  'dollar-sign':`<line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>`,
  clock:        `<circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>`,
}

// ── 大脑模型图标 ──────────────────────────────────
const BRAIN_ICONS = [
  `<circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/><line x1="12" y1="12" x2="16" y2="8"/><line x1="12" y1="2" x2="12" y2="6"/><line x1="2" y1="12" x2="6" y2="12"/><line x1="20" y1="12" x2="18" y2="12"/>`,
  `<path d="M6.5 22h11"/><path d="M12 22V8"/><path d="M16 6a4 4 0 0 0-8 0c0 4 4 6 4 6s4-2 4-6z"/><circle cx="12" cy="6" r="2"/><path d="M10 2h4"/>`,
  `<circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/>`,
  `<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>`,
]
</script>

<template>
  <!-- ═══ Hero：全屏图片背景 ═══ -->
  <section class="hero" style="min-height:100vh; height:100vh;" v-if="findSection('hero')">
    <img class="hero-video" src="https://images.unsplash.com/photo-1624969862644-791f3dc98927?auto=format&fit=crop&w=1920&q=90" alt="" style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none;">
    <div class="hero-overlay"></div>
    <div class="hero-content">
      <h1>{{ t('painPoints.heroTitle1') }}<span>{{ t('painPoints.heroTitle2') }}</span></h1>
      <p class="lead">{{ findSection('hero').subtitle }}</p>
      <p class="hero-sub">
        <span v-for="(item, i) in parseItems(findSection('hero').itemsJson)" :key="i">
          <svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="HERO_ICONS[item.icon] || ''"></svg>
          {{ item.text }}
        </span>
      </p>
    </div>
  </section>

  <!-- ═══ 痛点共鸣（四张卡片速览） ═══ -->
  <section class="section-sm bg-gray" style="padding-top:100px; padding-bottom:100px;" v-if="findSection('preview')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:64px;">
        <div class="eyebrow">{{ t('painPoints.previewEyebrow') }}</div>
        <h2 class="section-title">{{ findSection('preview').title }}</h2>
        <p class="section-sub">{{ findSection('preview').subtitle }}</p>
      </div>
      <div class="grid grid-4">
        <div class="card reveal" v-for="(pp, i) in parseItems(findSection('preview').itemsJson)" :key="i">
          <div class="icon">
            <svg class="icon-svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="PREVIEW_ICONS[pp.icon] || ''"></svg>
          </div>
          <h3>{{ pp.title }}</h3>
          <div class="sub-cn">{{ pp.sub }}</div>
          <p>{{ pp.desc }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ═══ 八大痛点详解 ═══ -->
  <section class="section" v-if="findSection('pain-points')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <div class="eyebrow">{{ t('painPoints.painPointsEyebrow') }}</div>
        <h2 class="section-title">{{ t('painPoints.painPointsTitle1') }}<span class="gradient-text">{{ t('painPoints.painPointsTitle2') }}</span></h2>
        <p class="section-sub">{{ findSection('pain-points').subtitle }}</p>
      </div>
    </div>
    <div class="pain-list">
      <div class="painrow" v-for="(pp, i) in parseItems(findSection('pain-points').itemsJson)" :key="i" :class="{ reverse: i % 2 === 1 }">
        <div class="text reveal">
          <span class="num">{{ pp.num }}</span>
          <h3>{{ pp.title }}</h3>
          <p class="desc">{{ pp.desc }}</p>
          <div class="sol-box">
            <div class="lbl">{{ t('painPoints.solution') }}</div>
            <ul>
              <li v-for="(it, j) in pp.items" :key="j">{{ it }}</li>
            </ul>
          </div>
        </div>
        <div class="visual reveal">
          <img :src="pp.img" alt="" loading="lazy" onerror="this.style.display='none'">
        </div>
      </div>
    </div>
  </section>

  <!-- ═══ 供应链大脑模型 ═══ -->
  <section class="section bg-gray" v-if="findSection('brain')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:60px;">
        <div class="eyebrow">{{ t('painPoints.brainEyebrow') }}</div>
        <h2 class="section-title">{{ t('painPoints.brainTitle1') }}<span class="gradient-text">{{ t('painPoints.brainTitle2') }}</span></h2>
        <p class="section-sub">{{ findSection('brain').subtitle }}</p>
      </div>
      <div class="brain-flow">
        <template v-for="(bn, i) in parseItems(findSection('brain').itemsJson)" :key="i">
          <div class="brain-node reveal">
            <div class="brain-step">{{ bn.step }}</div>
            <div class="brain-icon">
              <svg class="icon-svg" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="BRAIN_ICONS[i] || ''"></svg>
            </div>
            <h3>{{ bn.title }}</h3>
            <div class="sub-cn">{{ bn.sub }}</div>
            <p>{{ bn.desc }}</p>
          </div>
          <div class="brain-arrow" v-if="i < 3">→</div>
        </template>
      </div>
      <div class="text-center reveal" style="margin-top:28px;">
        <span class="brain-loop-hint">{{ t('painPoints.brainHint') }}</span>
      </div>
    </div>
  </section>
</template>
