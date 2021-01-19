package com.zhemo.settings.test;

import com.zhemo.settings.dao.UserMapper;
import com.zhemo.settings.domain.User;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-18 22:12
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(value = "classpath:applicationContext.xml")
public class MapperTest {

    @Autowired
    UserMapper userMapper;

    @Test
    public void selectTest(){
        User user = userMapper.selectByPrimaryKey("40f6cdea0bd34aceb77492a1656d9fb3");
        System.out.println(user);
    }

}
