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
@TableName("home_carousel")
public class HomeCarousel {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String imgUrl;

    private String eyebrow;
    @TableField("eyebrow_en")
    private String eyebrowEn;

    private String title;
    @TableField("title_en")
    private String titleEn;

    private String description;
    @TableField("description_en")
    private String descriptionEn;

    private Integer sortOrder;

    private LocalDateTime updatedAt;
}
