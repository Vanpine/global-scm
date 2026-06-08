<script setup>
import { useRouter } from 'vue-router'

const props = defineProps({
  hero: { type: Object, required: true }
})

const router = useRouter()

function parseTags(json) {
  try { return JSON.parse(json || '[]') } catch { return [] }
}
</script>

<template>
  <section class="hero">
    <video class="hero-video" autoplay muted loop playsinline>
      <source src="/vedio.mp4" type="video/mp4">
    </video>
    <div class="hero-overlay"></div>
    <div class="hero-content">
      <h1>{{ hero.title }}<span>{{ hero.highlight }}</span></h1>
      <p class="lead">{{ hero.subtitle }}</p>
      <p class="hero-sub">
        <span v-for="(tag, i) in parseTags(hero.tagsJson)" :key="i">
          <svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline v-if="tag.icon === 'trending-up'" points="22 17 13.5 8.5 8.5 13.5 2 7"/><polyline v-if="tag.icon === 'trending-up'" points="16 17 22 17 22 11"/>
            <path v-if="tag.icon === 'shield'" d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
            <rect v-if="tag.icon === 'cpu'" x="4" y="4" width="16" height="16" rx="2"/><rect v-if="tag.icon === 'cpu'" x="9" y="9" width="6" height="6"/><line v-if="tag.icon === 'cpu'" x1="9" y1="1" x2="9" y2="4"/><line v-if="tag.icon === 'cpu'" x1="15" y1="1" x2="15" y2="4"/><line v-if="tag.icon === 'cpu'" x1="9" y1="20" x2="9" y2="23"/><line v-if="tag.icon === 'cpu'" x1="15" y1="20" x2="15" y2="23"/><line v-if="tag.icon === 'cpu'" x1="20" y1="9" x2="23" y2="9"/><line v-if="tag.icon === 'cpu'" x1="20" y1="14" x2="23" y2="14"/><line v-if="tag.icon === 'cpu'" x1="1" y1="9" x2="4" y2="9"/><line v-if="tag.icon === 'cpu'" x1="1" y1="14" x2="4" y2="14"/>
          </svg>
          {{ tag.text }}
        </span>
      </p>
      <div class="hero-actions">
        <a class="btn btn-hero-primary btn-lg" :href="hero.ctaPrimaryHref" @click.prevent="router.push(hero.ctaPrimaryHref)">{{ hero.ctaPrimaryText }}</a>
        <a class="btn btn-hero-ghost btn-lg" :href="hero.ctaSecondaryHref" @click.prevent="router.push(hero.ctaSecondaryHref)">{{ hero.ctaSecondaryText }}</a>
      </div>
    </div>
  </section>
</template>
