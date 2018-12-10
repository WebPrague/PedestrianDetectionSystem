package com.webprague.controller;


import com.webprague.service.UserService;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

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
            return "redirect:index";
        }else {
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
            return "login";
        }else {
            if (registerResult == 1){
                return "register";
            }else {
                if (registerResult == 2){
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
