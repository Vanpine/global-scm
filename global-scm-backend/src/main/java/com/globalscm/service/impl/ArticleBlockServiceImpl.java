package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.ArticleBlock;
import com.globalscm.mapper.ArticleBlockMapper;
import com.globalscm.service.ArticleBlockService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ArticleBlockServiceImpl implements ArticleBlockService {

    private final ArticleBlockMapper mapper;

    @Override
    public List<ArticleBlock> listByArticleId(Long articleId, String lang) {
        List<ArticleBlock> list = mapper.selectList(
            new LambdaQueryWrapper<ArticleBlock>()
                .eq(ArticleBlock::getArticleId, articleId)
                .orderByAsc(ArticleBlock::getSortOrder)
        );
        list.forEach(b -> applyLang(b, lang));
        return list;
    }

    private void applyLang(ArticleBlock b, String lang) {
        if (!"en".equals(lang)) return;
        if (b.getContentEn() != null) b.setContent(b.getContentEn());
    }
}
