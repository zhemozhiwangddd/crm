package com.zhemo.workbench.service;

import com.zhemo.settings.domain.User;
import com.zhemo.workbench.domain.*;

import java.util.List;
import java.util.Map;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-28 12:54
 */
public interface TranService {
    List<User> selectOwner();

    List<Activity> selectActivityByNameLike(String name);

    List<Contacts> selectContactsByNameLike(String name);

    List<Customer> selectCustomerByNameLike(String name);

    boolean saveTran(Tran tran);

    Tran getDetailById(String id);

    List<TranHistory> getTranHistoryByTranId(String tranId);

    boolean updateDetailWebsite(Tran tran);

    Map<String, Object> getTranChartData();
}
