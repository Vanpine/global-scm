package com.globalscm.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.globalscm.entity.pojo.Article;
import org.apache.ibatis.annotations.Mapper;

/**
 * 文章 Mapper
 * 对应表 articles —— 新闻文章（war/logi/energy/policy 四个分类）
 * 索引：idx_category / idx_status_published
 */
@Mapper
public interface ArticleMapper extends BaseMapper<Article> {
}
