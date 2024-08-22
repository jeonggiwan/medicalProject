package com.springbook.biz.member;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.springbook.biz.VO.MemberVO;

@Repository
public class MemberDAOMybatis {
    @Autowired
    private SqlSessionTemplate mybatis;
    
    public MemberVO login(MemberVO vo) {
        return mybatis.selectOne("MemberDAO.login", vo);  
    }
    
    public MemberVO getMemberById(String id) {
        return mybatis.selectOne("MemberDAO.getMemberById", id);
    }


    public void saveRefreshToken(String id, String refreshToken, Date expiryDate) {
        MemberVO vo = new MemberVO();
        vo.setId(id);
        vo.setRefreshToken(refreshToken);
        vo.setRefreshTokenExpiryDate(expiryDate);
        mybatis.update("MemberDAO.saveRefreshToken", vo);
    }

    public void updateRefreshToken(String id, String refreshToken, Date expiryDate) {
        MemberVO vo = new MemberVO();
        vo.setId(id);
        vo.setRefreshToken(refreshToken);
        vo.setRefreshTokenExpiryDate(expiryDate);
        mybatis.update("MemberDAO.updateRefreshToken", vo);
    }
    public void removeRefreshToken(String id) {
        mybatis.update("MemberDAO.removeRefreshToken", id);
    }

    public MemberVO getRefreshTokenByUserId(String id) {
        return mybatis.selectOne("MemberDAO.getRefreshTokenByUserId", id);
    }

    public void removeExpiredRefreshTokens() {
        mybatis.delete("MemberDAO.removeExpiredRefreshTokens");
    }
    
    public List<MemberVO> getAllMembers() {
        return mybatis.selectList("MemberDAO.getAllMembers");
    }

    public List<MemberVO> searchMembers(String searchKeyword, String searchType) {
        Map<String, Object> params = new HashMap<>();
        params.put("searchKeyword", searchKeyword);
        params.put("searchType", searchType);
        return mybatis.selectList("MemberDAO.searchMembers", params);
    }
    public void deleteMembers(List<String> memberIds) {
        mybatis.delete("MemberDAO.deleteMembers", memberIds);
    }
    
    public MemberVO getMember(String id) {
        return mybatis.selectOne("MemberDAO.getMember", id);
    }

    public void insertMember(MemberVO memberVO) {
        mybatis.insert("MemberDAO.insertMember", memberVO);
    }
    
    public MemberVO getMemberByEmail(String email) {
        return mybatis.selectOne("MemberDAO.getMemberByEmail", email);
    }

    public MemberVO getMemberByPhoneNumber(String phoneNumber) {
        return mybatis.selectOne("MemberDAO.getMemberByPhoneNumber", phoneNumber);
    }
}