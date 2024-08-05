package com.springbook.biz.member;

import com.springbook.biz.VO.MemberVO;
import org.springframework.security.core.userdetails.UserDetailsService;

public interface MemberService extends UserDetailsService {
    MemberVO login(MemberVO vo);
    MemberVO getMemberById(String id);
}