package com.globalscm.entity.vo;

import com.globalscm.entity.pojo.PageSection;
import lombok.Data;

@Data
public class PageSectionVo {
    private Long id;
    private String page;
    private String section;
    private String title;
    private String subtitle;
    private String itemsJson;
    private Integer sortOrder;

    public static PageSectionVo from(PageSection e, String lang) {
        PageSectionVo vo = new PageSectionVo();
        vo.setId(e.getId());
        boolean en = "en".equals(lang);
        vo.setTitle(en && e.getTitleEn() != null ? e.getTitleEn() : e.getTitle());
        vo.setSubtitle(en && e.getSubtitleEn() != null ? e.getSubtitleEn() : e.getSubtitle());
        vo.setItemsJson(en && e.getItemsJsonEn() != null ? e.getItemsJsonEn() : e.getItemsJson());
        vo.setPage(e.getPage());
        vo.setSection(e.getSection());
        vo.setSortOrder(e.getSortOrder());
        return vo;
    }
}
