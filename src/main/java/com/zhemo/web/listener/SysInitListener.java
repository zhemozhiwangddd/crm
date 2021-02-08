package com.zhemo.web.listener;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.zhemo.settings.domain.DicValue;
import com.zhemo.settings.service.DicService;
import com.zhemo.settings.service.impl.DicServiceImpl;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-24 23:42
 */
public class SysInitListener implements ServletContextListener {


    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        ServletContext application = servletContextEvent.getServletContext();
        DicService dicService = WebApplicationContextUtils.getWebApplicationContext(application).getBean(DicService.class);
        //获取数据字典放到工程域中
        Map<String, List<DicValue>> dicMap = dicService.getDataDic();
        //遍历将数据字典对应存到全局域中
        for (String key : dicMap.keySet()) {
            application.setAttribute(key,dicMap.get(key));
        }
        //-----------------------------------------------------------------------------
        //获取属性文件中的key和value存放到application域中(用String)
        Map<String,String> possMap = new HashMap<String,String>();
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> keys = rb.getKeys();
        while(keys.hasMoreElements()){
            String key = keys.nextElement();
            possMap.put(key,rb.getString(key));
        }
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            String possJSON = objectMapper.writeValueAsString(possMap);
            application.setAttribute("possJSON",possJSON);
            application.setAttribute("possMap", possMap);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }

    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {

    }
}
