<script setup>
import { ref, onMounted } from 'vue'
import { getPageSections } from '@/api/page'

const sections = ref([])

onMounted(async () => {
  sections.value = await getPageSections('why-us') || []
})

function findSection(code) {
  return sections.value.find(s => s.section === code)
}

function parseJson(json) {
  try { return JSON.parse(json || '{}') } catch { return {} }
}

function parseItems(json) {
  try { return JSON.parse(json || '[]') } catch { return [] }
}
</script>

<template>
  <!-- Hero -->
  <section class="hero" style="min-height:60vh; height:auto; padding:120px 0 80px;" v-if="findSection('hero')">
    <img class="hero-video" src="https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=1920&q=85" alt="" style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none">
    <div class="hero-overlay"></div>
    <div class="hero-content">
      <h1>{{ findSection('hero').title }}</h1>
      <p class="lead">{{ findSection('hero').subtitle }}</p>
      <p class="hero-sub">
        <span v-for="(item, i) in parseItems(findSection('hero').itemsJson)" :key="i">
          <svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2"/></svg>
          {{ item.text }}
        </span>
      </p>
    </div>
  </section>

  <!-- 对比表 -->
  <section class="section" v-if="findSection('comparison')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <h2 class="section-title">{{ findSection('comparison').title }}</h2>
      </div>
      <div class="comparison-table reveal" v-if="findSection('comparison')">
        <div class="comp-col old">
          <div class="comp-head">{{ parseJson(findSection('comparison').itemsJson).old?.title || '经验驱动模式' }}</div>
          <div class="comp-row" v-for="(row, i) in (parseJson(findSection('comparison').itemsJson).old?.rows || [])" :key="i">
            <div class="comp-label">{{ row.metric }}</div>
            <div class="comp-val">{{ row.value }}</div>
          </div>
        </div>
        <div class="comp-col new">
          <div class="comp-head">{{ parseJson(findSection('comparison').itemsJson).new?.title || 'AI 数据驱动模式' }}</div>
          <div class="comp-row" v-for="(row, i) in (parseJson(findSection('comparison').itemsJson).new?.rows || [])" :key="i">
            <div class="comp-label">{{ row.metric }}</div>
            <div class="comp-val">{{ row.value }}</div>
          </div>
        </div>
      </div>
      <div class="stats-grid" style="margin-top:32px;" v-if="parseJson(findSection('comparison').itemsJson).savings">
        <div class="stat-item reveal" v-for="(sv, i) in parseJson(findSection('comparison').itemsJson).savings" :key="i">
          <div class="stat-num"><span>{{ sv.value }}</span></div>
          <div class="stat-label">{{ sv.label }}</div>
        </div>
      </div>
    </div>
  </section>

  <!-- AI Copilot 时间线 -->
  <section class="section bg-gray" v-if="findSection('copilot')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <h2 class="section-title">{{ findSection('copilot').title }}</h2>
        <p class="section-sub">{{ findSection('copilot').subtitle }}</p>
      </div>
      <div v-for="(step, i) in parseItems(findSection('copilot').itemsJson)" :key="i" class="card reveal" style="margin-bottom:28px;padding:32px;">
        <div style="font-size:12px;font-weight:700;color:var(--primary);letter-spacing:2px;">{{ step.phase }}</div>
        <h3 style="margin-top:4px;">{{ step.title }}</h3>
        <p style="color:var(--muted);margin-top:8px;">{{ step.desc }}</p>
        <div v-for="(msg, j) in step.chat" :key="j" :style="{ marginTop:'16px', padding:'12px 16px', borderRadius:'10px', background: msg.role === 'user' ? 'var(--bg-gray, #f5f5f7)' : 'rgba(0,122,255,0.06)', fontSize:'13px' }">
          <strong>{{ msg.role === 'user' ? '你：' : 'AI：' }}</strong>{{ msg.text }}
        </div>
      </div>
    </div>
  </section>

  <!-- 六个差异化维度 -->
  <section class="section" v-if="findSection('difference')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <h2 class="section-title">{{ findSection('difference').title }}</h2>
        <p class="section-sub">{{ findSection('difference').subtitle }}</p>
      </div>
      <div class="grid grid-2">
        <div class="card reveal" v-for="(dim, i) in parseItems(findSection('difference').itemsJson)" :key="i">
          <h4 style="font-weight:700;">{{ dim.title }}</h4>
          <div style="font-size:12px;color:var(--primary);margin-top:2px;">{{ dim.sub }}</div>
          <p style="font-size:14px;color:var(--muted);margin-top:8px;">{{ dim.desc }}</p>
        </div>
      </div>
    </div>
  </section>
</template>
