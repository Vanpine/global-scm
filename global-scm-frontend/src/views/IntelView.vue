<script setup>
import { ref, onMounted } from 'vue'
import { getPageSections } from '@/api/page'
import { useRouter } from 'vue-router'

const router = useRouter()
const sections = ref([])

onMounted(async () => {
  sections.value = await getPageSections('intel') || []
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
  <section class="hero" style="min-height:100vh; height:100vh;" v-if="findSection('hero')">
    <img class="hero-video" src="https://images.unsplash.com/photo-1450101499163-c8848c66ca85?auto=format&fit=crop&w=1920&q=85" alt="" style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none">
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

  <!-- 新闻分组 -->
  <section class="section news-hub" id="news" v-if="findSection('news-groups')">
    <div class="container">
      <div class="news-group reveal" v-for="(group, gi) in parseItems(findSection('news-groups').itemsJson)" :key="gi">
        <h3 class="news-group-title">
          <svg class="icon-svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/></svg>
          {{ group.group }}
        </h3>
        <div class="news-grid">
          <div class="news-card" v-for="(article, ai) in group.articles" :key="ai"
               @click="router.push('/news/' + (article.articleId || article.href?.replace('news-', '').replace('.html', '')))" style="cursor:pointer;">
            <div class="news-thumb">
              <img :src="article.img" alt="" loading="lazy" onerror="this.onerror=null;this.style.display='none';this.parentNode.classList.add('noimg')">
              <span :class="'news-cat ' + article.cat">{{ group.group }}</span>
            </div>
            <div class="news-info">
              <h3>{{ article.title }}</h3>
              <p class="news-sum">{{ article.summary }}</p>
              <div class="news-foot">
                <span class="news-meta">{{ article.meta }}</span>
                <span class="news-more">阅读详情 →</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
