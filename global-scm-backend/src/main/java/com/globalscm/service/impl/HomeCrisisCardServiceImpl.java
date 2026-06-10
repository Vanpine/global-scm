package com.globalscm.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.globalscm.entity.pojo.HomeCrisisCard;
import com.globalscm.entity.vo.HomeCrisisCardVo;
import com.globalscm.mapper.HomeCrisisCardMapper;
import com.globalscm.service.HomeCrisisCardService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class HomeCrisisCardServiceImpl implements HomeCrisisCardService {

    private final HomeCrisisCardMapper mapper;

    @Override
    public List<HomeCrisisCardVo> listAll(String lang) {
        List<HomeCrisisCard> list = mapper.selectList(
            new LambdaQueryWrapper<HomeCrisisCard>().orderByAsc(HomeCrisisCard::getSortOrder)
        );
        return list.stream().map(e -> HomeCrisisCardVo.from(e, lang)).toList();
    }
}
