package com.globalscm.service;

import com.globalscm.entity.pojo.PageSection;

import java.util.List;

/**
 * 页面区块业务接口
 * 管理 6 个页面的所有区块内容（products / solutions / why-us / intel / contact / pain-points）
 */
public interface PageSectionService {

    /**
     * 根据页面标识获取该页面所有区块，按 sort_order 升序排列
     *
     * @param page 页面标识：products | solutions | why-us | intel | contact | pain-points
     * @return 该页面下所有区块列表
     */
    List<PageSection> listByPage(String page);
}
