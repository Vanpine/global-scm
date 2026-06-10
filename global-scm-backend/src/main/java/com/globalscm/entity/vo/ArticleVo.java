package com.globalscm.entity.vo;

import com.globalscm.entity.pojo.Article;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ArticleVo {
    private Long id;
    private String title;
    private String summary;
    private String category;
    private String coverImg;
    private String source;
    private String sourceUrl;
    private String meta;
    private String status;
    private LocalDateTime publishedAt;
    private LocalDateTime createdAt;
    private Integer viewCount;
    private Integer likeCount;

    public static ArticleVo from(Article e, String lang) {
        ArticleVo vo = new ArticleVo();
        vo.setId(e.getId());
        boolean en = "en".equals(lang);
        vo.setTitle(en && e.getTitleEn() != null ? e.getTitleEn() : e.getTitle());
        vo.setSummary(en && e.getSummaryEn() != null ? e.getSummaryEn() : e.getSummary());
        vo.setMeta(en && e.getMetaEn() != null ? e.getMetaEn() : e.getMeta());
        vo.setCategory(e.getCategory());
        vo.setCoverImg(e.getCoverImg());
        vo.setSource(e.getSource());
        vo.setSourceUrl(e.getSourceUrl());
        vo.setStatus(e.getStatus());
        vo.setPublishedAt(e.getPublishedAt());
        vo.setCreatedAt(e.getCreatedAt());
        vo.setViewCount(e.getViewCount());
        vo.setLikeCount(e.getLikeCount());
        return vo;
    }
}
