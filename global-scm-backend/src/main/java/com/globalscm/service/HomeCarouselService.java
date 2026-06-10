package com.globalscm.service;

import com.globalscm.entity.vo.HomeCarouselVo;

import java.util.List;

public interface HomeCarouselService {

    List<HomeCarouselVo> listAll(String lang);
}
