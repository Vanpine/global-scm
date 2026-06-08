<script setup>
import { useCountUp } from '@/composables/useCountUp'

defineProps({
  items: { type: Array, required: true }
})

useCountUp()
</script>

<template>
  <section class="section-sm">
    <div class="container">
      <div class="stats-grid">
        <div class="stat-item reveal" v-for="(item, i) in items" :key="i">
          <div class="stat-num">
            <span
              :data-count="parseInt(item.value)"
              :data-prefix="item.value.startsWith('≤') ? '≤' : ''"
              :data-suffix="item.value.includes('%') ? '%+' : (item.value.includes('h') ? 'h' : (item.value.includes('天') ? '天' : ''))"
            >0</span>
          </div>
          <div class="stat-label">{{ item.label }}</div>
        </div>
      </div>
    </div>
  </section>
</template>
