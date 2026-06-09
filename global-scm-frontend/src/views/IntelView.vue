<script setup>
import { ref, reactive, onMounted, nextTick } from 'vue'
import { getArticles } from '@/api/article'
import { useScrollReveal } from '@/composables/useScrollReveal'
import { useRouter } from 'vue-router'

const router = useRouter()
const loading = ref(true)

// ==================== 分类映射 ====================
const CAT_MAP = {
  war:    { label: '地缘冲突', css: 'war',    icon: `<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>` },
  logi:   { label: '交通物流', css: 'logi',   icon: `<rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/>` },
  energy: { label: '能源与环境', css: 'energy', icon: `<polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/>` },
  policy: { label: '贸易政策', css: 'policy', icon: `<line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>` },
}
const CAT_ORDER = ['war', 'logi', 'energy', 'policy']

// ==================== 每个分类的文章数据 ====================
const catState = reactive({})
for (const cat of CAT_ORDER) {
  catState[cat] = { articles: [] }
}

const { refresh: refreshReveal } = useScrollReveal()

onMounted(async () => {
  const promises = CAT_ORDER.map(async cat => {
    const result = await getArticles(cat)
    if (result && result.records) {
      catState[cat].articles = result.records
    }
  })
  await Promise.all(promises)
  loading.value = false
  await nextTick()
  refreshReveal()
})
</script>

<template>
  <!-- ═══ Hero ═══ -->
  <section class="hero" style="min-height:100vh; height:100vh;">
    <img class="hero-video" src="https://images.unsplash.com/photo-1450101499163-c8848c66ca85?auto=format&fit=crop&w=1920&q=85" alt="" style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none;">
    <div class="hero-overlay"></div>
    <div class="hero-content">
      <h1>全球情报<span>要闻</span></h1>
      <p class="lead">实时追踪政策、关税、地缘与物流动态</p>
      <p class="hero-sub">
        <span><svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 6h16"/><path d="M4 10h16"/><path d="M4 14h8"/><path d="M4 18h5"/><rect x="14" y="14" width="6" height="6" rx="1"/></svg> 政策速递</span>
        <span><svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg> 地缘观察</span>
        <span><svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg> 物流快报</span>
      </p>
    </div>
  </section>

  <!-- ═══ 全球情报要闻 ═══ -->
  <section class="section news-hub" id="news" style="padding-bottom:56px;">
    <div class="container">
      <!-- 加载中 -->
      <div v-if="loading" style="text-align:center;padding:80px 0;color:var(--text-secondary);">加载中...</div>

      <div v-else class="news-group reveal" v-for="(cat, gi) in CAT_ORDER" :key="gi">
        <!-- 只渲染有文章的分类，空分类不显示空白区域 -->
        <template v-if="catState[cat].articles.length">
          <h3 class="news-group-title">
            <svg class="icon-svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="CAT_MAP[cat].icon"></svg>
            {{ CAT_MAP[cat].label }}
          </h3>
          <div class="news-grid">
            <div class="news-card" v-for="(article, ai) in catState[cat].articles" :key="ai"
                 @click="router.push('/news/' + article.id)" style="cursor:pointer;">
              <div class="news-thumb">
                <img :src="article.coverImg" alt="" loading="lazy" onerror="this.onerror=null;this.style.display='none';this.parentNode.classList.add('noimg')">
                <span :class="'news-cat ' + CAT_MAP[cat].css">{{ CAT_MAP[cat].label }}</span>
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
        </template>
      </div>
      <p class="news-disclaimer reveal">* 全球情报要闻基于公开报道整理，用于展示版式与解读视角；点击任意卡片查看完整内容。</p>
    </div>
  </section>

  <!-- ═══ 可缩放世界地图 ═══ -->
  <section class="section" style="padding-top:56px;">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <div class="eyebrow">INTERACTIVE MAP · 区域态势</div>
        <h2 class="section-title">可缩放的全球风险地图</h2>
        <p class="section-sub">放大任意区域，查看港口、航线与高危事件的分布细节。滚轮缩放、拖动平移、点击标记查看详情。</p>
      </div>
      <div class="leaflet-wrap reveal">
        <div id="riskLeaflet"></div>
        <div class="map-legend">
          <span><i style="background:#ff3b30"></i>高危</span>
          <span><i style="background:#ff9500"></i>关注</span>
          <span><i style="background:#34c759"></i>正常</span>
        </div>
      </div>
      <p class="section-sub reveal" style="font-size:13px;margin-top:18px;opacity:0.7;">* 供应链风险点为演示数据；全球地震为 USGS 实时数据（纯前端直连，每 60 秒自动刷新）。</p>
    </div>
  </section>
</template>
