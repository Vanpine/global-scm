package com.globalscm.entity.vo;

import com.globalscm.entity.pojo.HomeHero;
import lombok.Data;

@Data
public class HomeHeroVo {
    private Long id;
    private String title;
    private String highlight;
    private String subtitle;
    private String tagsJson;
    private String ctaPrimaryText;
    private String ctaPrimaryHref;
    private String ctaSecondaryText;
    private String ctaSecondaryHref;
    private String videoUrl;

    public static HomeHeroVo from(HomeHero e, String lang) {
        HomeHeroVo vo = new HomeHeroVo();
        vo.setId(e.getId());
        boolean en = "en".equals(lang);
        vo.setTitle(en && e.getTitleEn() != null ? e.getTitleEn() : e.getTitle());
        vo.setHighlight(en && e.getHighlightEn() != null ? e.getHighlightEn() : e.getHighlight());
        vo.setSubtitle(en && e.getSubtitleEn() != null ? e.getSubtitleEn() : e.getSubtitle());
        vo.setTagsJson(en && e.getTagsJsonEn() != null ? e.getTagsJsonEn() : e.getTagsJson());
        vo.setCtaPrimaryText(en && e.getCtaPrimaryTextEn() != null ? e.getCtaPrimaryTextEn() : e.getCtaPrimaryText());
        vo.setCtaPrimaryHref(e.getCtaPrimaryHref());
        vo.setCtaSecondaryText(en && e.getCtaSecondaryTextEn() != null ? e.getCtaSecondaryTextEn() : e.getCtaSecondaryText());
        vo.setCtaSecondaryHref(e.getCtaSecondaryHref());
        vo.setVideoUrl(e.getVideoUrl());
        return vo;
    }
}
