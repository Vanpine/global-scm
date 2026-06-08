package com.globalscm.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.globalscm.entity.pojo.PageSection;
import org.apache.ibatis.annotations.Mapper;

/**
 * 页面区块 Mapper
 * 对应表 page_sections —— 6 个页面的所有区块内容
 * 唯一键：uk_page_section_sort (page, section, sort_order)
 */
@Mapper
public interface PageSectionMapper extends BaseMapper<PageSection> {
}
