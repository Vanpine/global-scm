package com.globalscm.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.globalscm.entity.pojo.Contact;
import org.apache.ibatis.annotations.Mapper;

/**
 * 联系我们 Mapper
 * 对应表 contacts —— 用户联系表单提交记录
 */
@Mapper
public interface ContactMapper extends BaseMapper<Contact> {
}
