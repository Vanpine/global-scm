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
