package com.zhemo.exception.handler;

import com.zhemo.domain.Msg;
import com.zhemo.exception.LoginException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author zhemozhiwangddd
 * @create 2021-01-19 21:59
 */
@ControllerAdvice
public class GlobalExceptionResolver {

    @ExceptionHandler(value= LoginException.class)
    @ResponseBody
    public Msg loginException(LoginException ex){
        return Msg.fail().setStatus(ex.getMessage());
    }


}
