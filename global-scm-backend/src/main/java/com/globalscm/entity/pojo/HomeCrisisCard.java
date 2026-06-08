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

    private String title;

    private String description;

    @TableField("items_json")
    private String itemsJson;

    private String imgUrl;

    private Integer sortOrder;

    private LocalDateTime updatedAt;
}
