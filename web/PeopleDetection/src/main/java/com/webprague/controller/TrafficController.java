package com.webprague.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/")
public class TrafficController {
    public TrafficController(){
        super();
    }

    @RequestMapping(value = "people", method = RequestMethod.POST)
    public String peopleCount(@RequestParam("peopleNum")String peopleNum, HttpServletRequest request){
        ServletContext context = request.getSession().getServletContext();
        Integer subFlag = (Integer)request.getSession().getAttribute("sub_flag");
        if(subFlag == null){
            request.getSession().setAttribute("sub_flag", 1);
        }
        request.getSession().getServletContext().setAttribute("peopleNumber", peopleNum);
        System.out.println("java端发送的人流数量是：" + peopleNum);
        return "";
    }

    @RequestMapping(value = "getPeopleNumber", method = RequestMethod.POST)
    @ResponseBody
    public String getPeopleNumber(HttpServletRequest request){
        ServletContext servletContext = request.getSession().getServletContext();
        String peoplenum = (String) servletContext.getAttribute("peopleNumber");
        System.out.println(peoplenum);
        if (peoplenum == null){
            peoplenum = "0";
        }
        return peoplenum;
    }

}
