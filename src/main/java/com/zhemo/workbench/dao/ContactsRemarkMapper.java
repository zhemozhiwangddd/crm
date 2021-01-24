package com.zhemo.workbench.dao;

import com.zhemo.workbench.domain.ContactsRemark;
import com.zhemo.workbench.domain.ContactsRemarkExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ContactsRemarkMapper {
    long countByExample(ContactsRemarkExample example);

    int deleteByExample(ContactsRemarkExample example);

    int deleteByPrimaryKey(String id);

    int insert(ContactsRemark record);

    int insertSelective(ContactsRemark record);

    List<ContactsRemark> selectByExample(ContactsRemarkExample example);

    ContactsRemark selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") ContactsRemark record, @Param("example") ContactsRemarkExample example);

    int updateByExample(@Param("record") ContactsRemark record, @Param("example") ContactsRemarkExample example);

    int updateByPrimaryKeySelective(ContactsRemark record);

    int updateByPrimaryKey(ContactsRemark record);
}