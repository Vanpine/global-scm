package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.PageSection;
import com.globalscm.mapper.PageSectionMapper;
import com.globalscm.service.PageSectionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 页面区块业务实现
 * 支持 6 个页面（products / solutions / why-us / intel / contact / pain-points）的区块查询
 */
@Service
@RequiredArgsConstructor
public class PageSectionServiceImpl implements PageSectionService {

    private final PageSectionMapper mapper;

    /**
     * 根据页面标识查询该页面所有区块，按 sort_order 升序
     * 例如 page="products" 返回六大模块、AI引擎、CTA 等区块
     */
    @Override
    public List<PageSection> listByPage(String page) {
        return mapper.selectList(
            new LambdaQueryWrapper<PageSection>()
                .eq(PageSection::getPage, page)
                .orderByAsc(PageSection::getSortOrder)
        );
    }
}
