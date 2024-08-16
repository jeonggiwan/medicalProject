package com.springbook.biz.security;

import java.util.Date;

public class TokenInfo {
    private final String token;
    private final Date expirationDate;

    public TokenInfo(String token, Date expirationDate) {
        this.token = token;
        this.expirationDate = expirationDate;
    }

    public String getToken() {
        return token;
    }

    public Date getExpirationDate() {
        return expirationDate;
    }
}