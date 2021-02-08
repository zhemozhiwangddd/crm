package com.zhemo.workbench.dao;

import com.zhemo.workbench.domain.Tran;
import com.zhemo.workbench.domain.TranExample;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface TranMapper {
    long countByExample(TranExample example);

    int deleteByExample(TranExample example);

    int deleteByPrimaryKey(String id);

    int insert(Tran record);

    int insertSelective(Tran record);

    List<Tran> selectByExample(TranExample example);

    Tran selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") Tran record, @Param("example") TranExample example);

    int updateByExample(@Param("record") Tran record, @Param("example") TranExample example);

    int updateByPrimaryKeySelective(Tran record);

    int updateByPrimaryKey(Tran record);

    Tran selectDetailByPrimaryKey(String id);

    List<Map<String, Object>> selectCountGroupByStageName();
}