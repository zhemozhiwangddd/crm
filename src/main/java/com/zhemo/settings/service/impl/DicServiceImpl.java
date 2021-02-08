package com.zhemo.settings.service.impl;

import com.zhemo.settings.dao.DicTypeMapper;
import com.zhemo.settings.dao.DicValueMapper;
import com.zhemo.settings.domain.DicType;
import com.zhemo.settings.domain.DicValue;
import com.zhemo.settings.domain.DicValueExample;
import com.zhemo.settings.service.DicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-24 23:00
 */
@Service
public class DicServiceImpl implements DicService {

    @Autowired
    DicValueMapper dicValueMapper;

    @Autowired
    DicTypeMapper dicTypeMapper;

    @Override
    public Map<String, List<DicValue>> getDataDic() {

        List<DicType> dicTypes = dicTypeMapper.selectByExample(null);
        Map<String, List<DicValue>> dicMap = new HashMap<>();
        for (DicType dicType : dicTypes) {
            DicValueExample dicValueExample = new DicValueExample();
            DicValueExample.Criteria criteria = dicValueExample.createCriteria();
            criteria.andTypecodeEqualTo(dicType.getCode());
            dicValueExample.setOrderByClause("orderNo");
            List<DicValue> dicValues = dicValueMapper.selectByExample(dicValueExample);
            dicMap.put(dicType.getCode(),dicValues);
        }
        return dicMap;
    }
}
