import request from './request'

/**
 * 首页 Hero 区数据
 * 对应后端 HomeController → GET /api/home/hero
 *
 * 返回字段：
 *  - title            主标题（"全球供应链"）
 *  - highlight        高亮词（"大平台"）
 *  - subtitle         引导语（"赋能地方资源 · 连接全球市场"）
 *  - tagsJson         标签行 JSON 数组 [{"icon":"","text":""},...]
 *  - ctaPrimaryText   主按钮文字
 *  - ctaPrimaryHref   主按钮链接
 *  - ctaSecondaryText 次按钮文字
 *  - ctaSecondaryHref 次按钮链接
 *  - videoUrl         背景视频 URL
 */
export function getHero() {
  return request.get('/home/hero')
}

/**
 * 首页多重危机卡片列表（6 张）
 * 对应后端 HomeController → GET /api/home/crisis-cards
 *
 * 返回数组，每项字段：
 *  - tag         卡片分类（贸易政策/地缘政治/物流瓶颈/需求风险/供应风险/网络安全）
 *  - title       标题
 *  - description 描述文字
 *  - itemsJson   要点列表 JSON 数组 ["要点1","要点2",...]
 *  - imgUrl      配图 URL
 *  - sortOrder   排序（1–6）
 */
export function getCrisisCards() {
  return request.get('/home/crisis-cards')
}

/**
 * 首页轮播图列表（4 张）
 * 对应后端 HomeController → GET /api/home/carousel
 *
 * 返回数组，每项字段：
 *  - imgUrl      图片 URL
 *  - eyebrow     眉题英文标签（"END-TO-END VISIBILITY" 等）
 *  - title       标题
 *  - description 描述
 *  - sortOrder   排序（1–4）
 */
export function getCarousel() {
  return request.get('/home/carousel')
}

/**
 * 首页所有区块内容
 * 对应后端 HomeController → GET /api/home/sections
 *
 * 返回 5 个区块的数组，通过 section 字段区分：
 *  - stats          四项关键指标（items_json: [{"label":"","value":""},...]）
 *  - mission        使命愿景 2 卡片（items_json: [{"icon":"","title":"","desc":"","tags":[]},...]）
 *  - ai-empowerment AI 赋能 3 卡片（items_json: [{"icon":"","title":"","sub":"","desc":""},...]）
 *  - risk-feed      风险快讯 6 条（items_json: [{"title":"","cat":"","meta":"","href":""},...]）
 *  - cta            底部行动号召（items_json: [{"text":"","href":"","primary":true/false},...]）
 */
export function getHomeSections() {
  return request.get('/home/sections')
}
