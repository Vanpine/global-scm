package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.HomeCarousel;
import com.globalscm.mapper.HomeCarouselMapper;
import com.globalscm.service.HomeCarouselService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class HomeCarouselServiceImpl implements HomeCarouselService {

    private final HomeCarouselMapper mapper;

    @Override
    public List<HomeCarousel> listAll(String lang) {
        List<HomeCarousel> list = mapper.selectList(
            new LambdaQueryWrapper<HomeCarousel>().orderByAsc(HomeCarousel::getSortOrder)
        );
        list.forEach(c -> applyLang(c, lang));
        return list;
    }

    private void applyLang(HomeCarousel c, String lang) {
        if (!"en".equals(lang)) return;
        if (c.getEyebrowEn() != null) c.setEyebrow(c.getEyebrowEn());
        if (c.getTitleEn() != null) c.setTitle(c.getTitleEn());
        if (c.getDescriptionEn() != null) c.setDescription(c.getDescriptionEn());
    }
}
