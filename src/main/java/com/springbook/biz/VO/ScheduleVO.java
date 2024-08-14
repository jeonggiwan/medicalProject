package com.springbook.biz.VO;

import java.util.Date;

public class ScheduleVO {
    private Integer id;
    private Date day;
    private String detail;

    public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Date getDay() {
		return day;
	}
	public void setDay(Date day) {
		this.day = day;
	}
	public String getDetail() {
		return detail;
	}
	public void setDetail(String detail) {
		this.detail = detail;
	}

}