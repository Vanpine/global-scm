package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.HomeHero;
import com.globalscm.mapper.HomeHeroMapper;
import com.globalscm.service.HomeHeroService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * 首页 Hero 区业务实现
 */
@Service
@RequiredArgsConstructor
public class HomeHeroServiceImpl implements HomeHeroService {

    private final HomeHeroMapper mapper;

    /**
     * 查询表中第一条记录作为 Hero 配置
     * 使用 LIMIT 1 确保只返回一条
     */
    @Override
    public HomeHero get() {
        return mapper.selectOne(new LambdaQueryWrapper<HomeHero>().last("LIMIT 1"));
    }

    /**
     * 按主键 ID 更新 Hero 配置的各个字段
     */
    @Override
    public void update(HomeHero hero) {
        mapper.updateById(hero);
    }
}
