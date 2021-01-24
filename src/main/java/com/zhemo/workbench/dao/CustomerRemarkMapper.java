package com.zhemo.workbench.dao;

import com.zhemo.workbench.domain.CustomerRemark;
import com.zhemo.workbench.domain.CustomerRemarkExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface CustomerRemarkMapper {
    long countByExample(CustomerRemarkExample example);

    int deleteByExample(CustomerRemarkExample example);

    int deleteByPrimaryKey(String id);

    int insert(CustomerRemark record);

    int insertSelective(CustomerRemark record);

    List<CustomerRemark> selectByExample(CustomerRemarkExample example);

    CustomerRemark selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") CustomerRemark record, @Param("example") CustomerRemarkExample example);

    int updateByExample(@Param("record") CustomerRemark record, @Param("example") CustomerRemarkExample example);

    int updateByPrimaryKeySelective(CustomerRemark record);

    int updateByPrimaryKey(CustomerRemark record);
}