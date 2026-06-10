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
@TableName("home_hero")
public class HomeHero {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String title;
    @TableField("title_en")
    private String titleEn;

    private String highlight;
    @TableField("highlight_en")
    private String highlightEn;

    private String subtitle;
    @TableField("subtitle_en")
    private String subtitleEn;

    @TableField("tags_json")
    private String tagsJson;
    @TableField("tags_json_en")
    private String tagsJsonEn;

    private String ctaPrimaryText;
    @TableField("cta_primary_text_en")
    private String ctaPrimaryTextEn;

    private String ctaPrimaryHref;

    private String ctaSecondaryText;
    @TableField("cta_secondary_text_en")
    private String ctaSecondaryTextEn;

    private String ctaSecondaryHref;

    private String videoUrl;

    private LocalDateTime updatedAt;
}
