package com.springbook.biz.study;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springbook.biz.VO.StudyVO;

@Service("studyService")
public class StudyServiceImpl implements StudyService {

    @Autowired
    private StudyDAOMybatis studyDAO;

    @Override
    public List<StudyVO> getStudyList() {
        return studyDAO.getStudyList();
    }
    
    @Override
    public List<StudyVO> getPatientHistory(String pid) {
        return studyDAO.getPatientHistory(pid);
    }

    @Override
    public StudyVO getStudyDetails(String studyKey, String studyDate) {
        return studyDAO.getStudyDetails(studyKey, studyDate);
    }

    @Override
    public List<StudyVO> searchPatientsByPid(String pid) {
        return studyDAO.searchPatientsByPid(pid);
    }

    @Override
    public List<StudyVO> searchPatientsByName(String name) {
        return studyDAO.searchPatientsByName(name);
    }
}