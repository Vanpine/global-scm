package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.ArticleTag;
import com.globalscm.entity.vo.ArticleTagVo;
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
    public List<ArticleTagVo> listByArticleId(Long articleId, String lang) {
        List<ArticleTag> list = mapper.selectList(
            new LambdaQueryWrapper<ArticleTag>().eq(ArticleTag::getArticleId, articleId)
        );
        return list.stream().map(t -> ArticleTagVo.from(t, lang)).toList();
    }
}
