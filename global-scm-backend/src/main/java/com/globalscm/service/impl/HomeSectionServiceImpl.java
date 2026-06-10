package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.HomeSection;
import com.globalscm.entity.vo.HomeSectionVo;
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
    public List<HomeSectionVo> listAll(String lang) {
        List<HomeSection> list = mapper.selectList(
            new LambdaQueryWrapper<HomeSection>().orderByAsc(HomeSection::getSortOrder)
        );
        return list.stream().map(s -> HomeSectionVo.from(s, lang)).toList();
    }
}
