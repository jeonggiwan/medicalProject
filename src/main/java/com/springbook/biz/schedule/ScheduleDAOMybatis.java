package com.springbook.biz.schedule;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.springbook.biz.VO.ScheduleVO;

@Repository
public class ScheduleDAOMybatis {
    @Autowired
    private SqlSessionTemplate mybatis;

    public void insertSchedule(ScheduleVO vo) {
        mybatis.insert("ScheduleDAO.insertSchedule", vo);
    }

    public void updateSchedule(ScheduleVO vo) {
        mybatis.update("ScheduleDAO.updateSchedule", vo);
    }

    public ScheduleVO getSchedule(ScheduleVO vo) {
        return mybatis.selectOne("ScheduleDAO.getSchedule", vo);
    }
    
    public List<String> getScheduleDates(String id) {
        return mybatis.selectList("ScheduleDAO.getScheduleDates", id);
    }
}