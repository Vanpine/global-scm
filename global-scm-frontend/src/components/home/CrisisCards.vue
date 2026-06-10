<script setup>
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

defineProps({
  cards: { type: Array, required: true }
})

function parseItems(json) {
  try { return JSON.parse(json || '[]') } catch { return [] }
}
</script>

<template>
  <section class="section" style="padding-bottom:64px;">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <div class="eyebrow">{{ t('home.crisisEyebrow') }}</div>
        <h2 class="section-title">{{ t('home.crisisTitle1') }}<span class="gradient-text">{{ t('home.crisisTitle2') }}</span>{{ t('home.crisisTitle3') }}</h2>
        <p class="section-sub">{{ t('home.crisisSub') }}</p>
      </div>
      <div style="height:80px;"></div>
      <div class="crisis-featured">
        <article class="crisis-card-wide reveal" v-for="card in cards" :key="card.id">
          <div class="ccw-img">
            <img :src="card.imgUrl" alt="" loading="lazy" onerror="this.style.display='none'">
          </div>
          <div class="ccw-body">
            <span class="ccw-tag">{{ card.tag }}</span>
            <h3>{{ card.title }}</h3>
            <p class="ccw-desc">{{ card.description }}</p>
            <ul>
              <li v-for="(item, idx) in parseItems(card.itemsJson)" :key="idx">{{ item }}</li>
            </ul>
          </div>
        </article>
      </div>
      <div class="crisis-bridge reveal">
        <div class="eyebrow">{{ t('home.crisisAnswerEyebrow') }}</div>
        <h2 class="section-title">{{ t('home.crisisAnswerTitle') }}</h2>
        <p class="section-sub">{{ t('home.crisisAnswerSub1') }}<span>{{ t('home.crisisAnswerSub2') }}</span>{{ t('home.crisisAnswerSub3') }}</p>
        <span class="bridge-arrow">↓</span>
      </div>
    </div>
  </section>
</template>
