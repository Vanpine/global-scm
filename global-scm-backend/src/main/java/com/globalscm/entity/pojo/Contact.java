package com.globalscm.entity.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.experimental.Accessors;

import java.time.LocalDateTime;

@Data
@Accessors(chain = true)
@TableName("contacts")
public class Contact {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;

    private String company;

    private String email;

    private String phone;

    private String message;

    private LocalDateTime createdAt;
}
