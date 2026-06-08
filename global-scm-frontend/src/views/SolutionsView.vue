<script setup>
import { ref, onMounted } from 'vue'
import { getPageSections } from '@/api/page'

const sections = ref([])

onMounted(async () => {
  sections.value = await getPageSections('solutions') || []
})

function findSection(code) {
  return sections.value.find(s => s.section === code)
}

function parseItems(json) {
  try { return JSON.parse(json || '[]') } catch { return [] }
}
</script>

<template>
  <!-- Hero -->
  <section class="hero" style="min-height:60vh; height:auto; padding:120px 0 80px;" v-if="findSection('hero')">
    <img class="hero-video" src="https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=1920&q=85" alt="" style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none">
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

  <!-- 业务场景 -->
  <section class="section" v-if="findSection('scenarios')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <h2 class="section-title">{{ findSection('scenarios').title }}</h2>
        <p class="section-sub">{{ findSection('scenarios').subtitle }}</p>
      </div>
      <article v-for="(sc, i) in parseItems(findSection('scenarios').itemsJson)" :key="i" :id="sc.id"
               class="crisis-card-wide reveal" style="margin-bottom:32px;">
        <div class="ccw-img"><img :src="sc.img" alt="" loading="lazy" style="width:100%;height:100%;object-fit:cover;" onerror="this.style.display='none'"></div>
        <div class="ccw-body">
          <span :class="'ccw-tag ' + (sc.tagClass || '')">{{ sc.tag }}</span>
          <h3>{{ sc.title }}</h3>
          <p class="ccw-desc">{{ sc.desc }}</p>
          <ul><li v-for="(it, j) in sc.items" :key="j">{{ it }}</li></ul>
        </div>
      </article>
    </div>
  </section>

  <!-- 四种履约通道 -->
  <section class="section bg-gray" v-if="findSection('fulfillment')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <h2 class="section-title">{{ findSection('fulfillment').title }}</h2>
        <p class="section-sub">{{ findSection('fulfillment').subtitle }}</p>
      </div>
      <div class="grid grid-2">
        <div class="card reveal" v-for="(ch, i) in parseItems(findSection('fulfillment').itemsJson)" :key="i">
          <div class="icon" style="font-size:28px;font-weight:800;color:var(--primary);">{{ ch.badge }}</div>
          <h3>{{ ch.title }} <span style="font-weight:400;font-size:14px;color:var(--muted);">· {{ ch.sub }}</span></h3>
          <p style="font-size:14px;color:var(--muted);margin-top:8px;">{{ ch.desc }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- 成长阶段 -->
  <section class="section" v-if="findSection('stages')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <h2 class="section-title">{{ findSection('stages').title }}</h2>
        <p class="section-sub">{{ findSection('stages').subtitle }}</p>
      </div>
      <div class="grid grid-2">
        <div class="card reveal" v-for="(st, i) in parseItems(findSection('stages').itemsJson)" :key="i">
          <div class="icon"><svg class="icon-svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/></svg></div>
          <h3>{{ st.title }} <span style="font-weight:400;font-size:14px;color:var(--muted);">· {{ st.sub }}</span></h3>
          <p style="font-size:14px;color:var(--muted);margin-top:8px;">{{ st.desc }}</p>
          <div class="tags" style="margin-top:12px;"><span v-for="(t, j) in st.tags" :key="j">{{ t }}</span></div>
        </div>
      </div>
    </div>
  </section>

  <!-- 观点 -->
  <section class="section bg-gray" v-if="findSection('perspectives')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <h2 class="section-title" style="font-size:1.5rem;">关于跨境供应链的几点观点</h2>
      </div>
      <div class="grid grid-2">
        <div class="card reveal" v-for="(pv, i) in parseItems(findSection('perspectives').itemsJson)" :key="i">
          <h4 style="font-weight:700;">{{ pv.title }}</h4>
          <p style="font-size:14px;color:var(--muted);margin-top:6px;">{{ pv.desc }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- 目标成效 -->
  <section class="section" v-if="findSection('outcomes')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <h2 class="section-title">{{ findSection('outcomes').title }}</h2>
        <p class="section-sub">{{ findSection('outcomes').subtitle }}</p>
      </div>
      <div class="grid grid-3">
        <div class="card reveal" v-for="(oc, i) in parseItems(findSection('outcomes').itemsJson)" :key="i">
          <div class="stat-num" style="font-size:2rem;font-weight:800;color:var(--primary);margin-bottom:8px;">{{ oc.metric }}</div>
          <div class="stat-label" style="font-weight:600;">{{ oc.label }}</div>
          <p style="font-size:13px;color:var(--muted);margin-top:8px;">{{ oc.desc }}</p>
          <div style="font-size:12px;color:var(--muted);margin-top:6px;">{{ oc.scene }}</div>
        </div>
      </div>
    </div>
  </section>

  <!-- CTA -->
  <section class="section" v-if="findSection('cta')">
    <div class="container">
      <div class="cta-band reveal" style="text-align:center;">
        <h2>{{ findSection('cta').title }}</h2>
        <p style="margin-bottom:24px;">{{ findSection('cta').subtitle }}</p>
        <a class="btn btn-primary btn-lg" href="/pain-points">查看八大痛点与对策 →</a>
      </div>
    </div>
  </section>
</template>
