package com.globalscm.service;

import com.globalscm.entity.vo.ArticleTagVo;

import java.util.List;

public interface ArticleTagService {

    List<ArticleTagVo> listByArticleId(Long articleId, String lang);
}
