package com.globalscm.entity.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
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

    private String title;

    private String description;

    private Integer sortOrder;

    private LocalDateTime updatedAt;
}
