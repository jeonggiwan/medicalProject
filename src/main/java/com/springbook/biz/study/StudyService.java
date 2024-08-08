package com.springbook.biz.study;

import java.util.List;
import com.springbook.biz.VO.StudyVO;

public interface StudyService {
    List<StudyVO> getStudyList();
    
    List<StudyVO> getPatientHistory(String pid);
    
    
}