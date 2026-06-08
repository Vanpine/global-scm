<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'

const props = defineProps({
  slides: { type: Array, required: true }
})

const current = ref(0)
let timer = null

const total = computed(() => props.slides.length)

function goTo(index) {
  current.value = ((index % total.value) + total.value) % total.value
}

function next() { goTo(current.value + 1) }
function prev() { goTo(current.value - 1) }

onMounted(() => {
  timer = setInterval(next, 5000)
})

onUnmounted(() => {
  clearInterval(timer)
})
</script>

<template>
  <section class="carousel" aria-label="平台亮点轮播" style="margin-top:40px;" v-if="slides.length">
    <div class="carousel-track" :style="{ transform: 'translateX(-' + (current * 100) + '%)' }">
      <div class="carousel-slide" v-for="(slide, i) in slides" :key="i">
        <img :src="slide.imgUrl" :alt="slide.title">
        <div class="carousel-caption">
          <span class="eyebrow">{{ slide.eyebrow }}</span>
          <h2>{{ slide.title }}</h2>
          <p>{{ slide.description }}</p>
        </div>
      </div>
    </div>
    <button class="carousel-arrow prev" aria-label="上一张" @click="prev">‹</button>
    <button class="carousel-arrow next" aria-label="下一张" @click="next">›</button>
    <div class="carousel-dots">
      <button
        v-for="(_, i) in slides"
        :key="i"
        :class="{ active: i === current }"
        @click="goTo(i)"
        :aria-label="'第' + (i + 1) + '张'"
      ></button>
    </div>
  </section>
</template>
