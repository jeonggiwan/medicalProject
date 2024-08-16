package com.springbook.biz.VO;
import java.util.Date;
import com.springbook.biz.member.UserRole;

public class MemberVO {
    private String id;
    private String password;
    private String refreshToken;
	private Date refreshTokenExpiryDate;
	private UserRole role;

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