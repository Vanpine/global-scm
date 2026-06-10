<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { getHero, getCrisisCards, getCarousel, getHomeSections } from '@/api/home'
import { useScrollReveal } from '@/composables/useScrollReveal'
import { useI18n } from 'vue-i18n'
import HeroSection from '@/components/home/HeroSection.vue'
import CrisisCards from '@/components/home/CrisisCards.vue'
import CarouselBanner from '@/components/home/CarouselBanner.vue'
import StatsBar from '@/components/home/StatsBar.vue'
import RiskDashboard from '@/components/home/RiskDashboard.vue'

const { t } = useI18n()

const hero = ref(null)
const crisisCards = ref([])
const carousel = ref([])
const sections = ref([])

const loading = ref(true)

onMounted(async () => {
  try {
    const [h, cc, ca, sec] = await Promise.all([
      getHero(),
      getCrisisCards(),
      getCarousel(),
      getHomeSections()
    ])
    hero.value = h
    crisisCards.value = cc || []
    carousel.value = ca || []
    sections.value = sec || []
  } catch (e) {
    console.error('首页数据加载失败', e)
  }
  loading.value = false
  await nextTick()
  refreshReveal()
})

function findSection(code) {
  return sections.value.find(s => s.section === code)
}

function parseItems(json) {
  try { return JSON.parse(json || '[]') } catch { return [] }
}


const { refresh: refreshReveal } = useScrollReveal()
</script>

<template>
  <div v-if="loading" style="display:flex;align-items:center;justify-content:center;height:100vh;color:var(--muted);">
    {{ t('home.loading') }}
  </div>

  <template v-else>
    <!-- Hero -->
    <HeroSection v-if="hero" :hero="hero" />

    <!-- 多重危机卡片 -->
    <CrisisCards v-if="crisisCards.length" :cards="crisisCards" />

    <!-- 轮播图 -->
    <CarouselBanner v-if="carousel.length" :slides="carousel" />

    <!-- 数据指标条 -->
    <StatsBar v-if="findSection('stats')" :items="parseItems(findSection('stats').itemsJson)" />

    <!-- 核心理念（使命愿景） -->
    <section class="section" v-if="findSection('mission')">
      <div class="container">
        <div class="text-center reveal" style="margin-bottom:56px;">
          <div class="eyebrow">OUR MISSION · 核心理念</div>
          <h2 class="section-title">{{ findSection('mission').title }}</h2>
          <p class="section-sub">{{ findSection('mission').subtitle }}</p>
        </div>
        <div class="grid grid-2">
          <div class="card reveal" v-for="(item, i) in parseItems(findSection('mission').itemsJson)" :key="i">
            <div class="icon">
              <svg class="icon-svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle v-if="item.icon === 'globe'" cx="12" cy="12" r="10"/><line v-if="item.icon === 'globe'" x1="2" y1="12" x2="22" y2="12"/><path v-if="item.icon === 'globe'" d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>
                <line v-if="item.icon === 'chart'" x1="18" y1="20" x2="18" y2="4"/><line v-if="item.icon === 'chart'" x1="12" y1="20" x2="12" y2="10"/><line v-if="item.icon === 'chart'" x1="6" y1="20" x2="6" y2="14"/><polyline v-if="item.icon === 'chart'" points="2 14 6 10 12 16 18 8 22 4"/>
              </svg>
            </div>
            <h3>{{ item.title }}</h3>
            <p>{{ item.desc }}</p>
            <div class="tags"><span v-for="(t, j) in item.tags" :key="j">{{ t }}</span></div>
          </div>
        </div>
      </div>
    </section>

    <!-- AI 赋能 -->
    <section class="section bg-gray" v-if="findSection('ai-empowerment')">
      <div class="container">
        <div class="text-center reveal" style="margin-bottom:60px;">
          <div class="eyebrow">AI EMPOWERMENT · AI 赋能</div>
          <h2 class="section-title">{{ findSection('ai-empowerment').title }}</h2>
          <p class="section-sub">{{ findSection('ai-empowerment').subtitle }}</p>
        </div>
        <div class="grid grid-3">
          <div class="card reveal" v-for="(item, i) in parseItems(findSection('ai-empowerment').itemsJson)" :key="i">
            <div class="icon">
              <svg class="icon-svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle v-if="item.icon === 'radar'" cx="12" cy="12" r="10"/><circle v-if="item.icon === 'radar'" cx="12" cy="12" r="6"/><circle v-if="item.icon === 'radar'" cx="12" cy="12" r="2"/>
                <path v-if="item.icon === 'brain'" d="M12 2a3 3 0 0 0-3 3c0 1 .5 2 1 2.5V9H7a3 3 0 0 0-3 3v1a3 3 0 0 0 3 3h1.5c.3.5.5 1 .5 1.5v.5a3 3 0 0 0 3 3h1a3 3 0 0 0 3-3v-.5c0-.5.2-1 .5-1.5H17a3 3 0 0 0 3-3v-1a3 3 0 0 0-3-3h-1V7.5c.5-.5 1-1.5 1-2.5a3 3 0 0 0-3-3h-1z"/>
                <path v-if="item.icon === 'shield'" d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
              </svg>
            </div>
            <h3>{{ item.title }}</h3>
            <div class="sub-cn">{{ item.sub }}</div>
            <p>{{ item.desc }}</p>
          </div>
        </div>
        <div class="text-center reveal" style="margin-top:48px;">
          <a class="btn btn-primary" href="/why-us">{{ t('home.viewFullComparison') }}</a>
        </div>
      </div>
    </section>

    <!-- 全球风险地图（3D 地球 + 快讯面板） -->
    <RiskDashboard
      v-if="findSection('risk-feed')"
      :feed-items="parseItems(findSection('risk-feed').itemsJson)"
    />

    <!-- 底部 CTA -->
    <section class="section" v-if="findSection('cta')">
      <div class="container">
        <div class="cta-band reveal">
          <div class="eyebrow">GET STARTED</div>
          <h2>{{ findSection('cta').title }}</h2>
          <p>{{ findSection('cta').subtitle }}</p>
          <div class="cta-actions">
            <template v-for="(btn, i) in parseItems(findSection('cta').itemsJson)" :key="i">
              <a v-if="btn.primary" class="btn btn-primary btn-lg" :href="btn.href">{{ btn.text }}</a>
              <a v-else class="btn btn-white btn-lg" :href="btn.href">
                <svg class="icon-svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-2px;margin-right:6px">
                  <rect x="2" y="4" width="20" height="16" rx="2"/><path d="M22 4l-10 8L2 4"/>
                </svg>
                {{ btn.text }}
              </a>
            </template>
          </div>
        </div>
      </div>
    </section>
  </template>
</template>
