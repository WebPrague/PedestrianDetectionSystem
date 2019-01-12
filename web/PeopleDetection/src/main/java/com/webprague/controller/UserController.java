package com.webprague.controller;


import com.webprague.service.DateService;
import com.webprague.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

@Controller
@RequestMapping("/")
public class UserController {

    public UserController(){
        super();
    }

    @Autowired
    private UserService userService;

    @Autowired
    private DateService dateService = null;

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
    public String index(HttpSession httpSession){

        //日统计
        String start_month = "2018-12-01";
        String end_month = "2018-12-31";

        Date daytime_start = null;
        Date daytime_end = null;
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            daytime_start = dateFormat.parse(start_month);
            daytime_end = dateFormat.parse(end_month);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        java.sql.Date start_sqlDate=new java.sql.Date(daytime_start.getTime());
        java.sql.Date end_sqlDate=new java.sql.Date(daytime_end.getTime());

        List<com.webprague.model.Date> dates = new ArrayList<com.webprague.model.Date>();
        dates = dateService.findAllByMonth(start_sqlDate, end_sqlDate);
        List<Integer> daynum=new ArrayList<Integer>();
        for (int j = 0; j < dates.size(); j++){
            for (int k = j * 1000; k < (j+1)*1000;k++){
                daynum.add(dates.get(j).getNum());
            }
        }
        httpSession.setAttribute("daynum", daynum);

        //月统计
        List<Integer> monthNum = new ArrayList<Integer>();
        for (int month = 1; month <= 12; month++){
            String start_month_day ;
            String end_month_day ;
            if(month <= 9){
                start_month_day = "2018-0" + month + "-01";
                end_month_day = "2018-0" + month + "-28";
            }else {
                start_month_day = "2018-" + month + "-01";
                end_month_day = "2018-" + month + "-28";
            }
            Date day_start = null;
            Date day_end = null;
            try {
                day_start = dateFormat.parse(start_month_day);
                day_end = dateFormat.parse(end_month_day);
            } catch (ParseException e) {
                e.printStackTrace();
            }

            java.sql.Date start_Date=new java.sql.Date(day_start.getTime());
            java.sql.Date end_Date=new java.sql.Date(day_end.getTime());

            List<com.webprague.model.Date> total_dates = new ArrayList<com.webprague.model.Date>();
            total_dates = dateService.findAllByMonth(start_Date, end_Date);
            int total = 0;
            for (int m = 0; m < total_dates.size(); m++){
                total = total + total_dates.get(m).getNum();
            }
            monthNum.add(total);
        }
        httpSession.setAttribute("monthnum", monthNum);
        return "index";
    }

    @RequestMapping(value = "logout", method = RequestMethod.POST)
    public String logout(HttpSession httpSession){
        httpSession.removeAttribute("username");
        return "redirect:login";
    }


}
