package com.zhemo.settings.service.impl;

import com.zhemo.settings.dao.UserMapper;
import com.zhemo.settings.domain.User;
import com.zhemo.settings.domain.UserExample;
import com.zhemo.settings.service.UserService;
import com.zhemo.utils.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zhemo.exception.LoginException;

import java.util.List;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-18 20:58
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    UserMapper userMapper;

    //处理登录逻辑的service方法
    @Override
    public User login(String name, String loginPwd, String ip) throws LoginException{
        UserExample userExample = new UserExample();
        UserExample.Criteria criteria = userExample.createCriteria();
        criteria.andNameEqualTo(name).andLoginPwdEqualTo(loginPwd);
        List<User> users = userMapper.selectByExample(userExample);
        //若没有找到用户，抛出没找到用户的异常
        if(users == null || users.isEmpty()){
            throw new LoginException("用户名或密码错误");
        }
        User user = users.get(0);
        if("0".equals(user.getLockState())){
            throw new LoginException("该用户已被锁定，无法登录");
        }
        if(DateTimeUtil.getSysTime().compareTo(user.getExpireTime()) > 0){
            throw new LoginException("该用户已过期");
        }
        if(!user.getAllowIps().contains(ip)){
            throw new LoginException("该ip地址不可用");
        }
        return user;
    }

    @Override
    public List<User> getAllUsers() {
        return userMapper.selectByExample(null);
    }
}
