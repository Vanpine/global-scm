package com.globalscm.controller;

import com.globalscm.entity.dto.Result;
import com.globalscm.service.ArticleBlockService;
import com.globalscm.service.ArticleService;
import com.globalscm.service.ArticleTagService;
import com.globalscm.util.LangResolver;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Tag(name = "新闻文章", description = "文章列表、详情（含内容块和标签）")
@RestController
@RequestMapping("/api/articles")
@RequiredArgsConstructor
public class ArticleController {

    private final ArticleService articleService;
    private final ArticleBlockService blockService;
    private final ArticleTagService tagService;

    @Operation(summary = "获取文章列表")
    @GetMapping
    public Result<?> list(
            @Parameter(description = "分类筛选：war / logi / energy / policy，不传返回全部")
            @RequestParam(required = false) String category,
            HttpServletRequest request) {
        String lang = LangResolver.resolve(request);
        List<?> records = (category != null && !category.isEmpty())
            ? articleService.listByCategory(category, lang)
            : articleService.listAll(lang);
        return Result.ok(Map.of("records", records));
    }

    @Operation(summary = "获取文章详情")
    @GetMapping("/{id}")
    public Result<?> detail(@PathVariable Long id, HttpServletRequest request) {
        String lang = LangResolver.resolve(request);
        var article = articleService.getById(id, lang);
        if (article == null) {
            return Result.fail(404, "文章不存在");
        }
        var blocks = blockService.listByArticleId(id, lang);
        var tags = tagService.listByArticleId(id, lang);
        return Result.ok(Map.of(
            "article", article,
            "blocks", blocks,
            "tags", tags
        ));
    }

    @Operation(summary = "递增文章阅读量")
    @PostMapping("/{id}/view")
    public Result<?> incrementView(@PathVariable Long id) {
        var article = articleService.incrementViewCount(id);
        if (article == null) {
            return Result.fail(404, "文章不存在");
        }
        return Result.ok(Map.of(
            "viewCount", article.getViewCount(),
            "likeCount", article.getLikeCount()
        ));
    }

    @Operation(summary = "点赞/取消点赞")
    @PostMapping("/{id}/like")
    public Result<?> toggleLike(@PathVariable Long id, @RequestBody Map<String, Boolean> body) {
        Boolean liked = body.get("liked");
        if (liked == null) {
            return Result.fail(400, "缺少 liked 参数");
        }
        var article = articleService.toggleLike(id, liked);
        if (article == null) {
            return Result.fail(404, "文章不存在");
        }
        return Result.ok(Map.of(
            "viewCount", article.getViewCount(),
            "likeCount", article.getLikeCount()
        ));
    }
}
