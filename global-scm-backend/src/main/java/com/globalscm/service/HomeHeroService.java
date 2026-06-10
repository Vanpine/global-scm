package com.globalscm.service;

import com.globalscm.entity.pojo.HomeHero;

public interface HomeHeroService {

    HomeHero get(String lang);

    void update(HomeHero hero);
}
