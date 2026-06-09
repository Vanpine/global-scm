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

    /**
     * 递增文章阅读量，返回更新后的文章
     */
    Article incrementViewCount(Long id);

    /**
     * 点赞/取消点赞
     * @param id   文章 ID
     * @param like true=点赞+1, false=取消点赞-1
     * @return 更新后的文章
     */
    Article toggleLike(Long id, boolean like);
}
