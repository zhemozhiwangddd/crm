package com.zhemo.domain;

import java.util.HashMap;
import java.util.Map;

/**
 * 用来存放处理结果
 * @author zhemozhiwangddd
 * @create 2021-01-19 20:53
 */
public class Msg {

    private String code;//结果码 100 成功 200失败
    private String status;//描述处理结果
    private Map<String, Object> extendInfo = new HashMap<>();//存放额外的信息

    private Msg(){};

    private Msg(String code, String status){
        this.code = code;
        this.status = status;
    }

    //成功
    public static Msg success(){
        return new Msg("100","处理成功");
    }

    //失败
    public static Msg fail(){
        return new Msg("200","处理失败");
    }

    public Msg addObject(String msg,Object obj){
        extendInfo.put(msg,obj);
        return this;
    }

    public String getCode() {
        return code;
    }

    public Msg setCode(String code) {
        this.code = code;
        return this;
    }

    public String getStatus() {
        return status;
    }

    public Msg setStatus(String status) {
        this.status = status;
        return this;
    }
}
