package com.globalscm.service;

import com.globalscm.entity.pojo.Contact;

/**
 * 联系我们业务接口
 * 处理用户提交的联系表单数据
 */
public interface ContactService {

    /**
     * 保存联系表单提交记录
     *
     * @param contact 联系表单实体 { name, company, email, phone, message }
     */
    void save(Contact contact);
}
