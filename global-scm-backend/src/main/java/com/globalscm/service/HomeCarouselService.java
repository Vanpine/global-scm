package com.globalscm.service;

import com.globalscm.entity.pojo.HomeCarousel;

import java.util.List;

public interface HomeCarouselService {

    List<HomeCarousel> listAll(String lang);
}
