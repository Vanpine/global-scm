package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.HomeCrisisCard;
import com.globalscm.mapper.HomeCrisisCardMapper;
import com.globalscm.service.HomeCrisisCardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class HomeCrisisCardServiceImpl implements HomeCrisisCardService {

    private final HomeCrisisCardMapper mapper;

    @Override
    public List<HomeCrisisCard> listAll(String lang) {
        List<HomeCrisisCard> list = mapper.selectList(
            new LambdaQueryWrapper<HomeCrisisCard>().orderByAsc(HomeCrisisCard::getSortOrder)
        );
        list.forEach(c -> applyLang(c, lang));
        return list;
    }

    private void applyLang(HomeCrisisCard c, String lang) {
        if (!"en".equals(lang)) return;
        if (c.getTagEn() != null) c.setTag(c.getTagEn());
        if (c.getTitleEn() != null) c.setTitle(c.getTitleEn());
        if (c.getDescriptionEn() != null) c.setDescription(c.getDescriptionEn());
        if (c.getItemsJsonEn() != null) c.setItemsJson(c.getItemsJsonEn());
    }
}
