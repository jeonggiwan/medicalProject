package com.springbook.biz.schedule;


import java.util.List;

import com.springbook.biz.VO.ScheduleVO;

public interface ScheduleService {
    void insertSchedule(ScheduleVO vo);
    void updateSchedule(ScheduleVO vo);
    ScheduleVO getSchedule(ScheduleVO vo);
	List<String> getScheduleDates(String id);
}