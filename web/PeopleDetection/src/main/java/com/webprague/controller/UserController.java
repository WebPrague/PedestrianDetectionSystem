package com.webprague.controller;

import com.webprague.model.User;
import com.webprague.service.UserService;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

@Controller
@RequestMapping("/")
public class UserController {

    public UserController(){
        super();
    }

    @Autowired
    private UserService userService;


    private static final Logger logger = LogManager.getLogger(UserController.class.getName());

    @RequestMapping(value = "login", method = RequestMethod.POST)
    public String login(@RequestParam("username")String username,
                        @RequestParam("password")String password, HttpSession httpSession){
        boolean loginUserResult = userService.loginUser(username, password);
        if (loginUserResult){
            httpSession.setAttribute("username", username);
//            //登录提示框
            return "redirect:index";
        }else {
            //弹出js的提示框，用户名或密码输入错误
            return "login";

        }
    }

    @RequestMapping(value = "login", method = RequestMethod.GET)
    public String login(){
        return "login";
    }

    @RequestMapping(value = "register", method = RequestMethod.GET)
    public String register(){
        return "register";
    }


    @RequestMapping(value = "people", method = RequestMethod.POST)
    public String peopleCount(@RequestParam("peopleNum")String peopleNum, HttpServletRequest request){
        ServletContext context = request.getSession().getServletContext();
        Integer subFlag = (Integer)request.getSession().getAttribute("sub_flag");
        if(subFlag == null){
            request.getSession().setAttribute("sub_flag", 1);
//            context.setAttribute("onlineCount", (Integer)context.getAttribute("onlineCount") - 1);
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


    @RequestMapping(value = "register", method = RequestMethod.POST)
    public String register(@RequestParam("username")String username,
                           @RequestParam("password")String password,
                           @RequestParam("repeat_password")String repeat_password,
                           @RequestParam("phonenumber")String phonenumber){
        int registerResult = userService.registerUser(username, password, repeat_password, phonenumber);
        if (registerResult == 0){
            //注册成功，弹出提示框
            return "login";
        }else {
            String msg = "";
            if (registerResult == 1){
                //注册失败，弹出提示框
                msg = "两次密码不一致！";
                return "register";
            }else {
                if (registerResult == 2){
                    //注册失败，弹出提示框
                    msg = "用户名已存在，请直接登录";
                    return "login";
                }
            }
            return "register";
        }
    }

    @RequestMapping(value = "index", method = RequestMethod.GET)
    public String index(){
        return "index";
    }

    @RequestMapping(value = "logout", method = RequestMethod.POST)
    public String logout(HttpSession httpSession){
        httpSession.removeAttribute("username");
        return "redirect:login";
    }

    /**
     * 得到播放那个通道的视频流
     * */
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
