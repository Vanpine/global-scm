<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const props = defineProps({
  slides: { type: Array, required: true }
})

const AUTOPLAY_INTERVAL = 5000
const TRANSITION_DURATION = 850 // 需与 CSS transition: 0.85s 一致

// 首尾克隆实现无缝无限循环：[last, s0, s1, ..., sN-1, first]
const extendedSlides = computed(() => {
  const s = props.slides
  if (s.length === 0) return []
  if (s.length === 1) return s
  return [s[s.length - 1], ...s, s[0]]
})

const currentIndex = ref(1)
const transitionEnabled = ref(true)
const isTransitioning = ref(false)
const isHovering = ref(false)

const realTotal = computed(() => props.slides.length)

// ═══ 计时器 ═════════════════════════════════════════════
let timer = null
let safetyTimer = null

function clearTimers() {
  if (timer) { clearInterval(timer); timer = null }
  if (safetyTimer) { clearTimeout(safetyTimer); safetyTimer = null }
}

function startTimer() {
  clearTimers()
  if (realTotal.value <= 1) return
  if (isHovering.value) return
  timer = setInterval(next, AUTOPLAY_INTERVAL)
}

function stopTimer() {
  clearTimers()
}

function onMouseEnter() {
  isHovering.value = true
  stopTimer()
}
function onMouseLeave() {
  isHovering.value = false
  startTimer()
}

// ═══ 导航 ═══════════════════════════════════════════════
function goTo(index, smooth = true) {
  if (smooth && isTransitioning.value) return
  if (smooth) {
    isTransitioning.value = true
    // 安全超时：防止 transitionend 未触发导致轮播卡死
    safetyTimer = setTimeout(() => {
      isTransitioning.value = false
      safetyTimer = null
    }, TRANSITION_DURATION + 100)
  }
  transitionEnabled.value = smooth
  currentIndex.value = index
}

function next() {
  stopTimer()
  goTo(currentIndex.value + 1, true)
}
function prev() {
  stopTimer()
  goTo(currentIndex.value - 1, true)
}
function goToReal(realIndex) {
  stopTimer()
  goTo(realIndex + 1, true)
}

function getRealIndex() {
  if (realTotal.value <= 1) return 0
  if (currentIndex.value <= 0) return realTotal.value - 1
  if (currentIndex.value >= extendedSlides.value.length - 1) return 0
  return currentIndex.value - 1
}

// ═══ 无限循环：过渡结束后检测克隆位置，瞬间跳转 ═════════
function onTransitionEnd() {
  isTransitioning.value = false
  if (safetyTimer) { clearTimeout(safetyTimer); safetyTimer = null }

  const len = extendedSlides.value.length
  if (currentIndex.value >= len - 1) {
    goTo(1, false)
  } else if (currentIndex.value <= 0) {
    goTo(len - 2, false)
  }

  // 跳转完成后恢复自动播放
  startTimer()
}

// ═══ 生命周期 ═══════════════════════════════════════════
onMounted(() => startTimer())
onUnmounted(() => clearTimers())
</script>

<template>
  <section
    class="carousel"
    aria-label="Platform Highlights Carousel"
    style="margin-top:40px;"
    v-if="slides.length"
    @mouseenter="onMouseEnter"
    @mouseleave="onMouseLeave"
  >
    <div
      class="carousel-track"
      :class="{ 'no-transition': !transitionEnabled }"
      :style="{ transform: 'translateX(-' + (currentIndex * 100) + '%)' }"
      @transitionend="onTransitionEnd"
    >
      <div class="carousel-slide" v-for="(slide, i) in extendedSlides" :key="'ext' + i">
        <img :src="slide.imgUrl" :alt="slide.title">
        <div class="carousel-caption">
          <span class="eyebrow">{{ slide.eyebrow }}</span>
          <h2>{{ slide.title }}</h2>
          <p>{{ slide.description }}</p>
        </div>
      </div>
    </div>
    <button class="carousel-arrow prev" :aria-label="t('home.carouselPrev')" @click="prev">&#8249;</button>
    <button class="carousel-arrow next" :aria-label="t('home.carouselNext')" @click="next">&#8250;</button>
    <div class="carousel-dots">
      <button
        v-for="(_, i) in slides"
        :key="i"
        :class="{ active: i === getRealIndex() }"
        @click="goToReal(i)"
        :aria-label="t('home.carouselSlide') + (i + 1) + t('home.carouselSlideUnit')"
      ></button>
    </div>
  </section>
</template>
