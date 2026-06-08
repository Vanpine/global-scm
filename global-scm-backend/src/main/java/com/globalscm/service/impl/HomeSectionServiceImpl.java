package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.HomeSection;
import com.globalscm.mapper.HomeSectionMapper;
import com.globalscm.service.HomeSectionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 首页区块业务实现
 * 管理 stats / mission / ai-empowerment / risk-feed / cta 五个区块
 */
@Service
@RequiredArgsConstructor
public class HomeSectionServiceImpl implements HomeSectionService {

    private final HomeSectionMapper mapper;

    /**
     * 全量查询首页区块，按 sort_order 升序
     * 保证前端渲染顺序固定，区块通过 section 字段区分类型
     */
    @Override
    public List<HomeSection> listAll() {
        return mapper.selectList(new LambdaQueryWrapper<HomeSection>().orderByAsc(HomeSection::getSortOrder));
    }
}
