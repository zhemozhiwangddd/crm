package com.zhemo.web.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 用来设置登录权限的过滤器
 * @author zhemozhiwangddd
 * @create 2021-01-20 2:05
 */
public class LoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        Object user = request.getSession().getAttribute("loginUser");
        String path = request.getServletPath();
        if(user != null || "/login.jsp".equals(path) || "/workbench/activity/#".equals(path)){
            filterChain.doFilter(servletRequest,servletResponse);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    public void destroy() {

    }
}
