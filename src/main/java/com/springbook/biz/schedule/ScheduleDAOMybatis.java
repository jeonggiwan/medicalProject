package com.springbook.biz.schedule;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.springbook.biz.VO.ScheduleVO;

@Repository
public class ScheduleDAOMybatis {
    @Autowired
	@Qualifier("sqlSession")
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
}