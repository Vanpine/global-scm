package com.globalscm.entity.vo;

import com.globalscm.entity.pojo.ArticleTag;
import lombok.Data;

@Data
public class ArticleTagVo {
    private Long id;
    private Long articleId;
    private String tagName;

    public static ArticleTagVo from(ArticleTag e, String lang) {
        ArticleTagVo vo = new ArticleTagVo();
        vo.setId(e.getId());
        boolean en = "en".equals(lang);
        vo.setTagName(en && e.getTagNameEn() != null ? e.getTagNameEn() : e.getTagName());
        vo.setArticleId(e.getArticleId());
        return vo;
    }
}
