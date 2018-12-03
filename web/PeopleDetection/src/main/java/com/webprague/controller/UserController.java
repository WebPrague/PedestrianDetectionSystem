package com.webprague.controller;

import com.webprague.service.UserService;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

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
            ServletContext context = httpSession.getServletContext();

            //打印在线人数
            System.out.println("在线人数：" + context.getAttribute("onlineCount"));
            //登录提示框
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

}
