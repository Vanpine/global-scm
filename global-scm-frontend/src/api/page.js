import request from './request'

/**
 * 按页面标识获取该页面所有区块
 * 对应后端 PageController → GET /api/page/{page}
 *
 * @param {string} page  页面标识，6 个可选值：
 *   - "products"      产品功能页
 *   - "solutions"     解决方案页
 *   - "why-us"        为什么选我们
 *   - "intel"         供应链新闻台
 *   - "contact"       联系我们
 *   - "pain-points"   痛点与方案
 *
 * 返回该页面所有区块的数组，每项通过 section 字段区分具体区块。
 * 各页面的 section 枚举详见 DESIGN.md 第 3.3 节。
 *
 * @returns {Promise<Array|null>} 区块数组，失败时返回 null
 *
 * @example
 * // 获取产品页所有区块
 * const sections = await getPageSections('products')
 * const hero = sections.find(s => s.section === 'hero')
 * const modules = sections.find(s => s.section === 'modules')
 */
export function getPageSections(page) {
  return request.get(`/page/${page}`)
}
