package com.globalscm.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.globalscm.entity.pojo.ArticleBlock;
import org.apache.ibatis.annotations.Mapper;

/**
 * 文章内容块 Mapper
 * 对应表 article_blocks —— 文章拆分后的内容块（kt/lead/p/quote 四种类型）
 * 外键 article_id 关联 articles 表，级联删除
 */
@Mapper
public interface ArticleBlockMapper extends BaseMapper<ArticleBlock> {
}
