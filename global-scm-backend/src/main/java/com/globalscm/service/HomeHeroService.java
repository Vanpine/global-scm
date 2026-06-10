package com.globalscm.service;

import com.globalscm.entity.pojo.HomeHero;
import com.globalscm.entity.vo.HomeHeroVo;

public interface HomeHeroService {

    HomeHeroVo get(String lang);

    void update(HomeHero hero);
}
