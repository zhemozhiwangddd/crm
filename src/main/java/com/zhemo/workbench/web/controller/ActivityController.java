package com.zhemo.workbench.web.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zhemo.domain.Msg;
import com.zhemo.settings.domain.User;
import com.zhemo.settings.service.UserService;
import com.zhemo.utils.DateTimeUtil;
import com.zhemo.utils.UUIDUtil;
import com.zhemo.workbench.domain.Activity;
import com.zhemo.workbench.domain.ActivityRemark;
import com.zhemo.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.Cache;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-20 17:17
 */
@Controller
@RequestMapping("/workbench")
public class ActivityController {

    @Autowired
    UserService userService;

    @Autowired
    ActivityService activityService;

    @RequestMapping(value = "/activity/users", method = RequestMethod.GET)
    @ResponseBody
    public List<User> getAllUsers(){
        List<User> users = userService.getAllUsers();
        return users;
    }

    @RequestMapping(value = "/activity", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveActivity(Activity activity, HttpServletRequest req){

        String createTime = DateTimeUtil.getSysTime();
        String uuid = UUIDUtil.getUUID();
        User loginUser = (User) req.getSession().getAttribute("loginUser");
        String createBy = loginUser.getName();
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);
        activity.setId(uuid);
        if(activityService.saveActivity(activity) == 0){
            return Msg.fail().setStatus("市场活动创建失败");
        }
        return Msg.success().setStatus("市场活动创建成功");
    }

    //活动列表的分页
    @RequestMapping(value = "/activity/page", method = RequestMethod.GET)
    @ResponseBody
    public Msg pageActivities(@RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum
            ,@RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize, Activity searchInfo){
        PageHelper.startPage(pageNum,pageSize);
        List<Activity> actList = activityService.getActivities(searchInfo);
        PageInfo pageInfo = new PageInfo(actList, 5);
        Msg msg = Msg.success().addObject("pageInfo", pageInfo);
        return msg;
    }

    //删除checkbox选中的活动
    @RequestMapping(value="/activity", method=RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteActivityById(String[] id){
        List<String> ids = Arrays.asList(id);
        if(activityService.deleteAcitvityById(ids)){
            return Msg.success().setStatus("删除成功");
        }
        return Msg.fail().setStatus("删除失败");
    }

    //修改界面的信息
    @RequestMapping(value = "/activity/edit", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> editModalInfo(String id){
        Map<String, Object> map = activityService.getActivityInfoById(id);
        return map;
    }

    //更新信息
    @RequestMapping(value = "/activity", method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateActivityInfo(Activity activity, HttpServletRequest req){
        User loginUser = (User) req.getSession().getAttribute("loginUser");
        activity.setEditBy(loginUser.getName());
        activity.setEditTime(DateTimeUtil.getSysTime());
        boolean flag = activityService.updateActivityInfo(activity);

        if(flag){
            return Msg.success().setStatus("修改成功");
        }
        return Msg.fail().setStatus("修改失败");
    }

    //点了链接以后跳转到活动详情页面，并展示点击的活动对应的活动详情
    @RequestMapping(value = "/activity/detail", method = RequestMethod.GET)
    public ModelAndView getDetailById(String id){
        Activity activity = activityService.getActivityDetailById(id);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("activity", activity);
        modelAndView.setViewName("activity/detail");
        return modelAndView;
    }

    //aid对应的获取备注列表
    @RequestMapping(value = "/activity/remark", method = RequestMethod.GET)
    @ResponseBody
    public Msg getActivityRemarksByActId(String aId){
        List<ActivityRemark> ars = activityService.getActivityRemarksByActId(aId);
        return Msg.success().addObject("ars",ars);
    }

    @RequestMapping(value = "/activity/remark", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveActivityRemark(String noteContent,String aId, HttpServletRequest req){
        ActivityRemark ar = new ActivityRemark();
        User loginUser = (User) req.getSession().getAttribute("loginUser");
        ar.setId(UUIDUtil.getUUID());
        ar.setNoteContent(noteContent);
        ar.setCreateTime(DateTimeUtil.getSysTime());
        ar.setCreateBy(loginUser.getName());
        ar.setEditFlag("0");
        ar.setActivityId(aId);
        if(activityService.saveActivityRemark(ar)){
            return Msg.success().addObject("ar",ar).setStatus("备注添加成功");
        }
        return Msg.fail().setStatus("备注添加失败");
    }

    //删除备注
    @RequestMapping(value = "/activity/remark", method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteRemark(String id){
         if(activityService.deleteActivityRemarkById(id)){
             return Msg.success().setStatus("删除成功");
         }
         return Msg.fail().setStatus("删除失败");
    }

    //更新备注
    @RequestMapping(value = "/activity/remark", method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateRemark(String id, String noteContent, HttpServletRequest req){
        ActivityRemark ar = new ActivityRemark();
        User loginUser = (User) req.getSession().getAttribute("loginUser");
        ar.setId(id);
        ar.setNoteContent(noteContent);
        ar.setEditTime(DateTimeUtil.getSysTime());
        ar.setEditBy(loginUser.getName());
        ar.setEditFlag("1");
        if(activityService.updateActivityRemark(ar)){
            return Msg.success().setStatus("更新成功").addObject("ar",ar);
        }
        return Msg.fail().setStatus("更新失败");
    }
}
