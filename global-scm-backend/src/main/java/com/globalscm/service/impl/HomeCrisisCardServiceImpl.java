package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.HomeCrisisCard;
import com.globalscm.mapper.HomeCrisisCardMapper;
import com.globalscm.service.HomeCrisisCardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 首页危机卡片业务实现
 */
@Service
@RequiredArgsConstructor
public class HomeCrisisCardServiceImpl implements HomeCrisisCardService {

    private final HomeCrisisCardMapper mapper;

    /**
     * 全量查询危机卡片，按 sort_order 升序
     * 保证前端渲染顺序为：贸易政策 → 地缘政治 → 物流瓶颈 → 需求风险 → 供应风险 → 网络安全
     */
    @Override
    public List<HomeCrisisCard> listAll() {
        return mapper.selectList(new LambdaQueryWrapper<HomeCrisisCard>().orderByAsc(HomeCrisisCard::getSortOrder));
    }
}
