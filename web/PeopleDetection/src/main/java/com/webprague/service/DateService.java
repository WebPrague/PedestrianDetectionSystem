package com.webprague.service;

import java.sql.Timestamp;
import java.sql.Date;
import java.util.List;

public interface DateService {
    public int addDate(int num, Date dateTime);
    public List<com.webprague.model.Date> findAllByMonth(Date start_month, Date end_month);

}
