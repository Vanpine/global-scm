package com.globalscm.controller;

import com.globalscm.entity.dto.Result;
import com.globalscm.service.PageSectionService;
import com.globalscm.util.LangResolver;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "页面区块", description = "产品、解决方案、为什么选我们、情报、联系我们、痛点")
@RestController
@RequestMapping("/api/page")
@RequiredArgsConstructor
public class PageController {

    private final PageSectionService pageSectionService;

    @Operation(summary = "按页面标识获取区块列表")
    @GetMapping("/{page}")
    public Result<?> page(
            @Parameter(description = "页面标识：products / solutions / why-us / intel / contact / pain-points")
            @PathVariable String page,
            HttpServletRequest request) {
        String lang = LangResolver.resolve(request);
        return Result.ok(pageSectionService.listByPage(page, lang));
    }
}
