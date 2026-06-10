package com.globalscm.controller;

import com.globalscm.entity.dto.Result;
import com.globalscm.service.HomeCarouselService;
import com.globalscm.service.HomeCrisisCardService;
import com.globalscm.service.HomeHeroService;
import com.globalscm.service.HomeSectionService;
import com.globalscm.util.LangResolver;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "首页", description = "首页 Hero、危机卡片、轮播图、区块数据")
@RestController
@RequestMapping("/api/home")
@RequiredArgsConstructor
public class HomeController {

    private final HomeHeroService heroService;
    private final HomeCrisisCardService crisisCardService;
    private final HomeCarouselService carouselService;
    private final HomeSectionService sectionService;

    @Operation(summary = "获取 Hero 区数据")
    @GetMapping("/hero")
    public Result<?> hero(HttpServletRequest request) {
        String lang = LangResolver.resolve(request);
        return Result.ok(heroService.get(lang));
    }

    @Operation(summary = "获取危机卡片列表")
    @GetMapping("/crisis-cards")
    public Result<?> crisisCards(HttpServletRequest request) {
        String lang = LangResolver.resolve(request);
        return Result.ok(crisisCardService.listAll(lang));
    }

    @Operation(summary = "获取轮播图列表")
    @GetMapping("/carousel")
    public Result<?> carousel(HttpServletRequest request) {
        String lang = LangResolver.resolve(request);
        return Result.ok(carouselService.listAll(lang));
    }

    @Operation(summary = "获取首页所有区块")
    @GetMapping("/sections")
    public Result<?> sections(HttpServletRequest request) {
        String lang = LangResolver.resolve(request);
        return Result.ok(sectionService.listAll(lang));
    }
}
