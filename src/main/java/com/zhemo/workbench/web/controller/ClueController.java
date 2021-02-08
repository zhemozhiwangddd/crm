package com.zhemo.workbench.web.controller;

import com.zhemo.domain.Msg;
import com.zhemo.settings.domain.User;
import com.zhemo.utils.DateTimeUtil;
import com.zhemo.utils.UUIDUtil;
import com.zhemo.workbench.domain.Activity;
import com.zhemo.workbench.domain.Clue;
import com.zhemo.workbench.domain.Tran;
import com.zhemo.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.List;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-24 23:01
 */
@Controller
@RequestMapping("/workbench/clue")
public class ClueController {

    @Autowired
    ClueService clueService;

    @RequestMapping(value = "/ownerList", method = RequestMethod.GET)
    @ResponseBody
    public List<User> getOwnerList() {
        List<User> ownerList = clueService.getOwnerList();
        return ownerList;
    }

    @RequestMapping(value = "/save", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveClue(Clue clue, HttpServletRequest req) {
        User loginUser = (User) req.getSession().getAttribute("loginUser");
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateby(loginUser.getName());
        clue.setCreatetime(DateTimeUtil.getSysTime());
        if (clueService.saveClue(clue)) {
            return Msg.success().setStatus("线索创建成功");
        }
        return Msg.success().setStatus("线索创建失败");
    }

    @RequestMapping(value = "/detail", method = RequestMethod.GET)
    public ModelAndView getDetail(String id) {
        ModelAndView mv = new ModelAndView();
        mv.addObject("detail", clueService.getDetailById(id));
        mv.setViewName("/clue/detail");
        return mv;

    }

    @RequestMapping(value = "/detail/activity", method = RequestMethod.GET)
    @ResponseBody
    public Msg getActivityListByCId(String id) {
        return Msg.success().addObject("activityList", clueService.getActivityListByCId(id));
    }

    @RequestMapping(value = "/detail/activity", method = RequestMethod.DELETE)
    @ResponseBody
    public Msg releaseRelationById(String id) {
        if (clueService.releaseRelationById(id)) {
            return Msg.success().setStatus("解除关联成功");
        }
        return Msg.fail().setStatus("解除关联失败");
    }

    @RequestMapping(value = "/detail/searchActivity", method = RequestMethod.GET)
    @ResponseBody
    public Msg searchActivityByANameAndCId(@RequestParam(defaultValue = "") String aName, String cId) {
        List<Activity> activityList = clueService.searchActivityByANameAndCId(aName, cId);
        return Msg.success().addObject("activityList", activityList);
    }

    //关联线索和活动
    @RequestMapping(value = "/detail/relation", method = RequestMethod.POST)
    @ResponseBody
    public Msg buildRelationBetweenClueAndActivity(String clueId, String[] activityid) {
        System.out.println(clueId);
        System.out.println(Arrays.toString(activityid));
        if (clueService.buildRelationBetweenClueAndActivity(clueId, activityid)) {
            return Msg.success().setStatus("关联成功");
        }
        return Msg.fail().setStatus("关联失败");

    }

    //线索转换过程中对时长活动源的模糊查询
    @RequestMapping(value = "/detail/convert", method = RequestMethod.GET)
    @ResponseBody
    public Msg searchActivityByName(@RequestParam(defaultValue = "") String aName) {
        return Msg.success().addObject("activityList", clueService.searchActivityByName(aName));
    }

    @RequestMapping(value = "/detail/convert", method = RequestMethod.POST)
    public String convert(String clueId, String flag, Tran tran, HttpServletRequest req) {

        User loginUser = (User) req.getSession().getAttribute("loginUser");
        String user = loginUser.getName();
        //需要创建交易
        if("true".equals(flag)) {
            tran.setCreateby(user);
            tran.setCreatetime(DateTimeUtil.getSysTime());
            tran.setId(UUIDUtil.getUUID());
            //不需要创建交易
        }else{
            tran = null;
        }
        if (clueService.convert(clueId, tran, user)) {
            return "redirect:/workbench/clue/index.jsp";
        }
        return null;
    }
}
