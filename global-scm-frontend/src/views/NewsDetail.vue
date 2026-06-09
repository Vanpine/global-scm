<script setup>
import { ref, watch, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getArticleDetail, getArticles, incrementArticleView, toggleArticleLike } from '@/api/article'
import { useArticleInteraction } from '@/composables/useArticleInteraction'

const route = useRoute()
const article = ref(null)
const blocks = ref([])
const tags = ref([])
const related = ref([])
const loading = ref(true)
const viewCount = ref(0)
const likeCount = ref(0)
const liked = ref(false)

const { hasViewedRecently, markViewed, isLiked, toggleLikeLocally } = useArticleInteraction()

// 分类映射
const CAT_MAP = {
  war:    { label: '地缘冲突', css: 'war' },
  logi:   { label: '交通物流', css: 'logi' },
  energy: { label: '能源与环境', css: 'energy' },
  policy: { label: '贸易政策', css: 'policy' },
}

/**
 * 将 kt 块的纯文本内容解析为要点列表
 * 按换行拆分，过滤空行和标题行
 */
function parseKtItems(content) {
  if (!content) return []
  return content
    .split('\n')
    .map(s => s.trim())
    .filter(s => s.length > 0)
    .filter(s => s !== '关键要点' && !s.startsWith('📌') && !s.startsWith('关键要点'))
}

/**
 * 加载文章详情数据
 */
async function loadArticle(id) {
  loading.value = true
  window.scrollTo({ top: 0, behavior: 'instant' })
  const data = await getArticleDetail(id)
  if (data) {
    article.value = data.article
    blocks.value = data.blocks || []
    tags.value = data.tags || []
    document.title = (article.value.title || '文章') + ' · 全球情报'

    // 初始化计数（来自数据库）
    viewCount.value = article.value.viewCount || 0
    likeCount.value = article.value.likeCount || 0
    // 从 localStorage 恢复点赞状态
    liked.value = isLiked(article.value.id)

    // 阅读去重：30 分钟内不重复计数
    if (!hasViewedRecently(article.value.id)) {
      const result = await incrementArticleView(article.value.id)
      if (result) {
        viewCount.value = result.viewCount
        likeCount.value = result.likeCount
      }
      markViewed(article.value.id)
    }

    // 加载同分类相关文章（取前 3 篇）
    const result = await getArticles(article.value.category) || {}
    related.value = (result.records || []).filter(a => a.id !== article.value.id).slice(0, 3)
  }
  loading.value = false
}

/**
 * 点赞/取消点赞
 */
async function handleLike() {
  if (!article.value) return
  const newLiked = toggleLikeLocally(article.value.id)
  liked.value = newLiked
  const result = await toggleArticleLike(article.value.id, newLiked)
  if (result) {
    likeCount.value = result.likeCount
  }
}

onMounted(() => loadArticle(route.params.id))

// 同一组件内路由切换（如 /news/1 → /news/2）时重新加载
watch(() => route.params.id, (newId) => loadArticle(newId))
</script>

<template>
  <!-- 加载中 -->
  <div v-if="loading" style="text-align:center;padding:160px 0 80px;color:var(--text-secondary);">加载中...</div>

  <!-- 文章不存在 -->
  <div v-else-if="!article" style="text-align:center;padding:160px 0 80px;">
    <h2 style="font-size:24px;margin-bottom:12px;">文章不存在</h2>
    <p style="color:var(--text-secondary);margin-bottom:24px;">该文章可能已被删除或链接无效。</p>
    <router-link to="/intel" class="btn btn-primary">← 返回新闻台</router-link>
  </div>

  <main v-else class="article-root">
    <!-- ===== 文章 Hero ===== -->
    <header class="article-hero">
      <img v-if="article.coverImg" class="article-hero-img" :src="article.coverImg" alt="" onerror="this.style.display='none'">
      <div class="article-hero-overlay"></div>
      <div class="container article-hero-inner">
        <router-link to="/intel" class="article-back">← 返回全球情报</router-link>
        <span :class="'news-cat ' + (CAT_MAP[article.category]?.css || 'policy')">{{ CAT_MAP[article.category]?.label || article.category }}</span>
        <h1>{{ article.title }}</h1>
        <div class="article-meta" v-if="article.meta">
          <svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 6h16"/><path d="M4 10h16"/><path d="M4 14h8"/><path d="M4 18h5"/><rect x="14" y="14" width="6" height="6" rx="1"/></svg>
          {{ article.meta }}
        </div>
        <div class="article-stats">
          <span class="stat-item"><svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg> <span class="view-count">{{ viewCount }}</span></span>
          <button class="act-like-article" :class="{ liked }" @click="handleLike"><svg class="icon-svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 9V5a3 3 0 0 0-3-3l-4 9v11h11.28a2 2 0 0 0 2-1.7l1.38-9a2 2 0 0 0-2-2.3H14zM7 22H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h3"/></svg> <span class="like-num">{{ likeCount }}</span></button>
        </div>
      </div>
    </header>

    <!-- ===== 文章正文 ===== -->
    <!-- 显示条件：有内容块（手工录入）或有摘要（RSS 拉取）→ 保证正文不空白 -->
    <div class="article-wrap container">
      <article class="article-body" v-if="blocks.length || article.summary">

        <!-- 情况1：有内容块（手工录入的高质量文章）→ 按块渲染 -->
        <template v-if="blocks.length">
          <template v-for="(block, bi) in blocks" :key="bi">
            <!-- 关键要点（对齐原型：ul > li 列表） -->
            <div v-if="block.blockType === 'kt'" class="kt-box">
              <div class="kt-title">
                <svg class="icon-svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="2" x2="12" y2="22"/><path d="M5 7h14l-3 5 3 5H5"/><circle cx="12" cy="5" r="1" fill="currentColor" stroke="none"/></svg> 关键要点
              </div>
              <ul>
                <li v-for="(item, ki) in parseKtItems(block.content)" :key="ki">{{ item }}</li>
              </ul>
            </div>
            <!-- 引导语 -->
            <p v-else-if="block.blockType === 'lead'" class="lead-p">{{ block.content }}</p>
            <!-- 引用 -->
            <blockquote v-else-if="block.blockType === 'quote'">{{ block.content }}</blockquote>
            <!-- 正文 -->
            <p v-else-if="block.blockType === 'p'">{{ block.content }}</p>
          </template>
        </template>

        <!-- 情况2：无内容块但有摘要（RSS 自动拉取）→ 摘要作正文兜底 -->
        <template v-else>
          <p>{{ article.summary }}</p>
        </template>

        <!-- 原文来源 -->
        <div v-if="article.source || article.meta" class="read-origin">
          <span style="font-weight:600;">
            <svg class="icon-svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 6h16"/><path d="M4 10h16"/><path d="M4 14h8"/><path d="M4 18h5"/><rect x="14" y="14" width="6" height="6" rx="1"/></svg> 原文来源
          </span>
          <span class="read-origin-src">{{ article.source || article.meta }}</span>
        </div>

        <!-- 阅读原文按钮（跳转到外站原文，新标签页打开） -->
        <div v-if="article.sourceUrl" style="margin-top:24px;text-align:center;">
          <a :href="article.sourceUrl" target="_blank" rel="noopener" class="btn btn-primary" style="display:inline-flex;align-items:center;gap:6px;">
            阅读原文
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/></svg>
          </a>
        </div>

        <!-- 标签 -->
        <div v-if="tags.length" class="article-tags">
          <span v-for="(tag, ti) in tags" :key="ti">#{{ tag.tagName }}</span>
        </div>
      </article>
    </div>

    <!-- ===== 继续阅读 ===== -->
    <section v-if="related.length" class="related-sec">
      <div class="container">
        <h2 class="related-title">继续阅读</h2>
        <p class="related-sub">更多塑造全球供应链的关键信号。</p>
        <div class="news-grid">
          <router-link v-for="(item, ri) in related" :key="ri"
                       :to="'/news/' + item.id" class="news-card">
            <div class="news-thumb">
              <img :src="item.coverImg" alt="" loading="lazy" onerror="this.onerror=null;this.style.display='none';this.parentNode.classList.add('noimg')">
              <span :class="'news-cat ' + (CAT_MAP[item.category]?.css || 'policy')">{{ CAT_MAP[item.category]?.label || item.category }}</span>
            </div>
            <div class="news-info">
              <h3>{{ item.title }}</h3>
              <div class="news-foot">
                <span class="news-meta">{{ item.meta }}</span>
                <span class="news-more">阅读详情 →</span>
              </div>
            </div>
          </router-link>
        </div>
      </div>
    </section>
  </main>
</template>
