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
@TableName("home_crisis_cards")
public class HomeCrisisCard {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String tag;
    @TableField("tag_en")
    private String tagEn;

    private String title;
    @TableField("title_en")
    private String titleEn;

    private String description;
    @TableField("description_en")
    private String descriptionEn;

    @TableField("items_json")
    private String itemsJson;
    @TableField("items_json_en")
    private String itemsJsonEn;

    private String imgUrl;

    private Integer sortOrder;

    private LocalDateTime updatedAt;
}
