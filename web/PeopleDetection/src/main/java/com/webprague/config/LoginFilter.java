package com.webprague.config;

import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebFilter(filterName = "LoginFilter", urlPatterns = "/*")
public class LoginFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        //请求的uri
        String[] doNotFilterUrls = {"/login", "/static", "/people", "/get_channel", "/register"};
        String url = request.getRequestURI();
        boolean doFilter = true;

        for (String u : doNotFilterUrls) {
            if (url.contains(u)) {
                doFilter = false;
                break;
            }
        }
        if (doFilter) {
            System.out.println("执行过滤操作");
            //执行过滤，从session 中获取登录者实体
            String username = (String) request.getSession().getAttribute("username");
            System.out.println(username);
            response.setContentType("text/html;charset=utf-8");
            if (username == null) {
                response.sendRedirect(request.getContextPath() + "/login?code=1&callback=" + url);
            } else {
                filterChain.doFilter(request, response);
            }
        } else {
            filterChain.doFilter(request, response);
        }
    }
}
