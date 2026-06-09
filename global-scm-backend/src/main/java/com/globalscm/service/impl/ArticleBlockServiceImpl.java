package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.ArticleBlock;
import com.globalscm.mapper.ArticleBlockMapper;
import com.globalscm.service.ArticleBlockService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 文章内容块业务实现
 */
@Service
@RequiredArgsConstructor
public class ArticleBlockServiceImpl implements ArticleBlockService {

    private final ArticleBlockMapper mapper;

    @Override
    public List<ArticleBlock> listByArticleId(Long articleId) {
        return mapper.selectList(
            new LambdaQueryWrapper<ArticleBlock>()
                .eq(ArticleBlock::getArticleId, articleId)
                .orderByAsc(ArticleBlock::getSortOrder)
        );
    }
}
