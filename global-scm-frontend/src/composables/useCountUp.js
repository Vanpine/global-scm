import { onMounted } from 'vue'

/**
 * 数字滚动动画：统计数字从 0 递增到目标值
 */
export function useCountUp() {
  function animate(el) {
    const target = parseInt(el.dataset.count)
    if (isNaN(target)) return
    const prefix = el.dataset.prefix || ''
    const suffix = el.dataset.suffix || ''
    const duration = 1600
    const start = performance.now()

    function tick(now) {
      const elapsed = now - start
      const progress = Math.min(elapsed / duration, 1)
      // ease-out
      const eased = 1 - Math.pow(1 - progress, 3)
      const current = Math.round(target * eased)
      el.textContent = prefix + current + suffix
      if (progress < 1) {
        requestAnimationFrame(tick)
      }
    }

    requestAnimationFrame(tick)
  }

  onMounted(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            animate(entry.target)
            observer.unobserve(entry.target)
          }
        })
      },
      { threshold: 0.5 }
    )

    document.querySelectorAll('[data-count]').forEach((el) => {
      observer.observe(el)
    })
  })
}
