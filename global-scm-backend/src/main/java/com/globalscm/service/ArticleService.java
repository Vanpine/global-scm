package com.globalscm.service;

import com.globalscm.entity.pojo.Article;

import java.util.List;

public interface ArticleService {

    List<Article> listAll(String lang);

    List<Article> listByCategory(String category, String lang);

    Article getById(Long id, String lang);

    Article incrementViewCount(Long id);

    Article toggleLike(Long id, boolean like);
}
