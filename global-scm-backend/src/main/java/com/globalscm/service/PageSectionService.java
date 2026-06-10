package com.globalscm.service;

import com.globalscm.entity.pojo.PageSection;

import java.util.List;

public interface PageSectionService {

    List<PageSection> listByPage(String page, String lang);
}
