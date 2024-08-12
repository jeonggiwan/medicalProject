package com.springbook.biz.study;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.springbook.biz.VO.StudyVO;

@Repository
public class StudyDAOMybatis {
    
    @Autowired
    @Qualifier("oracleSqlSession")
    private SqlSessionTemplate mybatis;
    
    public List<StudyVO> getStudyList() {
        return mybatis.selectList("StudyDAO.getStudyList");
    }
    
    public List<StudyVO> getPatientHistory(String pid) {
        return mybatis.selectList("StudyDAO.getPatientHistory", pid);
    }

    public List<StudyVO> getStudiesByPeriod(String period) {
        List<StudyVO> studies = mybatis.selectList("StudyDAO.getStudiesByPeriod", period);
        System.out.println("Period: " + period + ", Studies found in DAO: " + studies.size());
        return studies;
    }

    
}