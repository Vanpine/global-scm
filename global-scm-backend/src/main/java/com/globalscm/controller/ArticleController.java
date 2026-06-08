package com.globalscm.controller;

import com.globalscm.entity.dto.Result;
import com.globalscm.service.ArticleBlockService;
import com.globalscm.service.ArticleService;
import com.globalscm.service.ArticleTagService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 新闻文章控制器
 * 提供文章列表查询（支持分类筛选）和文章详情（含内容块和标签）
 */
@Tag(name = "新闻文章", description = "文章列表、详情（含内容块和标签）")
@RestController
@RequestMapping("/api/articles")
@RequiredArgsConstructor
public class ArticleController {

    private final ArticleService articleService;
    private final ArticleBlockService blockService;
    private final ArticleTagService tagService;

    /**
     * 获取已发布文章列表
     * 可按分类筛选，不传 category 则返回全部
     *
     * @param category 可选分类：war（战争）| logi（物流）| energy（能源）| policy（政策）
     * @return 文章列表，按发布时间倒序排列
     */
    @Operation(summary = "获取文章列表")
    @GetMapping
    public Result<?> list(
            @Parameter(description = "分类筛选：war / logi / energy / policy")
            @RequestParam(required = false) String category) {
        if (category != null && !category.isEmpty()) {
            return Result.ok(articleService.listByCategory(category));
        }
        return Result.ok(articleService.listAll());
    }

    /**
     * 获取文章详情
     * 返回文章信息 + 内容块（按 sort_order 排序） + 标签列表
     *
     * @param id 文章 ID
     * @return article（文章信息）、blocks（内容块数组）、tags（标签数组）
     */
    @Operation(summary = "获取文章详情")
    @GetMapping("/{id}")
    public Result<?> detail(@PathVariable Long id) {
        var article = articleService.getById(id);
        if (article == null) {
            return Result.fail(404, "文章不存在");
        }
        var blocks = blockService.listByArticleId(id);
        var tags = tagService.listByArticleId(id);
        return Result.ok(Map.of(
            "article", article,
            "blocks", blocks,
            "tags", tags
        ));
    }
}
