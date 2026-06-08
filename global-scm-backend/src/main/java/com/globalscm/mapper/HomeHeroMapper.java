package com.globalscm.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.globalscm.entity.pojo.HomeHero;
import org.apache.ibatis.annotations.Mapper;

/**
 * 首页 Hero 区 Mapper
 * 对应表 home_hero —— 首页主视觉区配置（标题、引导语、标签、按钮、视频）
 */
@Mapper
public interface HomeHeroMapper extends BaseMapper<HomeHero> {
}
