<script setup>
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
        <div class="eyebrow">POLYCRISIS · 多重危机</div>
        <h2 class="section-title">传统供应链，正被<span class="gradient-text">多重危机</span>围困</h2>
        <p class="section-sub">政策、物流、需求、网络安全…… 风险不再单独出现，而是同时引爆。</p>
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
        <div class="eyebrow">THE ANSWER · 解决之道</div>
        <h2 class="section-title">风险已不再单独出现</h2>
        <p class="section-sub">应对多重危机，需要一个能<span>实时感知 · 智能决策 · 自动执行</span>的供应链大平台。</p>
        <span class="bridge-arrow">↓</span>
      </div>
    </div>
  </section>
</template>
