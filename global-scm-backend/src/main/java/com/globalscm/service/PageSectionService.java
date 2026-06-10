package com.globalscm.service;

import com.globalscm.entity.vo.PageSectionVo;

import java.util.List;

public interface PageSectionService {

    List<PageSectionVo> listByPage(String page, String lang);
}
