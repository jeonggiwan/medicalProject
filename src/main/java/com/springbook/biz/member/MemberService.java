package com.springbook.biz.member;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetailsService;

import com.springbook.biz.VO.MemberVO;

public interface MemberService extends UserDetailsService {
    ResponseEntity<Map<String, String>> login(String id, String password, HttpServletResponse response);
    ResponseEntity<String> logout(HttpServletRequest request, HttpServletResponse response);
    ResponseEntity<Void> refreshToken(HttpServletRequest request, HttpServletResponse response);
    List<MemberVO> getAllMembers();
    List<MemberVO> searchMembers(String id, String name);
    void deleteMembers(List<String> memberIds);
}