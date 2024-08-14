package com.springbook.biz.member;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.springbook.biz.VO.MemberVO;

@Repository
public class MemberDAOMybatis {
    @Autowired
    @Qualifier("sqlSession") 
    private SqlSessionTemplate mybatis;
    
    public MemberVO login(MemberVO vo) {
        return mybatis.selectOne("MemberDAO.login", vo);  
    }
    
    public MemberVO getMemberById(String id) {
        return mybatis.selectOne("MemberDAO.getMemberById", id);
    }
}