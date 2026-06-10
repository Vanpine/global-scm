package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.HomeHero;
import com.globalscm.entity.vo.HomeHeroVo;
import com.globalscm.mapper.HomeHeroMapper;
import com.globalscm.service.HomeHeroService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class HomeHeroServiceImpl implements HomeHeroService {

    private final HomeHeroMapper mapper;

    @Override
    public HomeHeroVo get(String lang) {
        HomeHero hero = mapper.selectOne(new LambdaQueryWrapper<HomeHero>().last("LIMIT 1"));
        if (hero == null) return null;
        return HomeHeroVo.from(hero, lang);
    }

    @Override
    public void update(HomeHero hero) {
        mapper.updateById(hero);
    }
}
