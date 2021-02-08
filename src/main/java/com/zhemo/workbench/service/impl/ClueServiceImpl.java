package com.zhemo.workbench.service.impl;

import com.zhemo.settings.dao.UserMapper;
import com.zhemo.settings.domain.User;
import com.zhemo.utils.DateTimeUtil;
import com.zhemo.utils.UUIDUtil;
import com.zhemo.workbench.dao.*;
import com.zhemo.workbench.domain.*;
import com.zhemo.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-24 23:03
 */
@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    UserMapper userMapper;

    @Autowired
    ClueMapper clueMapper;

    @Autowired
    ActivityMapper activityMapper;

    @Autowired
    ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    CustomerMapper customerMapper;

    @Autowired
    ContactsMapper contactsMapper;

    @Autowired
    ClueRemarkMapper clueRemarkMapper;

    @Autowired
    TranMapper tranMapper;

    @Autowired
    TranHistoryMapper tranHistoryMapper;

    @Override
    public List<User> getOwnerList() {

        List<User> users = userMapper.selectByExample(null);
        return users;
    }

    @Override
    public boolean saveClue(Clue clue) {
        return clueMapper.insertSelective(clue) == 1;
    }

    @Override
    public Clue getDetailById(String id) {
        return clueMapper.selectDetailByPrimaryKey(id);
    }

    @Override
    public List<Activity> getActivityListByCId(String id) {
        return activityMapper.selectActivityByCId(id);
    }

    @Override
    public boolean releaseRelationById(String id) {
        return clueActivityRelationMapper.deleteByPrimaryKey(id) == 1;
    }

    @Override
    public List<Activity> searchActivityByANameAndCId(String aName, String cId) {
        return activityMapper.selectActivityByANameAndCId(aName, cId);
    }

    @Override
    public boolean buildRelationBetweenClueAndActivity(String clueId, String[] activityid) {
        ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
        for (String aId : activityid) {
            clueActivityRelation.setActivityid(aId);
            clueActivityRelation.setClueid(clueId);
            clueActivityRelation.setId(UUIDUtil.getUUID());
            if (clueActivityRelationMapper.insert(clueActivityRelation) != 1) {
                throw new RuntimeException("没保存上");
            }
        }
        return true;
    }

    @Override
    public List<Activity> searchActivityByName(String aName) {
        return activityMapper.selectActivityANameLike(aName);
    }

    @Override
    public boolean convert(String clueId, Tran tran, String user) {
        boolean flag = true;//判断程序是否出错
        //根据id获取clue的信息
        Clue clue = clueMapper.selectByPrimaryKey(clueId);
        if(clue == null){
            throw new RuntimeException("-2");
        }
        //添加一名客户，先判断是否已经存在该客户
        CustomerExample customerExample = new CustomerExample();
        CustomerExample.Criteria criteria = customerExample.createCriteria();
        criteria.andNameEqualTo(clue.getCompany());
        //若不存在，创建一个客户
        Customer customer = null;
        if (customerMapper.countByExample(customerExample) == 0) {
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setAddress(clue.getAddress());
            customer.setContactsummary(clue.getContactsummary());
            customer.setCreateby(user);
            customer.setCreatetime(DateTimeUtil.getSysTime());
            customer.setDescription(clue.getDescription());
            customer.setName(clue.getCompany());
            customer.setNextcontacttime(clue.getNextcontacttime());
            customer.setOwner(clue.getOwner());
            customer.setPhone(clue.getPhone());
            customer.setWebsite(clue.getWebsite());
            if (customerMapper.insertSelective(customer) != 1) {
                throw new RuntimeException("-1");
                // flag = false;
            }
        }

        //保存联系人
        Contacts contacts = new Contacts();
        contacts.setAddress(clue.getAddress());
        contacts.setAppellation(clue.getAppellation());
        contacts.setContactsummary(clue.getContactsummary());
        contacts.setCreateby(user);
        contacts.setCreatetime(DateTimeUtil.getSysTime());
        contacts.setCustomerid(customer.getId());
        contacts.setDescription(clue.getDescription());
        contacts.setEmail(clue.getEmail());
        contacts.setFullname(clue.getFullname());
        contacts.setId(UUIDUtil.getUUID());
        contacts.setJob(clue.getJob());
        contacts.setMphone(clue.getMphone());
        contacts.setNextcontacttime(clue.getNextcontacttime());
        contacts.setOwner(clue.getOwner());
        contacts.setSource(clue.getSource());
        if (contactsMapper.insertSelective(contacts) != 1) {
            throw new RuntimeException("0");
            // flag = false;
        }

        //线索备注转换到客户备注以及联系人备注
        ClueRemarkExample clueRemarkExample = new ClueRemarkExample();
        ClueRemarkExample.Criteria criteria1 = clueRemarkExample.createCriteria();
        criteria1.andClueidEqualTo(clueId);
        List<ClueRemark> clueRemarks = clueRemarkMapper.selectByExample(clueRemarkExample);
        CustomerRemark customerRemark = new CustomerRemark();
        ContactsRemark contactsRemark = new ContactsRemark();
        for (ClueRemark clueRemark : clueRemarks) {

            customerRemark.setCreateby(user);
            customerRemark.setCreatetime(DateTimeUtil.getSysTime());
            customerRemark.setCustomerid(customer.getId());
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setEditflag("0");
            customerRemark.setNotecontent(clueRemark.getNotecontent());
            if (customerRemarkMapper.insertSelective(customerRemark) != 1) {
                throw new RuntimeException("1");
                // flag = false;
            }

            contactsRemark.setContactsid(contacts.getId());
            contactsRemark.setCreateby(user);
            contactsRemark.setCreatetime(DateTimeUtil.getSysTime());
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNotecontent(clueRemark.getNotecontent());
            contactsRemark.setEditflag("0");
            if (contactsRemarkMapper.insertSelective(contactsRemark) != 1) {
                throw new RuntimeException("2");
                // flag = false;
            }
        }

        //“线索和市场活动”的关系转换到“联系人和市场活动”的关系
        ClueActivityRelationExample clueActivityRelationExample = new ClueActivityRelationExample();
        ClueActivityRelationExample.Criteria criteria2 = clueActivityRelationExample.createCriteria();
        criteria2.andClueidEqualTo(clueId);
        List<ClueActivityRelation> clueActivityRelations = clueActivityRelationMapper.selectByExample(clueActivityRelationExample);
        ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
        for (ClueActivityRelation clueActivityRelation : clueActivityRelations) {
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityid(clueActivityRelation.getActivityid());
            contactsActivityRelation.setContactsid(contacts.getId());
            if (contactsActivityRelationMapper.insertSelective(contactsActivityRelation) != 1) {
                throw new RuntimeException("3");
                // flag = false;
            }
        }

        //如果有交易创建交易
        if (tran != null) {
            tran.setContactsid(contacts.getId());
            tran.setCustomerid(customer.getId());
            tran.setNextcontacttime(contacts.getNextcontacttime());
            tran.setOwner(contacts.getOwner());
            tran.setSource(contacts.getSource());
            tran.setDescription(contacts.getDescription());
            tran.setContactsummary(customer.getContactsummary());
            if (tranMapper.insertSelective(tran) != 1) {
                throw new RuntimeException("4");
                // flag = false;
            }

            //创建交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setCreateby(user);
            tranHistory.setCreatetime(DateTimeUtil.getSysTime());
            tranHistory.setExpecteddate(tran.getExpecteddate());
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setStage(tran.getStage());
            tranHistory.setTranid(tran.getId());
            if (tranHistoryMapper.insertSelective(tranHistory) != 1) {
                throw new RuntimeException("5");
                // flag = false;
            }
        }



        //删除线索，线索活动关系，线索备注
        long count;
        count = clueRemarkMapper.countByExample(clueRemarkExample);
        if (clueRemarkMapper.deleteByExample(clueRemarkExample) != count)
            throw new RuntimeException("6");
        // flag = false;

        count = clueActivityRelationMapper.countByExample(clueActivityRelationExample);
        if (clueActivityRelationMapper.deleteByExample(clueActivityRelationExample) != count)
            throw new RuntimeException("7");
        // flag = false;

        if (clueMapper.deleteByPrimaryKey(clue.getId()) != 1)
            throw new RuntimeException("8");
        // flag = false;

        System.out.println(flag);
        return flag;


    }
}
