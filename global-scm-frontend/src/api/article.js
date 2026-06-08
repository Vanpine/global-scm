import request from './request'

/**
 * 获取已发布文章列表，可按分类筛选
 * 对应后端 ArticleController → GET /api/articles?category=
 *
 * @param {string} [category]  可选分类：
 *   - "war"      地缘冲突
 *   - "logi"     交通物流
 *   - "energy"   能源与环境
 *   - "policy"   贸易政策
 *   - 不传则返回全部
 *
 * 返回数组，每项字段：
 *  - id          文章 ID
 *  - title       标题
 *  - summary     摘要
 *  - category    分类
 *  - coverImg    封面图 URL
 *  - source      来源名称
 *  - sourceUrl   来源链接
 *  - meta        元信息（来源·领域·时间）
 *  - status      状态（published / draft / archived）
 *  - publishedAt 发布时间
 *
 * @returns {Promise<Array|null>}
 *
 * @example
 * // 获取全部文章
 * const all = await getArticles()
 * // 获取战争分类
 * const warArticles = await getArticles('war')
 */
export function getArticles(category) {
  const params = category ? { category } : {}
  return request.get('/articles', { params })
}

/**
 * 获取文章详情（含内容块和标签）
 * 对应后端 ArticleController → GET /api/articles/{id}
 *
 * @param {number} id  文章 ID
 *
 * 返回对象结构：
 * {
 *   article: {
 *     id, title, summary, category, coverImg,
 *     source, sourceUrl, meta, status, publishedAt
 *   },
 *   blocks: [
 *     {
 *       id, articleId,
 *       blockType: "kt" | "lead" | "p" | "quote",
 *       content,    // 内容文本
 *       sortOrder   // 排序
 *     }
 *   ],
 *   tags: [
 *     { id, articleId, tagName }
 *   ]
 * }
 *
 * blockType 渲染规则：
 *  - kt     关键信息 Key Takeaways → 深色背景要点框
 *  - lead   引导语 → 加粗段落
 *  - p      正文段落 → 普通段落
 *  - quote  引用 → 左侧竖线引用块
 *
 * @returns {Promise<Object|null>}
 *
 * @example
 * const { article, blocks, tags } = await getArticleDetail(1)
 * // article.title → "红海危机延续：主力班轮默认绕行好望角"
 * // blocks[0].blockType → "kt"
 * // tags → [{ tagName: "红海" }, { tagName: "好望角" }, ...]
 */
export function getArticleDetail(id) {
  return request.get(`/articles/${id}`)
}
