package com.globalscm.service;

import com.globalscm.entity.pojo.Article;
import com.globalscm.entity.vo.ArticleVo;

import java.util.List;

public interface ArticleService {

    List<ArticleVo> listAll(String lang);

    List<ArticleVo> listByCategory(String category, String lang);

    ArticleVo getById(Long id, String lang);

    Article incrementViewCount(Long id);

    Article toggleLike(Long id, boolean like);
}
