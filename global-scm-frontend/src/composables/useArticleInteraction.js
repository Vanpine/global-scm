const VIEWED_KEY = 'gsm_viewed_articles'
const LIKED_KEY = 'gsm_liked_articles'
const VIEW_WINDOW_MS = 30 * 60 * 1000 // 30 分钟内不重复计数

/**
 * 文章互动 localStorage 工具（无登录场景）
 * - 阅读去重：30 分钟内同一文章不重复计数
 * - 点赞状态：持久化已点赞文章 ID 列表
 */
export function useArticleInteraction() {

  // ── 阅读去重 ──

  function getViewedMap() {
    try {
      return JSON.parse(localStorage.getItem(VIEWED_KEY)) || {}
    } catch {
      return {}
    }
  }

  function setViewedMap(map) {
    localStorage.setItem(VIEWED_KEY, JSON.stringify(map))
  }

  function hasViewedRecently(articleId) {
    const map = getViewedMap()
    const ts = map[articleId]
    if (!ts) return false
    return (Date.now() - ts) < VIEW_WINDOW_MS
  }

  function markViewed(articleId) {
    const map = getViewedMap()
    map[articleId] = Date.now()
    setViewedMap(map)
  }

  // ── 点赞状态 ──

  function getLikedList() {
    try {
      return JSON.parse(localStorage.getItem(LIKED_KEY)) || []
    } catch {
      return []
    }
  }

  function setLikedList(list) {
    localStorage.setItem(LIKED_KEY, JSON.stringify(list))
  }

  function isLiked(articleId) {
    return getLikedList().includes(articleId)
  }

  function toggleLikeLocally(articleId) {
    const list = getLikedList()
    const idx = list.indexOf(articleId)
    if (idx >= 0) {
      list.splice(idx, 1)
      setLikedList(list)
      return false // 已取消点赞
    } else {
      list.push(articleId)
      setLikedList(list)
      return true // 已点赞
    }
  }

  return { hasViewedRecently, markViewed, isLiked, toggleLikeLocally }
}
