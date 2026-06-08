package com.globalscm.entity.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
@TableName("article_tags")
public class ArticleTag {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long articleId;

    private String tagName;
}
