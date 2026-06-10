package com.globalscm.service;

import com.globalscm.entity.pojo.ArticleBlock;

import java.util.List;

public interface ArticleBlockService {

    List<ArticleBlock> listByArticleId(Long articleId, String lang);
}
