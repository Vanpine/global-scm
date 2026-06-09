import request from './request'

/**
 * 获取已发布文章列表，可按分类筛选
 * @param {string} [category] 可选分类：war / logi / energy / policy，不传返回全部
 * @returns {Promise<{records: Array}>}
 */
export function getArticles(category) {
  const params = {}
  if (category) params.category = category
  return request.get('/articles', { params })
}

/**
 * 获取文章详情（含内容块和标签）
 * @param {number} id 文章 ID
 * @returns {Promise<{article, blocks, tags}>}
 */
export function getArticleDetail(id) {
  return request.get(`/articles/${id}`)
}

/**
 * 递增文章阅读量
 * @param {number} id 文章 ID
 * @returns {Promise<{viewCount: number, likeCount: number}>}
 */
export function incrementArticleView(id) {
  return request.post(`/articles/${id}/view`)
}

/**
 * 点赞/取消点赞
 * @param {number} id 文章 ID
 * @param {boolean} liked true=点赞, false=取消
 * @returns {Promise<{viewCount: number, likeCount: number}>}
 */
export function toggleArticleLike(id, liked) {
  return request.post(`/articles/${id}/like`, { liked })
}
