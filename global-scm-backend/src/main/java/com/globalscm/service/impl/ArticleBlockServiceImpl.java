package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.ArticleBlock;
import com.globalscm.entity.vo.ArticleBlockVo;
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
    public List<ArticleBlockVo> listByArticleId(Long articleId, String lang) {
        List<ArticleBlock> list = mapper.selectList(
            new LambdaQueryWrapper<ArticleBlock>()
                .eq(ArticleBlock::getArticleId, articleId)
                .orderByAsc(ArticleBlock::getSortOrder)
        );
        return list.stream().map(b -> ArticleBlockVo.from(b, lang)).toList();
    }
}
