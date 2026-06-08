package com.globalscm.service.impl;

import com.globalscm.entity.pojo.Contact;
import com.globalscm.mapper.ContactMapper;
import com.globalscm.service.ContactService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * 联系我们业务实现
 * 保存用户提交的联系表单到数据库
 */
@Service
@RequiredArgsConstructor
public class ContactServiceImpl implements ContactService {

    private final ContactMapper mapper;

    /**
     * 新增一条联系记录
     * 自动生成 ID 和创建时间（created_at），无需手动设置
     */
    @Override
    public void save(Contact contact) {
        mapper.insert(contact);
    }
}
