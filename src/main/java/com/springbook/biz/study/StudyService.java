package com.springbook.biz.study;

import java.util.List;
import com.springbook.biz.VO.StudyVO;

public interface StudyService {
    List<StudyVO> getStudyList();
    
    List<StudyVO> getPatientHistory(String pid);
	StudyVO getStudyDetails(String studyKey, String studyDate);
    
	List<StudyVO> searchPatientsByPid(String pid);
	List<StudyVO> searchPatientsByName(String name);
    boolean updateReport(String studyKey, String studyDate, String report);

    
}