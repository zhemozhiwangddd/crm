package com.zhemo.workbench.service.impl;

import com.zhemo.settings.dao.UserMapper;
import com.zhemo.settings.domain.User;
import com.zhemo.settings.domain.UserExample;
import com.zhemo.utils.DateTimeUtil;
import com.zhemo.utils.UUIDUtil;
import com.zhemo.workbench.dao.*;
import com.zhemo.workbench.domain.*;
import com.zhemo.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-28 12:54
 */
@Service
public class TranServiceImpl implements TranService {
    @Autowired
    TranMapper tranMapper;

    @Autowired
    UserMapper userMapper;

    @Autowired
    ActivityMapper activityMapper;
    @Autowired
    ContactsMapper contactsMapper;

    @Autowired
    CustomerMapper customerMapper;

    @Autowired
    TranHistoryMapper tranHistoryMapper;

    @Override
    public List<User> selectOwner() {
        return userMapper.selectByExample(null);
    }

    @Override
    public List<Activity> selectActivityByNameLike(String name) {
        return activityMapper.selectActivityANameLike(name);
    }

    @Override
    public List<Contacts> selectContactsByNameLike(String name) {
        ContactsExample contactsExample = new ContactsExample();
        ContactsExample.Criteria criteria = contactsExample.createCriteria();
        criteria.andFullnameLike("%" + name + "%");
        return contactsMapper.selectByExample(contactsExample);
    }

    @Override
    public List<Customer> selectCustomerByNameLike(String name) {
        CustomerExample customerExample = new CustomerExample();
        CustomerExample.Criteria criteria = customerExample.createCriteria();
        criteria.andNameLike(name + "%");
        return customerMapper.selectByExample(customerExample);
    }

    @Override
    public boolean saveTran(Tran tran) {
        //1.判断是否存在该顾客，如果不存在创建一个
        CustomerExample customerExample = new CustomerExample();
        CustomerExample.Criteria criteria = customerExample.createCriteria();
        criteria.andNameEqualTo(tran.getCustomerid());
        List<Customer> customers = customerMapper.selectByExample(customerExample);
        Customer customer = null;
        if (customers.size() == 0) {

            customer = new Customer();
            customer.setOwner(tran.getOwner());
            customer.setNextcontacttime(tran.getNextcontacttime());
            customer.setName(tran.getCustomerid());
            customer.setCreatetime(DateTimeUtil.getSysTime());
            customer.setCreateby(tran.getCreateby());
            customer.setId(UUIDUtil.getUUID());
            customer.setContactsummary(tran.getContactsummary());

            if (customerMapper.insertSelective(customer) != 1) {
                throw new RuntimeException();
            }

        } else {
            customer = customers.get(0);
        }
        //2.提交表单
        tran.setCustomerid(customer.getId());
        if (tranMapper.insertSelective(tran) != 1) {
            throw new RuntimeException();
        }

        //3.生成一个交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranid(tran.getId());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpecteddate(tran.getExpecteddate());
        tranHistory.setCreatetime(DateTimeUtil.getSysTime());
        tranHistory.setCreateby(tran.getCreateby());
        if (tranHistoryMapper.insertSelective(tranHistory) != 1) {
            throw new RuntimeException();
        }
        return true;
    }

    @Override
    public Tran getDetailById(String id) {
        return tranMapper.selectDetailByPrimaryKey(id);
    }

    @Override
    public List<TranHistory> getTranHistoryByTranId(String tranId) {
        TranHistoryExample tranHistoryExample = new TranHistoryExample();
        TranHistoryExample.Criteria criteria = tranHistoryExample.createCriteria();
        criteria.andTranidEqualTo(tranId);
        tranHistoryExample.setOrderByClause("createTime");
        List<TranHistory> tranHistories = tranHistoryMapper.selectByExample(tranHistoryExample);
        return tranHistories;
    }

    @Override
    public boolean updateDetailWebsite(Tran tran) {
        boolean flag = true;
        //更新交易
        if(tranMapper.updateByPrimaryKeySelective(tran) != 1){
            flag = false;
            throw new RuntimeException();
        }
        //添加交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setCreateby(tran.getEditby());
        tranHistory.setCreatetime(DateTimeUtil.getSysTime());
        tranHistory.setExpecteddate(tran.getExpecteddate());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranid(tran.getId());
        if(tranHistoryMapper.insertSelective(tranHistory) != 1){
            flag = false;
            throw new RuntimeException();
        }
        return flag;
    }

    @Override
    public Map<String, Object> getTranChartData() {

        //数据总量
        Map<String, Object> dataList = new HashMap<String, Object>();
        long total = tranMapper.countByExample(null);
        dataList.put("total",total);

        List<Map<String,Object>> stageCount =  tranMapper.selectCountGroupByStageName();
        dataList.put("stageCount",stageCount);

        return dataList;
    }
}
