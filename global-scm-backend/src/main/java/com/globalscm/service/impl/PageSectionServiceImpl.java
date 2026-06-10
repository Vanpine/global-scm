package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.PageSection;
import com.globalscm.mapper.PageSectionMapper;
import com.globalscm.service.PageSectionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PageSectionServiceImpl implements PageSectionService {

    private final PageSectionMapper mapper;

    @Override
    public List<PageSection> listByPage(String page, String lang) {
        List<PageSection> list = mapper.selectList(
            new LambdaQueryWrapper<PageSection>()
                .eq(PageSection::getPage, page)
                .orderByAsc(PageSection::getSortOrder)
        );
        list.forEach(s -> applyLang(s, lang));
        return list;
    }

    private void applyLang(PageSection s, String lang) {
        if (!"en".equals(lang)) return;
        if (s.getTitleEn() != null) s.setTitle(s.getTitleEn());
        if (s.getSubtitleEn() != null) s.setSubtitle(s.getSubtitleEn());
        if (s.getItemsJsonEn() != null) s.setItemsJson(s.getItemsJsonEn());
    }
}
