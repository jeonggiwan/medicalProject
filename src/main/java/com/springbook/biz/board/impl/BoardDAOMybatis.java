package com.springbook.biz.board.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.springbook.biz.VO.BoardVO;
import com.springbook.biz.VO.MemberVO;

@Repository
public class BoardDAOMybatis{
	@Autowired
	private SqlSessionTemplate mybatis;
	
	public void insertBoard(BoardVO vo) {
        System.out.println("===> Mybatis로 insertBoard() 기능 처리");
        System.out.println("Inserting board: " + vo.toString());
        int result = mybatis.insert("BoardDAO.insertBoard", vo);
        System.out.println("Insert result: " + result);
    }

    
	public void updateBoard(BoardVO vo) {
		System.out.println("===> Mybatis로 updateBoard() 기능 처리");
		mybatis.update("BoardDAO.updateBoard", vo);
	}
	
	public void deleteBoard(BoardVO vo) {
		System.out.println("===> Mybatis로 deleteBoard() 기능 처리");
		mybatis.delete("BoardDAO.deleteBoard", vo);		
	}
	
	public void increaseCnt(BoardVO vo) {
		mybatis.update("BoardDAO.updateCnt", vo);
	}
	
	public BoardVO getBoard(BoardVO vo) {
		System.out.println("===> Mybatis로 getBoard() 기능 처리");
		return (BoardVO)mybatis.selectOne("BoardDAO.getBoard", vo);	
	}
	
	public List<BoardVO> getBoardList(BoardVO vo) {
		System.out.println("===> Mybatis로 getBoardList() 기능 처리");
		return mybatis.selectList("BoardDAO.getBoardList", vo);	
	}

    public List<MemberVO> getAllMembers() {
        return mybatis.selectList("MemberDAO.getAllMembers");
    }

    public List<MemberVO> searchMembers(String id, String name) {
        Map<String, Object> params = new HashMap<>();
        params.put("id", id);
        params.put("name", name);
        return mybatis.selectList("MemberDAO.searchMembers", params);
    }
}