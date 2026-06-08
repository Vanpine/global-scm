package com.globalscm.service;

import com.globalscm.entity.pojo.HomeHero;

/**
 * 首页 Hero 区业务接口
 * 存储首页主视觉区的标题、引导语、按钮、视频等配置
 */
public interface HomeHeroService {

    /**
     * 获取 Hero 配置（表中仅有一条记录）
     * @return Hero 实体，包含标题、高亮词、引导语、标签、双按钮、视频地址
     */
    HomeHero get();

    /**
     * 更新 Hero 配置
     * @param hero 要更新的 Hero 实体（按 id 匹配）
     */
    void update(HomeHero hero);
}
