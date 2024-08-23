package com.springbook.biz.study;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.springbook.biz.VO.StudyVO;

@Repository
public class StudyDAOMybatis {
    
    @Autowired
    private SqlSessionTemplate mybatis;
    
    public List<StudyVO> getStudyList() {
        return mybatis.selectList("StudyDAO.getStudyList");
    }
    
    public List<StudyVO> getPatientHistory(String pid) {
        return mybatis.selectList("StudyDAO.getPatientHistory", pid);
    }

    public StudyVO getStudyDetails(String studyKey, String studyDate) {
        StudyVO params = new StudyVO();
        params.setStudyKey(studyKey);
        params.setStudyDate(studyDate);
        return mybatis.selectOne("StudyDAO.getStudyDetails", params);
    }
    
    public List<StudyVO> searchPatientsByPid(String pid) {
        return mybatis.selectList("StudyDAO.searchPatientsByPid", pid);
    }

    public List<StudyVO> searchPatientsByName(String name) {
        return mybatis.selectList("StudyDAO.searchPatientsByName", name);
    }
}