package com.webprague.config;

import javax.servlet.ServletContext;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

@WebListener
public class SessionListener implements HttpSessionListener {
    @Override
    public void sessionCreated(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        ServletContext context = session.getServletContext();
        if (context.getAttribute("onlineCount") == null){
            context.setAttribute("onlineCount", 1);
        }else {
            context.setAttribute("onlineCount", (Integer)context.getAttribute("onlineCount") + 1);
        }

    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        ServletContext context = session.getServletContext();
        context.setAttribute("onlineCount", (Integer)context.getAttribute("onlineCount") - 1);
    }
}
