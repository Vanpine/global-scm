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

    private String highlight;

    private String subtitle;

    @TableField("tags_json")
    private String tagsJson;

    private String ctaPrimaryText;

    private String ctaPrimaryHref;

    private String ctaSecondaryText;

    private String ctaSecondaryHref;

    private String videoUrl;

    private LocalDateTime updatedAt;
}
