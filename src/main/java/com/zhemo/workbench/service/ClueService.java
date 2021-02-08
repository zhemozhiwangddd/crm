package com.zhemo.workbench.service;

import com.zhemo.settings.domain.User;
import com.zhemo.workbench.domain.Activity;
import com.zhemo.workbench.domain.Clue;
import com.zhemo.workbench.domain.Tran;

import java.util.List;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-24 23:03
 */
public interface ClueService {

    List<User> getOwnerList();

    boolean saveClue(Clue clue);

    Clue getDetailById(String id);

    List<Activity> getActivityListByCId(String id);

    boolean releaseRelationById(String id);

    List<Activity> searchActivityByANameAndCId(String aName, String cId);

    boolean buildRelationBetweenClueAndActivity(String clueId, String[] activityid);

    List<Activity> searchActivityByName(String aName);

    boolean convert(String clueId, Tran tran, String user);
}
