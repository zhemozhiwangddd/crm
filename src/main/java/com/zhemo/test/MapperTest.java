package com.zhemo.test;

import com.zhemo.settings.dao.DicTypeMapper;
import com.zhemo.settings.dao.UserMapper;
import com.zhemo.settings.domain.DicType;
import com.zhemo.settings.domain.User;
import com.zhemo.workbench.dao.ActivityMapper;
import com.zhemo.workbench.dao.ActivityRemarkMapper;
import com.zhemo.workbench.dao.ClueMapper;
import com.zhemo.workbench.domain.Activity;
import com.zhemo.workbench.domain.Clue;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestConstructor;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-18 22:12
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(value = "classpath:applicationContext.xml")
public class MapperTest {

    @Autowired
    UserMapper userMapper;

    @Autowired
    ActivityMapper activityMapper;

    @Autowired
    ActivityRemarkMapper activityRemarkMapper;

    @Autowired
    ClueMapper clueMapper;

    @Autowired
    DicTypeMapper dicTypeMapper;

    @Test
    public void selectTest(){
        User user = userMapper.selectByPrimaryKey("40f6cdea0bd34aceb77492a1656d9fb3");
        System.out.println(user);
    }

    @Test
    public void activityInsertTest(){

        Activity activity = new Activity();
        activity.setId("22");
        activityMapper.insert(activity);

    }

    @Test
    public void selectAllUserTest(){
        List<User> users = userMapper.selectByExample(null);
        for (User user : users) {
            System.out.println(user);
        }
    }

    @Test
    public void selectClueTest(){
        List<Clue> clues = clueMapper.selectByExample(null);
        for (Clue clue : clues) {
            System.out.println(clue);
        }
    }

    @Test
    public void selectDicTypeTest(){
        List<DicType> dicTypes = dicTypeMapper.selectByExample(null);
        for (DicType dicType : dicTypes) {
            System.out.println(dicType);
        }
    }

}
