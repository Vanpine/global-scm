package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.PageSection;
import com.globalscm.entity.vo.PageSectionVo;
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
    public List<PageSectionVo> listByPage(String page, String lang) {
        List<PageSection> list = mapper.selectList(
            new LambdaQueryWrapper<PageSection>()
                .eq(PageSection::getPage, page)
                .orderByAsc(PageSection::getSortOrder)
        );
        return list.stream().map(s -> PageSectionVo.from(s, lang)).toList();
    }
}
