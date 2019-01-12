package com.webprague.mapper;

import com.webprague.model.Date;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface DateMapper {
    int insert(Date record);
    int updateByPrimaryKey(Date record);
    List<Date> findAllByMonth(@Param("start_month")java.sql.Date start_month, @Param("end_month")java.sql.Date end_month);
    Date findByDateTime(java.sql.Date dateTime);
}