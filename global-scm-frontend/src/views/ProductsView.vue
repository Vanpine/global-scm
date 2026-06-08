<script setup>
import { ref, onMounted } from 'vue'
import { getPageSections } from '@/api/page'

const sections = ref([])

onMounted(async () => {
  sections.value = await getPageSections('products') || []
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
    <img class="hero-video" src="https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=1920&q=85" alt="" style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none">
    <div class="hero-overlay"></div>
    <div class="hero-content">
      <h1>{{ findSection('hero').title }}</h1>
      <p class="lead">{{ findSection('hero').subtitle }}</p>
      <p class="hero-sub">
        <span v-for="(item, i) in parseItems(findSection('hero').itemsJson)" :key="i">
          <svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2"/><rect x="9" y="9" width="6" height="6"/></svg>
          {{ item.text }}
        </span>
      </p>
    </div>
  </section>

  <!-- 痛点流程 -->
  <section class="section" v-if="findSection('pain-points-flow')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <h2 class="section-title">{{ findSection('pain-points-flow').title }}</h2>
        <p class="section-sub">{{ findSection('pain-points-flow').subtitle }}</p>
      </div>
      <div class="grid grid-3">
        <div class="card reveal" v-for="(node, i) in parseItems(findSection('pain-points-flow').itemsJson).slice(0, 6)" :key="i">
          <h4 style="font-weight:700;margin-bottom:6px;">{{ node.title }}</h4>
          <ul style="font-size:14px;color:var(--muted);padding-left:18px;margin:0;">
            <li v-for="(q, j) in node.items" :key="j">{{ q }}</li>
          </ul>
        </div>
      </div>
    </div>
  </section>

  <!-- 六大模块 -->
  <section class="section bg-gray" v-if="findSection('modules')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <h2 class="section-title">{{ findSection('modules').title }}</h2>
        <p class="section-sub">{{ findSection('modules').subtitle }}</p>
      </div>
      <div class="grid grid-2">
        <div class="card reveal" v-for="(mod, i) in parseItems(findSection('modules').itemsJson)" :key="i" :id="mod.id">
          <h3>{{ mod.title }} <span style="font-weight:400;font-size:14px;color:var(--muted);">· {{ mod.sub }}</span></h3>
          <p style="font-size:14px;color:var(--muted);margin-top:8px;">{{ mod.desc }}</p>
          <div class="tags" style="margin-top:12px;">
            <span v-for="(t, j) in mod.tags" :key="j">{{ t }}</span>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- 核心之外 -->
  <section class="section" v-if="findSection('beyond-core')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <h2 class="section-title">{{ findSection('beyond-core').title }}</h2>
        <p class="section-sub">{{ findSection('beyond-core').subtitle }}</p>
      </div>
      <div class="grid grid-2">
        <div class="card reveal" v-for="(item, i) in parseItems(findSection('beyond-core').itemsJson)" :key="i">
          <h3>{{ item.title }} <span style="font-weight:400;font-size:14px;color:var(--muted);">· {{ item.sub }}</span></h3>
          <p style="font-size:14px;color:var(--muted);margin-top:8px;">{{ item.desc }}</p>
          <div class="tags" style="margin-top:12px;">
            <span v-for="(t, j) in item.tags" :key="j">{{ t }}</span>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- AI 引擎 -->
  <section class="section bg-gray" v-if="findSection('ai-everywhere')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:56px;">
        <h2 class="section-title">{{ findSection('ai-everywhere').title }}</h2>
        <p class="section-sub">{{ findSection('ai-everywhere').subtitle }}</p>
      </div>
      <div class="grid grid-3">
        <div class="card reveal" v-for="(ai, i) in parseItems(findSection('ai-everywhere').itemsJson)" :key="i">
          <div class="icon"><svg class="icon-svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2"/><rect x="9" y="9" width="6" height="6"/></svg></div>
          <h3>{{ ai.title }}</h3>
          <div class="sub-cn">{{ ai.sub }}</div>
          <p style="font-size:14px;color:var(--muted);margin-top:8px;">{{ ai.desc }}</p>
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
        <a class="btn btn-primary btn-lg" href="/solutions">查看解决方案 →</a>
      </div>
    </div>
  </section>
</template>
