<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { getPageSections } from '@/api/page'
import { useScrollReveal } from '@/composables/useScrollReveal'

const sections = ref([])

onMounted(async () => {
  sections.value = await getPageSections('why-us') || []
  await nextTick()
  refreshReveal()
})

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
      <h1>为什么选择<span>我们</span></h1>
      <p class="lead">两种模式，关键指标摊开来看</p>
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
          <h3>经验驱动模式</h3>
          <div class="compare-row" v-for="(row, i) in parseJson(findSection('comparison').itemsJson).old?.rows || []" :key="i">
            <div class="metric">{{ row.metric }}</div>
            <div class="value">{{ row.value }}</div>
          </div>
        </div>
        <div class="compare-col compare-new reveal">
          <h3>AI 数据驱动模式</h3>
          <div class="compare-row" v-for="(row, i) in parseJson(findSection('comparison').itemsJson).new?.rows || []" :key="i">
            <div class="metric">{{ row.metric }}</div>
            <div class="value">{{ row.value }}</div>
          </div>
        </div>
      </div>

      <!-- 降本增效 -->
      <div class="savings reveal">
        <h4>💰 降本增效 · 平台目标</h4>
        <div class="savings-grid">
          <div class="savings-item"><div class="big">-32%</div><div class="lbl">库存成本</div></div>
          <div class="savings-item"><div class="big">-25%</div><div class="lbl">物流成本</div></div>
          <div class="savings-item"><div class="big">-45%</div><div class="lbl">关务罚款</div></div>
          <div class="savings-item"><div class="big">-60%</div><div class="lbl">人工工时</div></div>
        </div>
        <p style="text-align:center;font-size:13px;color:var(--text-tertiary);margin-top:22px;">* 以上为基于平台设计目标的测算，实际效果因企业与品类而异。</p>
      </div>
    </div>
  </section>

  <!-- ═══ AI Copilot 展示 ═══ -->
  <section class="section bg-black" v-if="findSection('copilot')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <div class="eyebrow">AI COPILOT</div>
        <h2 class="section-title">认识您的供应链大脑</h2>
        <p class="section-sub">预测需求、响应中断、做出更聪明的决策 —— 全部通过一个 7×24 在线的 AI Copilot。</p>
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
        <div class="eyebrow">OUR DIFFERENCE</div>
        <h2 class="section-title">六个维度，<span class="gradient-text">做出区别</span></h2>
        <p class="section-sub">不是功能清单的比拼，而是底层架构和产品理念的差异。</p>
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
