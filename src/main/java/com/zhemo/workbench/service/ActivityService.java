package com.zhemo.workbench.service;

import com.zhemo.domain.Msg;
import com.zhemo.workbench.domain.Activity;
import com.zhemo.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-20 17:16
 */

public interface ActivityService {


    int saveActivity(Activity activity);

    List<Activity> getActivities(Activity searchInfo);

    boolean deleteAcitvityById(List<String> ids);

    Map<String, Object> getActivityInfoById(String id);

    boolean updateActivityInfo(Activity activity);

    Activity getActivityDetailById(String id);

    List<ActivityRemark> getActivityRemarksByActId(String id);

    boolean saveActivityRemark(ActivityRemark ar);

    boolean deleteActivityRemarkById(String id);

    boolean updateActivityRemark(ActivityRemark activityRemark);
}
