package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.HomeSection;
import com.globalscm.mapper.HomeSectionMapper;
import com.globalscm.service.HomeSectionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class HomeSectionServiceImpl implements HomeSectionService {

    private final HomeSectionMapper mapper;

    @Override
    public List<HomeSection> listAll(String lang) {
        List<HomeSection> list = mapper.selectList(
            new LambdaQueryWrapper<HomeSection>().orderByAsc(HomeSection::getSortOrder)
        );
        list.forEach(s -> applyLang(s, lang));
        return list;
    }

    private void applyLang(HomeSection s, String lang) {
        if (!"en".equals(lang)) return;
        if (s.getTitleEn() != null) s.setTitle(s.getTitleEn());
        if (s.getSubtitleEn() != null) s.setSubtitle(s.getSubtitleEn());
        if (s.getItemsJsonEn() != null) s.setItemsJson(s.getItemsJsonEn());
    }
}
