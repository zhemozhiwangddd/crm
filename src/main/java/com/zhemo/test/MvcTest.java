package com.zhemo.test;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-18 20:37
 */
@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(value={"classpath:applicationContext.xml","classpath:dispatcherServlet.xml"})
public class MvcTest {

    //自动注入springmvc容器的上下文对象
    @Autowired
    WebApplicationContext context;

    private MockMvc mockMvc;

    //初始化
    @Before
    public void init(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void loginTest() throws Exception{
        MvcResult mvcResult = mockMvc.perform(MockMvcRequestBuilders.get("/settings/user/login")
                .param("loginPwd", "202cb962ac59075b964b07152d234b70")
                .param("name", "张三").param("ip","127.0.0.1")).andReturn();
        System.out.println(mvcResult.getRequest().getAttribute("msg"));
    }


}
