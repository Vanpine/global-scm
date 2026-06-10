package com.globalscm.entity.vo;

import com.globalscm.entity.pojo.HomeCrisisCard;
import lombok.Data;

@Data
public class HomeCrisisCardVo {
    private Long id;
    private String tag;
    private String title;
    private String description;
    private String itemsJson;
    private String imgUrl;
    private Integer sortOrder;

    public static HomeCrisisCardVo from(HomeCrisisCard e, String lang) {
        HomeCrisisCardVo vo = new HomeCrisisCardVo();
        vo.setId(e.getId());
        boolean en = "en".equals(lang);
        vo.setTag(en && e.getTagEn() != null ? e.getTagEn() : e.getTag());
        vo.setTitle(en && e.getTitleEn() != null ? e.getTitleEn() : e.getTitle());
        vo.setDescription(en && e.getDescriptionEn() != null ? e.getDescriptionEn() : e.getDescription());
        vo.setItemsJson(en && e.getItemsJsonEn() != null ? e.getItemsJsonEn() : e.getItemsJson());
        vo.setImgUrl(e.getImgUrl());
        vo.setSortOrder(e.getSortOrder());
        return vo;
    }
}
