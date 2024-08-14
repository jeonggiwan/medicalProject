package com.springbook.biz.member;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetailsService;

public interface MemberService extends UserDetailsService {
    ResponseEntity<Map<String, String>> login(String id, String password, HttpServletResponse response);
    ResponseEntity<String> logout(HttpServletResponse response);
    ResponseEntity<Void> refreshToken(HttpServletRequest request, HttpServletResponse response);
}