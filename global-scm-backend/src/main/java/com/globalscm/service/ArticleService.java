package com.globalscm.service;

import com.globalscm.entity.pojo.Article;

import java.util.List;

/**
 * 文章业务接口
 * 管理新闻文章的生命周期
 */
public interface ArticleService {

    /**
     * 获取所有已发布文章，按发布时间倒序排列
     */
    List<Article> listAll();

    /**
     * 按分类获取已发布文章
     *
     * @param category 分类标识：war（战争）| logi（物流）| energy（能源）| policy（政策）
     */
    List<Article> listByCategory(String category);

    /**
     * 根据 ID 获取单篇文章
     */
    Article getById(Long id);
}
