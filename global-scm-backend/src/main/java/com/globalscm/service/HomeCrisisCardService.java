package com.globalscm.service;

import com.globalscm.entity.vo.HomeCrisisCardVo;

import java.util.List;

public interface HomeCrisisCardService {

    List<HomeCrisisCardVo> listAll(String lang);
}
