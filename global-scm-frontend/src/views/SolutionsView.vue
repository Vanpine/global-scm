<script setup>
import { ref, watch, onMounted, nextTick } from 'vue'
import { getPageSections } from '@/api/page'
import { useScrollReveal } from '@/composables/useScrollReveal'
import { useI18n } from 'vue-i18n'

const { t, locale } = useI18n()

const sections = ref([])

async function loadData() {
  sections.value = await getPageSections('solutions') || []
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
  globe:   `<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>`,
  warehouse: `<path d="M2 20a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8l-7 5V8l-7 5V4l-6 4v12z"/>`,
  send:    `<polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11L2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"/>`,
  shuffle: `<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>`,
}

// ── 成长阶段图标映射 ──────────────────────────────────
const STAGE_ICONS = [
  `<path d="M7 17h10"/><path d="M12 17v4"/><path d="M12 7a5 5 0 0 0-5 5c0 3 2 5 5 7 3-2 5-4 5-7a5 5 0 0 0-5-5z"/><path d="M8 8c1-2 3-4 4-4s3 2 4 4"/>`,
  `<path d="M4.5 16.5c-1.5 1.26-2 5-2 5s3.74-.5 5-2c.71-.84.7-2.13-.09-2.91a2.18 2.18 0 0 0-2.91-.09z"/><path d="M12 15l-3-3a22 22 0 0 1 2-3.95A12.88 12.88 0 0 1 22 2c0 2.72-.78 7.5-6 11a22.35 22.35 0 0 1-4 2z"/><path d="M9 12H4s.55-3.03 2-4c1.62-1.08 5 0 5 0"/><path d="M12 15v5s3.03-.55 4-2c1.08-1.62 0-5 0-5"/>`,
  `<path d="M8 3l4 8 5-5 5 15H2L8 3z"/>`,
]

// ── 观点图标映射 ──────────────────────────────────────
const PERSPECTIVE_ICONS = [
  `<polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/>`,
  `<line x1="3" y1="6" x2="21" y2="6"/><path d="M3 6l3 14h12l3-14"/><line x1="12" y1="6" x2="12" y2="20"/><circle cx="7" cy="15" r="3"/><circle cx="17" cy="15" r="3"/>`,
  `<path d="M22 2L11.5 6.5 7 2 2 22l7.5-2.5L22 13.5 17.5 10z"/><path d="M2 22l5-5"/><path d="M2 22l9-3"/>`,
  `<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>`,
]
</script>

<template>
  <!-- ═══ Hero：全屏图片背景 ═══ -->
  <section class="hero" style="min-height:100vh; height:100vh;" v-if="findSection('hero')">
    <img class="hero-video" src="https://images.unsplash.com/photo-1587293852726-70cdb56c2866?auto=format&fit=crop&w=1920&q=85" alt="" style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none;">
    <div class="hero-overlay"></div>
    <div class="hero-content">
      <h1>{{ t('solutions.heroTitle1') }}<span>{{ t('solutions.heroTitle2') }}</span></h1>
      <p class="lead">{{ findSection('hero').subtitle }}</p>
      <p class="hero-sub">
        <span v-for="(item, i) in parseItems(findSection('hero').itemsJson)" :key="i">
          <svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="HERO_ICONS[item.icon] || ''"></svg>
          {{ item.text }}
        </span>
      </p>
    </div>
  </section>

  <!-- ═══ 四大场景 ═══ -->
  <section class="section" style="padding-bottom:64px;" v-if="findSection('scenarios')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:140px;">
        <div class="eyebrow">FOUR SCENARIOS · 四大场景</div>
        <h2 class="section-title">{{ findSection('scenarios').title || '按你的业务场景，找到对应方案' }}</h2>
        <p class="section-sub">{{ findSection('scenarios').subtitle || '不做大一统推荐，每个场景都有具体的落地路径。' }}</p>
      </div>
      <div class="solutions-featured">
        <article class="solution-card-wide reveal" v-for="(sc, i) in parseItems(findSection('scenarios').itemsJson)" :key="i" :id="sc.id">
          <div class="scw-img">
            <img :src="sc.img" alt="" loading="lazy" onerror="this.style.display='none'">
          </div>
          <div class="scw-body">
            <span :class="'scw-tag tag-' + (sc.tagClass || '').replace('tag-', '')">{{ sc.tag }}</span>
            <h3>{{ sc.title }}</h3>
            <p class="scw-desc">{{ sc.desc }}</p>
            <ul><li v-for="(it, j) in sc.items" :key="j">{{ it }}</li></ul>
          </div>
        </article>
      </div>
    </div>
  </section>

  <!-- ═══ 四种履约通道 ═══ -->
  <section class="section bg-gray" v-if="findSection('fulfillment')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <div class="eyebrow">FULFILLMENT</div>
        <h2 class="section-title">{{ findSection('fulfillment').title || '四种履约通道，OMS 自动匹配最优' }}</h2>
        <p class="section-sub">{{ findSection('fulfillment').subtitle || '系统根据库存位置、渠道 SLA、物流成本与目的国，自动匹配最优通道。' }}</p>
      </div>
      <div class="grid grid-4">
        <div class="card reveal" v-for="(ch, i) in parseItems(findSection('fulfillment').itemsJson)" :key="i">
          <div class="icon"><span class="letter-badge">{{ ['A','B','C','D'][i] }}</span></div>
          <h3>{{ ch.title }}</h3>
          <div class="sub-cn">{{ ch.sub }}</div>
          <p>{{ ch.desc }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ═══ 选型指南 ═══ -->
  <section class="section" v-if="findSection('stages')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <div class="eyebrow">HOW TO CHOOSE</div>
        <h2 class="section-title">{{ findSection('stages').title || '按成长阶段，选择适配组合' }}</h2>
        <p class="section-sub">{{ findSection('stages').subtitle || '没有放之四海皆准的方案。结合跨境企业的出口实践，我们把履约选型归纳为三个成长阶段。' }}</p>
      </div>
      <div class="grid grid-3">
        <div class="card reveal" v-for="(st, i) in parseItems(findSection('stages').itemsJson).slice(0, 3)" :key="i">
          <div class="icon">
            <svg class="icon-svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="STAGE_ICONS[i] || ''"></svg>
          </div>
          <h3>{{ st.title }}</h3>
          <div class="sub-cn">{{ st.sub }}</div>
          <p>{{ st.desc }}</p>
          <div class="tags"><span v-for="(t, j) in st.tags" :key="j">{{ t }}</span></div>
        </div>
      </div>
    </div>
  </section>

  <!-- ═══ 我们的供应链观点 ═══ -->
  <section class="section bg-black" v-if="findSection('perspectives')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <div class="eyebrow">OUR PERSPECTIVE</div>
        <h2 class="section-title">{{ findSection('perspectives').title || '关于跨境供应链的几点观点' }}</h2>
        <p class="section-sub">{{ findSection('perspectives').subtitle || '并非每条"行业常识"都成立。以下是我们结合实践，对几个常见问题的看法。' }}</p>
      </div>
      <div class="grid grid-2">
        <div class="card reveal" v-for="(pv, i) in parseItems(findSection('perspectives').itemsJson)" :key="i">
          <div class="icon">
            <svg class="icon-svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="PERSPECTIVE_ICONS[i] || ''"></svg>
          </div>
          <h3>{{ pv.title }}</h3>
          <p>{{ pv.desc }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ═══ 客户成效案例 ═══ -->
  <section class="section" v-if="findSection('outcomes')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <div class="eyebrow">TARGET OUTCOMES · 目标成效</div>
        <h2 class="section-title">{{ findSection('outcomes').title || '典型场景下的目标成效' }}</h2>
        <p class="section-sub">{{ findSection('outcomes').subtitle || '以下为典型业务场景的目标改善示意，帮助你预估价值，非特定客户真实数据。' }}</p>
      </div>
      <div class="grid grid-3">
        <div class="card reveal" v-for="(oc, i) in parseItems(findSection('outcomes').itemsJson)" :key="i">
          <h3 style="color:var(--brand-blue);font-size:26px;">{{ oc.stat || oc.metric }}</h3>
          <div class="sub-cn">{{ oc.sub || oc.label }}</div>
          <p>{{ oc.desc }}</p>
          <p style="color:var(--text-tertiary);margin-top:10px;">{{ oc.scene }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ═══ CTA ═══ -->
  <section class="section" v-if="findSection('cta')">
    <div class="container text-center reveal">
      <h2 class="section-title">{{ findSection('cta').title || '想了解这些场景背后的行业挑战？' }}</h2>
      <p class="section-sub" style="margin-bottom:24px;">{{ findSection('cta').subtitle || '每个业务场景背后，都是地缘、政策、供需等宏观挑战在驱动。看清全局，方案才落得住。' }}</p>
      <a class="btn btn-ghost btn-lg" href="/pain-points">{{ t('solutions.viewPainPoints') }}</a>
    </div>
  </section>
</template>
