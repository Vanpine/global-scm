package com.globalscm.service;

import com.globalscm.entity.pojo.HomeSection;

import java.util.List;

/**
 * 首页区块业务接口
 * 首页除 Hero/卡片/轮播图外的其余 5 个区块（指标、使命、AI赋能、风险快讯、CTA）
 */
public interface HomeSectionService {

    /**
     * 获取首页所有区块，按 sort_order 升序排列
     * @return 区块列表（stats、mission、ai-empowerment、risk-feed、cta）
     */
    List<HomeSection> listAll();
}
