package com.globalscm.entity.vo;

import com.globalscm.entity.pojo.HomeCarousel;
import lombok.Data;

@Data
public class HomeCarouselVo {
    private Long id;
    private String imgUrl;
    private String eyebrow;
    private String title;
    private String description;
    private Integer sortOrder;

    public static HomeCarouselVo from(HomeCarousel e, String lang) {
        HomeCarouselVo vo = new HomeCarouselVo();
        vo.setId(e.getId());
        boolean en = "en".equals(lang);
        vo.setEyebrow(en && e.getEyebrowEn() != null ? e.getEyebrowEn() : e.getEyebrow());
        vo.setTitle(en && e.getTitleEn() != null ? e.getTitleEn() : e.getTitle());
        vo.setDescription(en && e.getDescriptionEn() != null ? e.getDescriptionEn() : e.getDescription());
        vo.setImgUrl(e.getImgUrl());
        vo.setSortOrder(e.getSortOrder());
        return vo;
    }
}
