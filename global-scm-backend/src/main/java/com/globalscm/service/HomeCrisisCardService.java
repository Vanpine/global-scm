package com.globalscm.service;

import com.globalscm.entity.pojo.HomeCrisisCard;

import java.util.List;

/**
 * 首页危机卡片业务接口
 * 展示当前全球供应链面临的六大危机类型
 */
public interface HomeCrisisCardService {

    /**
     * 获取所有危机卡片，按 sort_order 升序排列
     * @return 危机卡片列表（共 6 张：贸易政策、地缘政治、物流瓶颈、需求风险、供应风险、网络安全）
     */
    List<HomeCrisisCard> listAll();
}
