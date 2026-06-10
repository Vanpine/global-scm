package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.ArticleTag;
import com.globalscm.mapper.ArticleTagMapper;
import com.globalscm.service.ArticleTagService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ArticleTagServiceImpl implements ArticleTagService {

    private final ArticleTagMapper mapper;

    @Override
    public List<ArticleTag> listByArticleId(Long articleId, String lang) {
        List<ArticleTag> list = mapper.selectList(
            new LambdaQueryWrapper<ArticleTag>().eq(ArticleTag::getArticleId, articleId)
        );
        list.forEach(t -> applyLang(t, lang));
        return list;
    }

    private void applyLang(ArticleTag t, String lang) {
        if (!"en".equals(lang)) return;
        if (t.getTagNameEn() != null) t.setTagName(t.getTagNameEn());
    }
}
