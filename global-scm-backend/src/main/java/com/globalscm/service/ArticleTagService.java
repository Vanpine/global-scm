package com.globalscm.service;

import com.globalscm.entity.pojo.ArticleTag;

import java.util.List;

public interface ArticleTagService {

    List<ArticleTag> listByArticleId(Long articleId, String lang);
}
