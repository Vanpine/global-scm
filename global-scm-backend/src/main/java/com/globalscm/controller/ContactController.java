package com.globalscm.controller;

import com.globalscm.entity.dto.Result;
import com.globalscm.entity.pojo.Contact;
import com.globalscm.service.ContactService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 联系我们控制器
 * 处理联系表单的提交
 */
@Tag(name = "联系我们", description = "联系表单提交")
@RestController
@RequestMapping("/api/contact")
@RequiredArgsConstructor
public class ContactController {

    private final ContactService contactService;

    /**
     * 提交联系表单
     * 将用户填写的姓名、公司、邮箱、电话、需求描述保存到数据库
     *
     * @param contact 联系表单数据 { name, company, email, phone, message }
     * @return 成功无返回数据
     */
    @Operation(summary = "提交联系表单")
    @PostMapping
    public Result<?> submit(@RequestBody Contact contact) {
        contactService.save(contact);
        return Result.ok(null);
    }
}
