package com.globalscm.controller;

import com.globalscm.entity.dto.Result;
import com.globalscm.service.HomeCarouselService;
import com.globalscm.service.HomeCrisisCardService;
import com.globalscm.service.HomeHeroService;
import com.globalscm.service.HomeSectionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 首页控制器
 * 提供首页所需的全部数据接口：Hero区、危机卡片、轮播图、各区块内容
 */
@Tag(name = "首页", description = "首页 Hero、危机卡片、轮播图、区块数据")
@RestController
@RequestMapping("/api/home")
@RequiredArgsConstructor
public class HomeController {

    private final HomeHeroService heroService;
    private final HomeCrisisCardService crisisCardService;
    private final HomeCarouselService carouselService;
    private final HomeSectionService sectionService;

    /**
     * 获取首页 Hero 区数据
     * 包含主标题、高亮词、引导语、标签行、双按钮、背景视频
     */
    @Operation(summary = "获取 Hero 区数据")
    @GetMapping("/hero")
    public Result<?> hero() {
        return Result.ok(heroService.get());
    }

    /**
     * 获取首页多重危机卡片列表
     * 返回 6 张卡片，按 sort_order 升序排列
     * 涵盖：贸易政策、地缘政治、物流瓶颈、需求风险、供应风险、网络安全
     */
    @Operation(summary = "获取危机卡片列表")
    @GetMapping("/crisis-cards")
    public Result<?> crisisCards() {
        return Result.ok(crisisCardService.listAll());
    }

    /**
     * 获取首页轮播图列表
     * 返回 4 张轮播图，按 sort_order 升序排列
     */
    @Operation(summary = "获取轮播图列表")
    @GetMapping("/carousel")
    public Result<?> carousel() {
        return Result.ok(carouselService.listAll());
    }

    /**
     * 获取首页所有区块内容
     * 包含 5 个区块：stats（指标）、mission（使命）、ai-empowerment（AI赋能）、risk-feed（风险快讯）、cta（行动号召）
     */
    @Operation(summary = "获取首页所有区块")
    @GetMapping("/sections")
    public Result<?> sections() {
        return Result.ok(sectionService.listAll());
    }
}
