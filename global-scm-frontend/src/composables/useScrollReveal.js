import { onMounted, onUnmounted } from 'vue'

/**
 * 滚动揭示动画：当元素进入视口时添加 .in 类
 * 复用原站 CSS 的 .reveal 机制
 *
 * 返回 refresh() 方法，供异步数据加载后手动触发重新扫描 .reveal 元素
 */
export function useScrollReveal() {
  let observer = null

  function refresh() {
    if (!observer) return
    document.querySelectorAll('.reveal:not(.in)').forEach((el) => {
      observer.observe(el)
    })
  }

  onMounted(() => {
    observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('in')
            observer.unobserve(entry.target)
          }
        })
      },
      { threshold: 0.12, rootMargin: '0px 0px -40px 0px' }
    )

    refresh()
  })

  onUnmounted(() => {
    if (observer) {
      observer.disconnect()
      observer = null
    }
  })

  return { refresh }
}
