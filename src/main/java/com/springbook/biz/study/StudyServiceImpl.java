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
    public StudyVO getStudyDetails(String pid, String studyDate) {
        return studyDAO.getStudyDetails(pid, studyDate);
    }


}