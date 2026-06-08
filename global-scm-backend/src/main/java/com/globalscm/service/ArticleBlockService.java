package com.globalscm.service;

import com.globalscm.entity.pojo.ArticleBlock;

import java.util.List;

/**
 * 文章内容块业务接口
 * 每篇文章由多个内容块组成（关键信息/引导语/段落/引用），按 sort_order 排序拼接成完整文章
 */
public interface ArticleBlockService {

    /**
     * 获取指定文章的所有内容块，按 sort_order 升序排列
     *
     * @param articleId 文章 ID
     * @return 内容块列表，blockType 分别为 kt（关键信息）、lead（引导语）、p（段落）、quote（引用）
     */
    List<ArticleBlock> listByArticleId(Long articleId);
}
