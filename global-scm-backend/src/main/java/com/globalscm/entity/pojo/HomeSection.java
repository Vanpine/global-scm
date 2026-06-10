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
@TableName("home_sections")
public class HomeSection {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String section;

    private String title;
    @TableField("title_en")
    private String titleEn;

    private String subtitle;
    @TableField("subtitle_en")
    private String subtitleEn;

    @TableField("items_json")
    private String itemsJson;
    @TableField("items_json_en")
    private String itemsJsonEn;

    private Integer sortOrder;

    private LocalDateTime updatedAt;
}
