package com.globalscm.controller;

import com.globalscm.entity.dto.Result;
import com.globalscm.service.PageSectionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 页面区块控制器
 * 按页面标识返回该页面的所有区块数据（Hero、功能模块、CTA等）
 * 支持 6 个页面：products / solutions / why-us / intel / contact / pain-points
 */
@Tag(name = "页面区块", description = "产品、解决方案、为什么选我们、情报、联系我们、痛点")
@RestController
@RequestMapping("/api/page")
@RequiredArgsConstructor
public class PageController {

    private final PageSectionService pageSectionService;

    /**
     * 根据页面标识获取该页面所有区块列表
     *
     * @param page 页面标识：products | solutions | why-us | intel | contact | pain-points
     * @return 该页面下所有区块数据，按 sort_order 升序排列
     */
    @Operation(summary = "按页面标识获取区块列表")
    @GetMapping("/{page}")
    public Result<?> page(
            @Parameter(description = "页面标识：products / solutions / why-us / intel / contact / pain-points")
            @PathVariable String page) {
        return Result.ok(pageSectionService.listByPage(page));
    }
}
