package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.HomeCarousel;
import com.globalscm.mapper.HomeCarouselMapper;
import com.globalscm.service.HomeCarouselService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 首页轮播图业务实现
 */
@Service
@RequiredArgsConstructor
public class HomeCarouselServiceImpl implements HomeCarouselService {

    private final HomeCarouselMapper mapper;

    /**
     * 全量查询轮播图，按 sort_order 升序
     */
    @Override
    public List<HomeCarousel> listAll() {
        return mapper.selectList(new LambdaQueryWrapper<HomeCarousel>().orderByAsc(HomeCarousel::getSortOrder));
    }
}
