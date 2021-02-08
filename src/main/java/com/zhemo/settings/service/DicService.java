package com.zhemo.settings.service;

import com.zhemo.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-24 23:00
 */
public interface DicService {

    Map<String, List<DicValue>> getDataDic();

}
