package com.globalscm.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.globalscm.entity.pojo.HomeCrisisCard;
import org.apache.ibatis.annotations.Mapper;

/**
 * 首页危机卡片 Mapper
 * 对应表 home_crisis_cards —— 六大全球供应链危机类型（贸易政策/地缘政治/物流瓶颈/需求风险/供应风险/网络安全）
 */
@Mapper
public interface HomeCrisisCardMapper extends BaseMapper<HomeCrisisCard> {
}
