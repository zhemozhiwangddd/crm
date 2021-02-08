package com.zhemo.workbench.dao;

import com.zhemo.workbench.domain.Activity;
import com.zhemo.workbench.domain.ActivityExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ActivityMapper {
    long countByExample(ActivityExample example);

    int deleteByExample(ActivityExample example);

    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    int insertSelective(Activity record);

    List<Activity> selectByExample(ActivityExample example);

    List<Activity> selectActivityWithUserByCondition(Activity activity);

    Activity selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") Activity record, @Param("example") ActivityExample example);

    int updateByExample(@Param("record") Activity record, @Param("example") ActivityExample example);

    int updateByPrimaryKeySelective(Activity record);

    int updateByPrimaryKey(Activity record);

    Activity selectActivityDetailByPrimaryKey(String id);

    List<Activity> selectActivityByCId(String id);

    List<Activity> selectActivityByANameAndCId(@Param(value = "aName") String aName, @Param(value = "cId") String cId);

    List<Activity> selectActivityANameLike(String aName);
}