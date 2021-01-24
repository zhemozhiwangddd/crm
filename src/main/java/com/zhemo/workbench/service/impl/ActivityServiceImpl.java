package com.zhemo.workbench.service.impl;

import com.zhemo.domain.Msg;
import com.zhemo.settings.dao.UserMapper;
import com.zhemo.settings.domain.User;
import com.zhemo.workbench.dao.ActivityMapper;
import com.zhemo.workbench.dao.ActivityRemarkMapper;
import com.zhemo.workbench.domain.Activity;
import com.zhemo.workbench.domain.ActivityExample;
import com.zhemo.workbench.domain.ActivityRemark;
import com.zhemo.workbench.domain.ActivityRemarkExample;
import com.zhemo.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-20 17:16
 */
@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    ActivityMapper activityMapper;
    @Autowired
    ActivityRemarkMapper activityRemarkMapper;
    @Autowired
    UserMapper userMapper;

    @Override
    public int saveActivity(Activity activity) {
        return activityMapper.insertSelective(activity);
    }

    @Override
    public List<Activity> getActivities(Activity searchInfo) {
        return activityMapper.selectActivityWithUserByCondition(searchInfo);
    }

    @Override
    public boolean deleteAcitvityById(List<String> ids) {
        //删activity id对应的activity remark
        ActivityRemarkExample activityRemarkExample = new ActivityRemarkExample();
        ActivityRemarkExample.Criteria criteriaAR = activityRemarkExample.createCriteria();
        criteriaAR.andActivityIdIn(ids);
        long arNum = activityRemarkMapper.countByExample(activityRemarkExample);//本来要删除的条数
        int arDelNum = activityRemarkMapper.deleteByExample(activityRemarkExample);//实际删除的条数
        //删activity
        ActivityExample activityExample = new ActivityExample();
        ActivityExample.Criteria criteriaA = activityExample.createCriteria();
        criteriaA.andIdIn(ids);
        int aDelNum = activityMapper.deleteByExample(activityExample);//删除的activity数量
        return arNum == arDelNum && aDelNum == ids.size();
    }

    //获取修改模态框中的信息
    @Override
    public Map<String, Object> getActivityInfoById(String id) {
        List<User> users = userMapper.selectByExample(null);
        Activity activity = activityMapper.selectByPrimaryKey(id);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("users",users);
        map.put("activity",activity);
        return map;
    }

    //修改活动信息
    @Override
    public boolean updateActivityInfo(Activity activity) {
        return activityMapper.updateByPrimaryKeySelective(activity) == 1;
    }

    @Override
    public Activity getActivityDetailById(String id) {
        return activityMapper.selectActivityDetailByPrimaryKey(id);
    }

    //获取某个活动的备注信息
    @Override
    public List<ActivityRemark> getActivityRemarksByActId(String id) {
        ActivityRemarkExample activityRemarkExample = new ActivityRemarkExample();
        ActivityRemarkExample.Criteria criteria = activityRemarkExample.createCriteria();
        criteria.andActivityIdEqualTo(id);
        return activityRemarkMapper.selectByExample(activityRemarkExample);
    }

    @Override
    public boolean saveActivityRemark(ActivityRemark ar) {
        return activityRemarkMapper.insertSelective(ar) == 1;
    }

    @Override
    public boolean deleteActivityRemarkById(String id) {
        return activityRemarkMapper.deleteByPrimaryKey(id) == 1;
    }

    @Override
    public boolean updateActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.updateByPrimaryKeySelective(activityRemark) == 1;
    }
}
