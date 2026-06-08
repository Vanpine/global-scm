<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'

/**
 * CarouselBanner.vue — 无限循环轮播图
 *
 * 特性：
 * 1. 鼠标悬停时暂停自动播放（计时器清零），离开后重新开始 5s 倒计时
 * 2. 首尾克隆实现无缝无限循环：滑到最后一张继续往下 → 无缝回到第一张；反向同理
 */

const props = defineProps({
  slides: { type: Array, required: true }
})

const AUTOPLAY_INTERVAL = 5000  // 自动切换间隔（毫秒）

// ═══ 首尾克隆，构造扩展数组：[last, slide0, slide1, ..., slideN-1, first] ═══
// 例如原数组 [A, B, C] → 扩展为 [C, A, B, C, A]
// 初始显示 index=1（即真正的第一张 A）
// 向右滑到 index=4（克隆的 A）时，动画结束后瞬间跳回 index=1（真正的 A），视觉无缝
// 向左滑到 index=0（克隆的 C）时，动画结束后瞬间跳回 index=3（真正的 C），视觉无缝
const extendedSlides = computed(() => {
  const s = props.slides
  if (s.length === 0) return []
  if (s.length === 1) return s          // 只有一张时不需要克隆
  return [s[s.length - 1], ...s, s[0]]
})

const currentIndex = ref(1)            // 当前在扩展数组中的位置，初始 = 1（第一张真实幻灯片）
const transitionEnabled = ref(true)    // 是否启用 CSS 过渡动画（跳转时需要关闭）
const isTransitioning = ref(false)     // 过渡进行中锁，防止快速点击导致索引越界白屏

const realTotal = computed(() => props.slides.length)

// ═══ 计时器管理 ═══════════════════════════════════════════
let timer = null

function startTimer() {
  stopTimer()                           // 先清除旧的，防止多个定时器并存
  if (realTotal.value <= 1) return      // 只有一张图时不自动播放
  timer = setInterval(next, AUTOPLAY_INTERVAL)
}

function stopTimer() {
  if (timer) {
    clearInterval(timer)
    timer = null
  }
}

// ═══ 切换逻辑 ═════════════════════════════════════════════
function goTo(index, smooth = true) {
  // 动画进行中忽略新的切换请求，防止快速点击导致索引越界白屏
  if (smooth && isTransitioning.value) return
  if (smooth) isTransitioning.value = true

  transitionEnabled.value = smooth
  currentIndex.value = index
}

function next() { goTo(currentIndex.value + 1, true) }
function prev() { goTo(currentIndex.value - 1, true) }

// ── 圆点点击：映射到扩展数组中的真实索引 ────────────────
function goToReal(realIndex) {
  goTo(realIndex + 1, true)             // 扩展数组中，真实索引 i 对应位置 i+1
}

// ── 当前真实索引（用于圆点 active 状态）─────────────────
function getRealIndex() {
  if (realTotal.value <= 1) return 0
  if (currentIndex.value <= 0) return realTotal.value - 1
  if (currentIndex.value >= extendedSlides.value.length - 1) return 0
  return currentIndex.value - 1
}

// ═══ 无限循环核心：transitionend 时检测克隆位置并瞬间跳转 ═══
function onTransitionEnd() {
  isTransitioning.value = false         // 过渡完成，释放锁
  const len = extendedSlides.value.length
  if (currentIndex.value >= len - 1) {
    // 滑到了末尾克隆的第一张，瞬间跳回真正的第一张（无动画，不触发 transitionend）
    goTo(1, false)
  } else if (currentIndex.value <= 0) {
    // 滑到了开头克隆的最后一张，瞬间跳回真正的最后一张（无动画，不触发 transitionend）
    goTo(len - 2, false)
  }
}

// ═══ 生命周期 ═════════════════════════════════════════════
onMounted(() => {
  startTimer()
})

onUnmounted(() => {
  stopTimer()
})
</script>

<template>
  <section
    class="carousel"
    aria-label="平台亮点轮播"
    style="margin-top:40px;"
    v-if="slides.length"
    @mouseenter="stopTimer"
    @mouseleave="startTimer"
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
    <button class="carousel-arrow prev" aria-label="上一张" @click="prev">‹</button>
    <button class="carousel-arrow next" aria-label="下一张" @click="next">›</button>
    <div class="carousel-dots">
      <button
        v-for="(_, i) in slides"
        :key="i"
        :class="{ active: i === getRealIndex() }"
        @click="goToReal(i)"
        :aria-label="'第' + (i + 1) + '张'"
      ></button>
    </div>
  </section>
</template>
