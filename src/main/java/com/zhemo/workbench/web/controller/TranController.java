package com.zhemo.workbench.web.controller;

import com.zhemo.domain.Msg;
import com.zhemo.settings.domain.DicValue;
import com.zhemo.settings.domain.User;
import com.zhemo.utils.DateTimeUtil;
import com.zhemo.utils.UUIDUtil;
import com.zhemo.workbench.domain.*;
import com.zhemo.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.HttpRequestHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-28 12:53
 */
@RequestMapping(value = "/workbench/transaction")
@Controller
public class TranController {

    @Autowired
    TranService tranService;

    @RequestMapping(value = "/save", method = RequestMethod.GET)
    public ModelAndView selectOwner() {

        ModelAndView mv = new ModelAndView();
        mv.addObject("userList", tranService.selectOwner());
        mv.setViewName("transaction/save");
        return mv;

    }

    //活动模糊查询(根据name)
    @RequestMapping(value = "/activity/search", method = RequestMethod.GET)
    @ResponseBody
    public List<Activity> searchActivityByName(String name){
        return tranService.selectActivityByNameLike(name);
    }

    //联系人模糊查询(根据fullname)
    @RequestMapping(value = "/contacts/search", method = RequestMethod.GET)
    @ResponseBody
    public List<Contacts> searchContactsByName(String name){
        return tranService.selectContactsByNameLike(name);
    }

    @RequestMapping(value = "/customer/search", method = RequestMethod.GET)
    @ResponseBody
    public List<Customer> searchCustomerByName(String name){
        return tranService.selectCustomerByNameLike(name);
    }

    //保存交易表单
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    public String saveTran(Tran tran, HttpServletRequest req){
        User loginUser = (User) req.getSession().getAttribute("loginUser");
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateby(loginUser.getName());
        tran.setCreatetime(DateTimeUtil.getSysTime());
        if(tranService.saveTran(tran)){
            System.out.println("成功");
        }

        return "redirect:/workbench/transaction/index.jsp";
    }

    //根据id查询交易详情返回到detail.jsp页面显示
    @RequestMapping(value = "/detail", method = RequestMethod.GET)
    public ModelAndView getDetailById(String id, HttpServletRequest req){

        ModelAndView mv = new ModelAndView();
        Tran tran = tranService.getDetailById(id);
        //把可能性也加上
        ServletContext servletContext = req.getServletContext();
        Map<String, String> possMap = (Map<String, String>) servletContext.getAttribute("possMap");
        tran.setPossibility(possMap.get(tran.getStage()));
        mv.addObject("t",tran);
        mv.setViewName("/transaction/detail");
        return mv;
    }

    //查询某交易对应的交易历史
    @RequestMapping(value = "/detail/tranHistory", method = RequestMethod.GET)
    @ResponseBody
    public List<TranHistory> getTranHistoryByTranId(String tranId,HttpServletRequest req){
        Map<String, String> possMap = (Map<String, String>)req.getServletContext().getAttribute("possMap");
        List<TranHistory> ths = tranService.getTranHistoryByTranId(tranId);
        for (TranHistory th : ths) {
            th.setPossibility(possMap.get(th.getStage()));
        }
        return ths;
    }

    //通过点击阶段图标更新交易细节
    @RequestMapping(value = "/detail", method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateDetailByClickingIcon(String stage, String id, String money, String expecteddate, HttpServletRequest req){
        User loginUser = (User) req.getSession().getAttribute("loginUser");
        Map<String, String> possMap = (Map<String, String>) req.getServletContext().getAttribute("possMap");
        Tran tran = new Tran();
        tran.setStage(stage);
        tran.setId(id);
        tran.setExpecteddate(expecteddate);
        tran.setEditby(loginUser.getName());
        tran.setEdittime(DateTimeUtil.getSysTime());
        tran.setMoney(money);
        System.out.println(tran);
        if(tranService.updateDetailWebsite(tran)){
            tran.setPossibility(possMap.get(stage));//设置可能性
            System.out.println(tran);
            return Msg.success().addObject("t", tran).setStatus("阶段更新成功");
        }
        return Msg.fail().setStatus("阶段更新失败");
    }

    //通过点击阶段图标更新交易细节
    @RequestMapping(value = "/chart", method = RequestMethod.GET)
    @ResponseBody
    public Map<String,Object> getTranChartData(){

        return tranService.getTranChartData();

    }

}
