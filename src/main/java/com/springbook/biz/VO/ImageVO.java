package com.springbook.biz.VO;

public class ImageVO {
	private int studyKey;
	private int seriesKey;
	private int imageKey;
	private String studyInsUid;
	private String seriesInsUid;
	private String sopInstanceUid;
	private String sopClassUid;
	private int stStorageId;
	private String path;
	private String fName;
	private int delFlag;
	
	public int getStudyKey() {
		return studyKey;
	}
	public void setStudyKey(int studyKey) {
		this.studyKey = studyKey;
	}
	public int getSeriesKey() {
		return seriesKey;
	}
	public void setSeriesKey(int seriesKey) {
		this.seriesKey = seriesKey;
	}
	public int getImageKey() {
		return imageKey;
	}
	public void setImageKey(int imageKey) {
		this.imageKey = imageKey;
	}
	public String getStudyInsUid() {
		return studyInsUid;
	}
	public void setStudyInsUid(String studyInsUid) {
		this.studyInsUid = studyInsUid;
	}
	public String getSeriesInsUid() {
		return seriesInsUid;
	}
	public void setSeriesInsUid(String seriesInsUid) {
		this.seriesInsUid = seriesInsUid;
	}
	public String getSopInstanceUid() {
		return sopInstanceUid;
	}
	public void setSopInstanceUid(String sopInstanceUid) {
		this.sopInstanceUid = sopInstanceUid;
	}
	public String getSopClassUid() {
		return sopClassUid;
	}
	public void setSopClassUid(String sopClassUid) {
		this.sopClassUid = sopClassUid;
	}
	public int getStStorageId() {
		return stStorageId;
	}
	public void setStStorageId(int stStorageId) {
		this.stStorageId = stStorageId;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getfName() {
		return fName;
	}
	public void setfName(String fName) {
		this.fName = fName;
	}
	public int getDelFlag() {
		return delFlag;
	}
	public void setDelFlag(int delFlag) {
		this.delFlag = delFlag;
	}
}
