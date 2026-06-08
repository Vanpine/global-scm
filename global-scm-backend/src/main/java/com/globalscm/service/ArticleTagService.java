package com.globalscm.service;

import com.globalscm.entity.pojo.ArticleTag;

import java.util.List;

/**
 * 文章标签业务接口
 * 每篇文章可关联多个标签，用于分类检索和热门推荐
 */
public interface ArticleTagService {

    /**
     * 获取指定文章的所有标签
     *
     * @param articleId 文章 ID
     * @return 标签名称列表
     */
    List<ArticleTag> listByArticleId(Long articleId);
}
