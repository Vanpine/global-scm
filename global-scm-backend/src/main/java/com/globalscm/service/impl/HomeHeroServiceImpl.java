package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.HomeHero;
import com.globalscm.mapper.HomeHeroMapper;
import com.globalscm.service.HomeHeroService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class HomeHeroServiceImpl implements HomeHeroService {

    private final HomeHeroMapper mapper;

    @Override
    public HomeHero get(String lang) {
        HomeHero hero = mapper.selectOne(new LambdaQueryWrapper<HomeHero>().last("LIMIT 1"));
        if (hero != null) {
            applyLang(hero, lang);
        }
        return hero;
    }

    @Override
    public void update(HomeHero hero) {
        mapper.updateById(hero);
    }

    private void applyLang(HomeHero h, String lang) {
        if (!"en".equals(lang)) return;
        if (h.getTitleEn() != null) h.setTitle(h.getTitleEn());
        if (h.getHighlightEn() != null) h.setHighlight(h.getHighlightEn());
        if (h.getSubtitleEn() != null) h.setSubtitle(h.getSubtitleEn());
        if (h.getTagsJsonEn() != null) h.setTagsJson(h.getTagsJsonEn());
        if (h.getCtaPrimaryTextEn() != null) h.setCtaPrimaryText(h.getCtaPrimaryTextEn());
        if (h.getCtaSecondaryTextEn() != null) h.setCtaSecondaryText(h.getCtaSecondaryTextEn());
    }
}
