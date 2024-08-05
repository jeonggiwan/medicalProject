package com.springbook.biz.member;

import com.springbook.biz.VO.MemberVO;

public interface MemberService {

	
	MemberVO getMemberById(String id);
	// 멤버 로그인
	MemberVO login(MemberVO vo);


}