package com.springbook.biz.member;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springbook.biz.VO.BoardVO;
import com.springbook.biz.VO.MemberVO;

@Service("memberService")
public class MemberServiceImpl implements MemberService{
	
	@Autowired
	private MemberDAOMybatis memberDAO;

	@Override
	public MemberVO login(MemberVO vo) {
		// TODO Auto-generated method stub
			return memberDAO.login(vo);
	}

	@Override
	public MemberVO getMemberById(String id) {
	    return memberDAO.getMemberById(id);
	}
}