package com.webprague.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/")
public class ChannelController {

    public ChannelController(){
        super();
    }
    
    @RequestMapping(value = "get_channel", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView getChannel(HttpSession session, HttpServletRequest request){
        ServletContext context = session.getServletContext();
        Integer subFlag = (Integer)request.getSession().getAttribute("sub_flag");
        if(subFlag == null){
            session.setAttribute("sub_flag", 1);
            context.setAttribute("onlineCount", (Integer)context.getAttribute("onlineCount") - 1);
        }
        Map<String, Object> result = new HashMap();
        result.put("msg", "success");
        result.put("rst", 0);
        Integer channel = (Integer) context.getAttribute("use_channel");
        if (channel == null){
            channel = 0;
        }
        result.put("data", channel);
        return new ModelAndView(new MappingJackson2JsonView(), result);
    }

    @RequestMapping(value = "set_channel", method = RequestMethod.GET)
    public @ResponseBody
    ModelAndView setChannel(@RequestParam("use_channel")Integer channel, HttpSession session){
        ServletContext context = session.getServletContext();
        Map<String, Object> result = new HashMap();
        result.put("msg", "success");
        result.put("rst", 0);
        result.put("data", channel);
        context.setAttribute("use_channel", channel);
        return new ModelAndView(new MappingJackson2JsonView(), result);
    }
}
