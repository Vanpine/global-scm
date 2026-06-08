<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getArticleDetail } from '@/api/article'

const route = useRoute()
const article = ref(null)
const blocks = ref([])
const tags = ref([])
const loading = ref(true)

onMounted(async () => {
  const id = route.params.id
  const data = await getArticleDetail(id)
  if (data) {
    article.value = data.article
    blocks.value = data.blocks || []
    tags.value = data.tags || []
  }
  loading.value = false
})

const categoryMap = { war: '地缘冲突', logi: '交通物流', energy: '能源与环境', policy: '贸易政策' }
</script>

<template>
  <section class="section" style="padding-top:120px;">
    <div class="container" style="max-width:800px;margin:0 auto;">
      <!-- 加载中 -->
      <div v-if="loading" style="text-align:center;padding:80px 0;color:var(--muted);">加载中...</div>

      <!-- 文章不存在 -->
      <div v-else-if="!article" style="text-align:center;padding:80px 0;">
        <h2>文章不存在</h2>
        <p style="color:var(--muted);">该文章可能已被删除或链接无效。</p>
        <a href="/intel" class="btn btn-primary" style="margin-top:24px;display:inline-block;">← 返回新闻台</a>
      </div>

      <!-- 文章内容 -->
      <template v-else>
        <!-- 文章头部 -->
        <div style="margin-bottom:40px;">
          <span :class="'news-cat ' + article.category" style="display:inline-block;margin-bottom:12px;">{{ categoryMap[article.category] || article.category }}</span>
          <h1 style="font-size:2rem;line-height:1.35;margin-bottom:16px;">{{ article.title }}</h1>
          <div style="display:flex;align-items:center;gap:16px;font-size:13px;color:var(--muted);flex-wrap:wrap;">
            <span>{{ article.meta }}</span>
            <span v-if="article.publishedAt">发布于 {{ article.publishedAt }}</span>
          </div>
          <!-- 标签 -->
          <div class="tags" style="margin-top:16px;" v-if="tags.length">
            <span v-for="tag in tags" :key="tag.id">{{ tag.tagName }}</span>
          </div>
        </div>

        <!-- 封面图 -->
        <img v-if="article.coverImg" :src="article.coverImg" :alt="article.title"
             style="width:100%;max-height:420px;object-fit:cover;border-radius:12px;margin-bottom:40px;">

        <!-- 内容块渲染 -->
        <div v-for="block in blocks" :key="block.id" :class="'block-' + block.blockType" style="margin-bottom:20px;">
          <!-- kt：关键信息 -->
          <div v-if="block.blockType === 'kt'" class="kt-box" style="background:var(--bg-dark,#0a0e1a);color:#fff;padding:28px 32px;border-radius:12px;">
            <div style="font-size:11px;font-weight:700;letter-spacing:3px;color:var(--primary);margin-bottom:12px;">KEY TAKEAWAYS · 关键信息</div>
            <div style="white-space:pre-line;font-size:15px;line-height:1.7;" v-html="block.content.replace(/\n/g, '<br>')"></div>
          </div>
          <!-- lead：引导语 -->
          <p v-else-if="block.blockType === 'lead'" style="font-size:1.1rem;font-weight:600;line-height:1.75;color:var(--text);padding:4px 0;">
            {{ block.content }}
          </p>
          <!-- p：正文段落 -->
          <p v-else-if="block.blockType === 'p'" style="font-size:15px;line-height:1.85;color:var(--text-secondary, #555);">
            {{ block.content }}
          </p>
          <!-- quote：引用 -->
          <blockquote v-else-if="block.blockType === 'quote'" style="border-left:3px solid var(--primary);padding:12px 20px;margin:24px 0;font-style:italic;color:var(--text);font-size:1.05rem;background:rgba(0,122,255,0.04);border-radius:0 8px 8px 0;">
            {{ block.content }}
          </blockquote>
        </div>

        <!-- 底部导航 -->
        <div style="margin-top:56px;padding-top:24px;border-top:1px solid var(--border);">
          <a href="/intel" class="btn" style="font-size:14px;">← 返回新闻台</a>
        </div>
      </template>
    </div>
  </section>
</template>
