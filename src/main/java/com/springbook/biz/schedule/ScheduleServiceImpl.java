package com.springbook.biz.schedule;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springbook.biz.VO.ScheduleVO;

@Service("scheduleService")
public class ScheduleServiceImpl implements ScheduleService {
    @Autowired
    private ScheduleDAOMybatis scheduleDAO;

    @Override
    public void insertSchedule(ScheduleVO vo) {
        scheduleDAO.insertSchedule(vo);
    }

    @Override
    public void updateSchedule(ScheduleVO vo) {
        scheduleDAO.updateSchedule(vo);
    }

    @Override
    public ScheduleVO getSchedule(ScheduleVO vo) {
        return scheduleDAO.getSchedule(vo);
    }
}