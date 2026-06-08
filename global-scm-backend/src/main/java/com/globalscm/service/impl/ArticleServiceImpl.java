package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.Article;
import com.globalscm.mapper.ArticleMapper;
import com.globalscm.service.ArticleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 文章业务实现
 * 只对外暴露 status=published 的文章，保证草稿和归档文章不可见
 */
@Service
@RequiredArgsConstructor
public class ArticleServiceImpl implements ArticleService {

    private final ArticleMapper mapper;

    /**
     * 查询所有已发布文章，按发布时间倒序（最新的在前）
     */
    @Override
    public List<Article> listAll() {
        return mapper.selectList(
            new LambdaQueryWrapper<Article>()
                .eq(Article::getStatus, "published")
                .orderByDesc(Article::getPublishedAt)
        );
    }

    /**
     * 按分类筛选已发布文章
     * 分类包括 war（战争）、logi（物流）、energy（能源）、policy（政策）
     */
    @Override
    public List<Article> listByCategory(String category) {
        return mapper.selectList(
            new LambdaQueryWrapper<Article>()
                .eq(Article::getCategory, category)
                .eq(Article::getStatus, "published")
                .orderByDesc(Article::getPublishedAt)
        );
    }

    /**
     * 按主键 ID 查询文章，不做状态过滤（管理后台需要查看草稿和归档）
     */
    @Override
    public Article getById(Long id) {
        return mapper.selectById(id);
    }
}
