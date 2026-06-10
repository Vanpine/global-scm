package com.globalscm.service;

import com.globalscm.entity.vo.ArticleBlockVo;

import java.util.List;

public interface ArticleBlockService {

    List<ArticleBlockVo> listByArticleId(Long articleId, String lang);
}
