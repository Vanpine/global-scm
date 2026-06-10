package com.globalscm.entity.vo;

import com.globalscm.entity.pojo.HomeSection;
import lombok.Data;

@Data
public class HomeSectionVo {
    private Long id;
    private String section;
    private String title;
    private String subtitle;
    private String itemsJson;
    private Integer sortOrder;

    public static HomeSectionVo from(HomeSection e, String lang) {
        HomeSectionVo vo = new HomeSectionVo();
        vo.setId(e.getId());
        boolean en = "en".equals(lang);
        vo.setTitle(en && e.getTitleEn() != null ? e.getTitleEn() : e.getTitle());
        vo.setSubtitle(en && e.getSubtitleEn() != null ? e.getSubtitleEn() : e.getSubtitle());
        vo.setItemsJson(en && e.getItemsJsonEn() != null ? e.getItemsJsonEn() : e.getItemsJson());
        vo.setSection(e.getSection());
        vo.setSortOrder(e.getSortOrder());
        return vo;
    }
}
