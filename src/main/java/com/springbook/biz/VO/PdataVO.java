package com.springbook.biz.VO;

public class PdataVO {

    private String pid; // 환자 ID
    private String pname; // 환자 이름
    private String modality; // 검사 장비
    private String studyDesc; // 검사 설명
    private String studyDate; // 검사 일시
    private String reportStatus; // 판독 상태
    private Integer imageCnt; // 이미지 개수

    // Getters and Setters
    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getPname() {
        return pname;
    }

    public void setPname(String pname) {
        this.pname = pname;
    }

    public String getModality() {
        return modality;
    }

    public void setModality(String modality) {
        this.modality = modality;
    }

    public String getStudyDesc() {
        return studyDesc;
    }

    public void setStudyDesc(String studyDesc) {
        this.studyDesc = studyDesc;
    }

    public String getStudyDate() {
        return studyDate;
    }

    public void setStudyDate(String studyDate) {
        this.studyDate = studyDate;
    }

    public String getReportStatus() {
        return reportStatus;
    }

    public void setReportStatus(String reportStatus) {
        this.reportStatus = reportStatus;
    }

    public Integer getImageCnt() {
        return imageCnt;
    }

    public void setImageCnt(Integer imageCnt) {
        this.imageCnt = imageCnt;
    }
}
