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
@TableName("page_sections")
public class PageSection {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String page;

    private String section;

    private String title;

    private String subtitle;

    @TableField("items_json")
    private String itemsJson;

    private Integer sortOrder;

    private LocalDateTime updatedAt;
}
