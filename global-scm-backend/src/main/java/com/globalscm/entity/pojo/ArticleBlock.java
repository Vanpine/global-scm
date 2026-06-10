package com.globalscm.entity.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
@TableName("article_blocks")
public class ArticleBlock {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long articleId;

    private String blockType;

    private String content;
    @TableField("content_en")
    private String contentEn;

    private Integer sortOrder;
}
