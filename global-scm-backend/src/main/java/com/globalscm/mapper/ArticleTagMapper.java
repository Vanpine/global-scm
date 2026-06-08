package com.globalscm.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.globalscm.entity.pojo.ArticleTag;
import org.apache.ibatis.annotations.Mapper;

/**
 * 文章标签 Mapper
 * 对应表 article_tags —— 文章关联标签（多对多拆分）
 * 外键 article_id 关联 articles 表，级联删除
 */
@Mapper
public interface ArticleTagMapper extends BaseMapper<ArticleTag> {
}
