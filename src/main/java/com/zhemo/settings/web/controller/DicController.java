package com.zhemo.settings.web.controller;

import com.zhemo.settings.service.DicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-24 22:59
 */
@Controller
@RequestMapping("/settings/dic")
public class DicController {

    @Autowired
    DicService dicService;


}
