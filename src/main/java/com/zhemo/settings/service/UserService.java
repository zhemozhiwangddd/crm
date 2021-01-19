package com.zhemo.settings.service;

import com.zhemo.exception.LoginException;
import com.zhemo.settings.domain.User;

import java.util.List;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-18 20:58
 */
public interface UserService {
    User login(String name, String loginPwd, String ip) throws LoginException;
}
