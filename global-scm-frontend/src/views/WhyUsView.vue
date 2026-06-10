<script setup>
import { ref, watch, onMounted, nextTick } from 'vue'
import { getPageSections } from '@/api/page'
import { useScrollReveal } from '@/composables/useScrollReveal'
import { useI18n } from 'vue-i18n'

const { t, locale } = useI18n()

const sections = ref([])

async function loadData() {
  sections.value = await getPageSections('why-us') || []
  await nextTick()
  refreshReveal()
}

onMounted(loadData)
watch(locale, loadData)

const { refresh: refreshReveal } = useScrollReveal()

function findSection(code) {
  return sections.value.find(s => s.section === code)
}

function parseJson(json) {
  try { return JSON.parse(json || '{}') } catch { return {} }
}

function parseItems(json) {
  try { return JSON.parse(json || '[]') } catch { return [] }
}

// ── Hero 标签图标映射 ──────────────────────────────
const HERO_ICONS = {
  chart: `<line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>`,
  cpu:   `<rect x="4" y="4" width="16" height="16" rx="2"/><rect x="9" y="9" width="6" height="6"/><line x1="9" y1="1" x2="9" y2="4"/><line x1="15" y1="1" x2="15" y2="4"/><line x1="9" y1="20" x2="9" y2="23"/><line x1="15" y1="20" x2="15" y2="23"/><line x1="20" y1="9" x2="23" y2="9"/><line x1="20" y1="14" x2="23" y2="14"/><line x1="1" y1="9" x2="4" y2="9"/><line x1="1" y1="14" x2="4" y2="14"/>`,
  'trending-up': `<polyline points="22 17 13.5 8.5 8.5 13.5 2 7"/><polyline points="16 17 22 17 22 11"/>`,
}

// ── 差异化图标 ─────────────────────────────────────
const DIFF_ICONS = [
  `<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>`,
  `<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>`,
  `<polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/>`,
  `<rect x="4" y="4" width="16" height="16" rx="2"/><rect x="9" y="9" width="6" height="6"/><line x1="9" y1="1" x2="9" y2="4"/><line x1="15" y1="1" x2="15" y2="4"/><line x1="9" y1="20" x2="9" y2="23"/><line x1="15" y1="20" x2="15" y2="23"/><line x1="20" y1="9" x2="23" y2="9"/><line x1="20" y1="14" x2="23" y2="14"/><line x1="1" y1="9" x2="4" y2="9"/><line x1="1" y1="14" x2="4" y2="14"/>`,
  `<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>`,
  `<polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/>`,
]
</script>

<template>
  <!-- ═══ Hero：全屏图片背景 ═══ -->
  <section class="hero" style="min-height:100vh; height:100vh;" v-if="findSection('hero')">
    <img class="hero-video" src="https://images.unsplash.com/photo-1521791136064-7986c2920216?auto=format&fit=crop&w=1920&q=90" alt="" style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none;">
    <div class="hero-overlay"></div>
    <div class="hero-content">
      <h1>{{ t('whyUs.heroTitle1') }}<span>{{ t('whyUs.heroTitle2') }}</span></h1>
      <p class="lead">{{ t('whyUs.heroLead') }}</p>
      <p class="hero-sub">
        <span v-for="(item, i) in parseItems(findSection('hero').itemsJson)" :key="i">
          <svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="HERO_ICONS[item.icon] || ''"></svg>
          {{ item.text }}
        </span>
      </p>
    </div>
  </section>

  <!-- ═══ 传统 vs AI 对比 ═══ -->
  <section class="section" v-if="findSection('comparison')">
    <div class="container">
      <div class="compare-wrap">
        <div class="compare-col compare-old reveal">
          <h3>{{ t('whyUs.expDriven') }}</h3>
          <div class="compare-row" v-for="(row, i) in parseJson(findSection('comparison').itemsJson).old?.rows || []" :key="i">
            <div class="metric">{{ row.metric }}</div>
            <div class="value">{{ row.value }}</div>
          </div>
        </div>
        <div class="compare-col compare-new reveal">
          <h3>{{ t('whyUs.aiDriven') }}</h3>
          <div class="compare-row" v-for="(row, i) in parseJson(findSection('comparison').itemsJson).new?.rows || []" :key="i">
            <div class="metric">{{ row.metric }}</div>
            <div class="value">{{ row.value }}</div>
          </div>
        </div>
      </div>

      <!-- 降本增效 -->
      <div class="savings reveal">
        <h4>{{ t('whyUs.costTitle') }}</h4>
        <div class="savings-grid">
          <div class="savings-item"><div class="big">-32%</div><div class="lbl">{{ t('whyUs.inventoryCost') }}</div></div>
          <div class="savings-item"><div class="big">-25%</div><div class="lbl">{{ t('whyUs.logisticsCost') }}</div></div>
          <div class="savings-item"><div class="big">-45%</div><div class="lbl">{{ t('whyUs.customsFine') }}</div></div>
          <div class="savings-item"><div class="big">-60%</div><div class="lbl">{{ t('whyUs.laborHours') }}</div></div>
        </div>
        <p style="text-align:center;font-size:13px;color:var(--text-tertiary);margin-top:22px;">{{ t('whyUs.disclaimer') }}</p>
      </div>
    </div>
  </section>

  <!-- ═══ AI Copilot 展示 ═══ -->
  <section class="section bg-black" v-if="findSection('copilot')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <div class="eyebrow">{{ t('whyUs.aiCopilot') }}</div>
        <h2 class="section-title">{{ t('whyUs.copilotTitle') }}</h2>
        <p class="section-sub">{{ t('whyUs.copilotSub') }}</p>
      </div>

      <div class="product-shot reveal" style="margin-bottom:64px;">
        <img src="/assets/dashboard.png" alt="Global SCM 控制塔 Dashboard 实时预览">
      </div>

      <div class="timeline reveal">
        <div class="tl-item" v-for="(step, i) in parseItems(findSection('copilot').itemsJson)" :key="i">
          <div class="tl-card">
            <div class="tl-head">
              <span class="tl-num">{{ String(i + 1).padStart(2, '0') }}</span>
              <div>
                <div class="eyebrow">{{ step.eyebrow }}</div>
                <h3>{{ step.title }}</h3>
              </div>
            </div>
            <p>{{ step.desc }}</p>
            <div class="chat-card" v-if="step.chat">
              <div v-for="(msg, j) in step.chat" :key="j" :class="['chat-bubble', msg.role]">
                <span v-html="msg.text"></span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ═══ 六大差异化优势 ═══ -->
  <section class="section bg-gray" v-if="findSection('difference')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <div class="eyebrow">{{ t('whyUs.difference') }}</div>
        <h2 class="section-title">{{ t('whyUs.diffTitle') }}<span class="gradient-text">{{ t('whyUs.diffTitleGrad') }}</span></h2>
        <p class="section-sub">{{ t('whyUs.diffSub') }}</p>
      </div>
      <div class="grid grid-3">
        <div class="card reveal" v-for="(dim, i) in parseItems(findSection('difference').itemsJson)" :key="i">
          <div class="icon">
            <svg class="icon-svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="DIFF_ICONS[i] || ''"></svg>
          </div>
          <h3>{{ dim.title }}</h3>
          <div class="sub-cn">{{ dim.sub }}</div>
          <p>{{ dim.desc }}</p>
        </div>
      </div>
    </div>
  </section>
</template>
