package com.globalscm.entity.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;

@Data
@Accessors(chain = true)
@TableName("articles")
public class Article {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String title;
    @TableField("title_en")
    private String titleEn;

    private String summary;
    @TableField("summary_en")
    private String summaryEn;

    private String category;

    private String coverImg;

    private String source;

    private String sourceUrl;

    private String meta;
    @TableField("meta_en")
    private String metaEn;

    private String status;

    private LocalDateTime publishedAt;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private Integer viewCount;

    private Integer likeCount;
}
