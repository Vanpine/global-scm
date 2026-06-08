<script setup>
import { ref, onMounted } from 'vue'
import { getPageSections } from '@/api/page'

const sections = ref([])

onMounted(async () => {
  sections.value = await getPageSections('pain-points') || []
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
    <img class="hero-video" src="https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1920&q=85" alt="" style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none">
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

  <!-- 痛点预览 -->
  <section class="section" v-if="findSection('preview')">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <h2 class="section-title">{{ findSection('preview').title }}</h2>
        <p class="section-sub">{{ findSection('preview').subtitle }}</p>
      </div>
      <div class="grid grid-2">
        <div class="card reveal" v-for="(pp, i) in parseItems(findSection('preview').itemsJson)" :key="i">
          <div class="icon"><svg class="icon-svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/></svg></div>
          <h3>{{ pp.title }} <span style="font-weight:400;font-size:14px;color:var(--muted);">· {{ pp.sub }}</span></h3>
          <p style="font-size:14px;color:var(--muted);margin-top:8px;">{{ pp.desc }}</p>
        </div>
      </div>
    </div>
  </section>

  <!-- 八大痛点详细内容（从原站 HTML 迁移，此处用占位） -->
  <section class="section bg-gray">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:40px;">
        <h2 class="section-title">八大痛点，逐一拆解</h2>
        <p class="section-sub">后续版本将从后端动态加载完整内容</p>
      </div>
    </div>
  </section>
</template>
