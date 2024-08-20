package com.springbook.biz.schedule;


import com.springbook.biz.VO.ScheduleVO;

public interface ScheduleService {
    void insertSchedule(ScheduleVO vo);
    void updateSchedule(ScheduleVO vo);
    ScheduleVO getSchedule(ScheduleVO vo);
}