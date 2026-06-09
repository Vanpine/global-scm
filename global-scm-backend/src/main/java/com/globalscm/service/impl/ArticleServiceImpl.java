package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.globalscm.entity.pojo.Article;
import com.globalscm.mapper.ArticleMapper;
import com.globalscm.service.ArticleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 文章业务实现
 */
@Service
@RequiredArgsConstructor
public class ArticleServiceImpl implements ArticleService {

    private final ArticleMapper mapper;

    @Override
    public List<Article> listAll() {
        return mapper.selectList(
            new LambdaQueryWrapper<Article>()
                .eq(Article::getStatus, "published")
                .orderByDesc(Article::getPublishedAt)
        );
    }

    @Override
    public List<Article> listByCategory(String category) {
        return mapper.selectList(
            new LambdaQueryWrapper<Article>()
                .eq(Article::getCategory, category)
                .eq(Article::getStatus, "published")
                .orderByDesc(Article::getPublishedAt)
        );
    }

    @Override
    public Article getById(Long id) {
        return mapper.selectById(id);
    }

    @Override
    public Article incrementViewCount(Long id) {
        UpdateWrapper<Article> wrapper = new UpdateWrapper<>();
        wrapper.setSql("view_count = view_count + 1").eq("id", id);
        mapper.update(null, wrapper);
        return mapper.selectById(id);
    }

    @Override
    public Article toggleLike(Long id, boolean like) {
        UpdateWrapper<Article> wrapper = new UpdateWrapper<>();
        if (like) {
            wrapper.setSql("like_count = like_count + 1").eq("id", id);
        } else {
            wrapper.setSql("like_count = GREATEST(like_count - 1, 0)").eq("id", id);
        }
        mapper.update(null, wrapper);
        return mapper.selectById(id);
    }
}
