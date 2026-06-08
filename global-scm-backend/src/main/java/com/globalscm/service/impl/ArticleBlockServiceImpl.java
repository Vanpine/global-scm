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
 * 内容块通过 sort_order 拼接成完整文章，前端按序渲染
 */
@Service
@RequiredArgsConstructor
public class ArticleBlockServiceImpl implements ArticleBlockService {

    private final ArticleBlockMapper mapper;

    /**
     * 按文章 ID 查询所有内容块，按 sort_order 升序
     * blockType 包括 kt（关键信息框）、lead（引导语）、p（正文段落）、quote（引用）
     */
    @Override
    public List<ArticleBlock> listByArticleId(Long articleId) {
        return mapper.selectList(
            new LambdaQueryWrapper<ArticleBlock>()
                .eq(ArticleBlock::getArticleId, articleId)
                .orderByAsc(ArticleBlock::getSortOrder)
        );
    }
}
