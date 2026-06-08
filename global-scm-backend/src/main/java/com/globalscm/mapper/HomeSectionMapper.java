package com.globalscm.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.globalscm.entity.pojo.HomeSection;
import org.apache.ibatis.annotations.Mapper;

/**
 * 首页区块 Mapper
 * 对应表 home_sections —— 首页五大区块（stats/mission/ai-empowerment/risk-feed/cta）
 */
@Mapper
public interface HomeSectionMapper extends BaseMapper<HomeSection> {
}
