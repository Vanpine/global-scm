<script setup>
import { useCountUp } from '@/composables/useCountUp'

defineProps({
  items: { type: Array, required: true }
})

// 从 "≤55天" / "90%+" / "≤4h" 等字符串中提取数字和前后缀
function parseStatValue(raw) {
  const v = raw || ''
  // 提取数字部分（支持小数）
  const numMatch = v.match(/(\d+\.?\d*)/)
  const num = numMatch ? parseFloat(numMatch[1]) : 0
  // 数字前面的符号（如 ≤）
  const prefix = v.startsWith('≤') ? '≤' : ''
  // 数字后面的单位（如 %+、天、h）
  const suffix = numMatch ? v.slice(numMatch.index + numMatch[0].length) : ''
  return { num, prefix, suffix }
}

useCountUp()
</script>

<template>
  <section class="section-sm">
    <div class="container">
      <div class="stats-grid">
        <div class="stat-item reveal" v-for="(item, i) in items" :key="i">
          <div class="stat-num">
            <span
              :data-count="parseStatValue(item.value).num"
              :data-prefix="parseStatValue(item.value).prefix"
              :data-suffix="parseStatValue(item.value).suffix"
            >0</span>
          </div>
          <div class="stat-label">{{ item.label }}</div>
        </div>
      </div>
    </div>
  </section>
</template>
