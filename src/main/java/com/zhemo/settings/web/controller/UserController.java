package com.zhemo.settings.web.controller;

import com.zhemo.domain.Msg;
import com.zhemo.exception.LoginException;
import com.zhemo.settings.domain.User;
import com.zhemo.settings.service.UserService;
import com.zhemo.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-18 20:52
 */
@Controller
@RequestMapping("/settings/user")
public class UserController {

    @Autowired
    UserService userService;

    //处理登录逻辑的控制器方法
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    @ResponseBody
    public Msg login(String name, String loginPwd, HttpServletRequest req, HttpServletResponse resp) throws LoginException, IOException {
        loginPwd = MD5Util.getMD5(loginPwd);
        String ip = req.getRemoteAddr();
        System.out.println(ip);
        //如果出现异常，转到处理异常的方法中
        User loginUser = userService.login(name, loginPwd, ip);
        //存到session域中
        req.getSession().setAttribute("loginUser",loginUser);
        return Msg.success();
    }

}
