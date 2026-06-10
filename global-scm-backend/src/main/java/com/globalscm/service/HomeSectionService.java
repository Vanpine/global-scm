package com.globalscm.service;

import com.globalscm.entity.vo.HomeSectionVo;

import java.util.List;

public interface HomeSectionService {

    List<HomeSectionVo> listAll(String lang);
}
