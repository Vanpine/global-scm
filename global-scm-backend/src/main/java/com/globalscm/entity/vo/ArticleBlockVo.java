package com.globalscm.entity.vo;

import com.globalscm.entity.pojo.ArticleBlock;
import lombok.Data;

@Data
public class ArticleBlockVo {
    private Long id;
    private Long articleId;
    private String blockType;
    private String content;
    private Integer sortOrder;

    public static ArticleBlockVo from(ArticleBlock e, String lang) {
        ArticleBlockVo vo = new ArticleBlockVo();
        vo.setId(e.getId());
        boolean en = "en".equals(lang);
        vo.setContent(en && e.getContentEn() != null ? e.getContentEn() : e.getContent());
        vo.setArticleId(e.getArticleId());
        vo.setBlockType(e.getBlockType());
        vo.setSortOrder(e.getSortOrder());
        return vo;
    }
}
