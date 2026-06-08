package com.globalscm.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.globalscm.entity.pojo.HomeCarousel;
import org.apache.ibatis.annotations.Mapper;

/**
 * 首页轮播图 Mapper
 * 对应表 home_carousel —— 首页轮播图（4 张，按 sort_order 排序）
 */
@Mapper
public interface HomeCarouselMapper extends BaseMapper<HomeCarousel> {
}
