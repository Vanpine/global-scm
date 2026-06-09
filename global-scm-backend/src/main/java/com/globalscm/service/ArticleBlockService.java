package com.globalscm.service;

import com.globalscm.entity.pojo.ArticleBlock;

import java.util.List;

/**
 * 文章内容块业务接口
 */
public interface ArticleBlockService {

    /**
     * 获取指定文章的所有内容块，按 sort_order 升序排列
     */
    List<ArticleBlock> listByArticleId(Long articleId);
}
