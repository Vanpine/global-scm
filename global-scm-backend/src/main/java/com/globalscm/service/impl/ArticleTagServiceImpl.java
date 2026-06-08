package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.ArticleTag;
import com.globalscm.mapper.ArticleTagMapper;
import com.globalscm.service.ArticleTagService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 文章标签业务实现
 * 标签用于关联检索和热门推荐
 */
@Service
@RequiredArgsConstructor
public class ArticleTagServiceImpl implements ArticleTagService {

    private final ArticleTagMapper mapper;

    /**
     * 按文章 ID 查询所有关联标签
     * 例：文章"红海危机"的标签为 ["红海", "好望角", "弹性路由", "海运"]
     */
    @Override
    public List<ArticleTag> listByArticleId(Long articleId) {
        return mapper.selectList(
            new LambdaQueryWrapper<ArticleTag>().eq(ArticleTag::getArticleId, articleId)
        );
    }
}
