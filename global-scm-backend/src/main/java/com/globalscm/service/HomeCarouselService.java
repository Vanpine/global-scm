package com.globalscm.service;

import com.globalscm.entity.pojo.HomeCarousel;

import java.util.List;

/**
 * 首页轮播图业务接口
 */
public interface HomeCarouselService {

    /**
     * 获取所有轮播图，按 sort_order 升序排列
     * @return 轮播图列表（共 4 张）
     */
    List<HomeCarousel> listAll();
}
