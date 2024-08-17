package com.springbook.biz.VO;
import java.util.Date;
import com.springbook.biz.member.UserRole;

public class MemberVO {
    private String id;
    private String password;
    private String name;
    private String refreshToken;

	private Date refreshTokenExpiryDate;
	private UserRole role;
	private String specialty;
	private String phoneNumber;
	private String email;
	private String job;
	

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

    public String getSpecialty() {
		return specialty;
	}
	public void setSpecialty(String specialty) {
		this.specialty = specialty;
	}
	public String getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getJob() {
		return job;
	}
	public void setJob(String job) {
		this.job = job;
	}
	public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getRefreshToken() {
        return refreshToken;
    }
    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }
    public Date getRefreshTokenExpiryDate() {
		return refreshTokenExpiryDate;
	}
	public void setRefreshTokenExpiryDate(Date refreshTokenExpiryDate) {
		this.refreshTokenExpiryDate = refreshTokenExpiryDate;
	}
	public UserRole getRole() {
	    return role;
	}

	public void setRole(UserRole role) {
	    this.role = role;
	}
	
}