package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.HomeCarousel;
import com.globalscm.entity.vo.HomeCarouselVo;
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
    public List<HomeCarouselVo> listAll(String lang) {
        List<HomeCarousel> list = mapper.selectList(
            new LambdaQueryWrapper<HomeCarousel>().orderByAsc(HomeCarousel::getSortOrder)
        );
        return list.stream().map(e -> HomeCarouselVo.from(e, lang)).toList();
    }
}
