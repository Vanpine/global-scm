package com.globalscm.service;

import com.globalscm.entity.pojo.HomeSection;

import java.util.List;

public interface HomeSectionService {

    List<HomeSection> listAll(String lang);
}
