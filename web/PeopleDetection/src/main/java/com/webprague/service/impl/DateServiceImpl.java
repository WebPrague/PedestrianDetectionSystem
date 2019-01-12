package com.webprague.service.impl;

import com.webprague.mapper.DateMapper;
import com.webprague.model.Date;
import com.webprague.model.User;
import com.webprague.service.DateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@Service
public class DateServiceImpl implements DateService {

    @Autowired
    private DateMapper dateMapper = null;

    @Override
    public int addDate(int num, java.sql.Date dateTime) {
        int advice = 0;

        Date date = new Date();
        date.setNum(num);
        date.setDaytime(dateTime);
        Date date_temp = dateMapper.findByDateTime(dateTime);
        if (date_temp != null){
            Date date1 = new Date();
            int pnum = (int) date_temp.getNum();
            pnum = pnum + num;
            date1.setId(date_temp.getId());
            date1.setDaytime(date_temp.getDaytime());
            date1.setNum(pnum);
            dateMapper.updateByPrimaryKey(date1);
            advice = 1;
        }else {
            dateMapper.insert(date);
            advice = 2;
        }

        return advice;
    }

    @Override
    public List<Date> findAllByMonth(java.sql.Date start_month, java.sql.Date end_month) {
        List<Date> dateList = new ArrayList<Date>();
        dateList = dateMapper.findAllByMonth(start_month, end_month);
        return dateList;
    }
}
