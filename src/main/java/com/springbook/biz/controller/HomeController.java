package com.springbook.biz.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springbook.biz.VO.BoardVO;
import com.springbook.biz.VO.StudyVO;
import com.springbook.biz.board.impl.BoardService;
import com.springbook.biz.study.StudyService;


@Controller
public class HomeController {
    @Autowired
    private StudyService studyService;
    
	@Autowired
	private BoardService boardService;
	
	@GetMapping("/public/home")
	public String publicHome() {
	    return "public/home";
	}
    

    
	@GetMapping("/")
	public String index(Model model, @RequestParam(defaultValue = "1") int page) {
	    int pageSize = 6;
	    List<StudyVO> allStudies = studyService.getStudyList();
	    int totalStudies = allStudies.size();
	    int totalPages = (int) Math.ceil((double) totalStudies / pageSize);
	    
	    int start = (page - 1) * pageSize;
	    int end = Math.min(start + pageSize, totalStudies);
	    List<StudyVO> pagedStudies = allStudies.subList(start, end);
	    
	    model.addAttribute("studyList", pagedStudies);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);
	    return "index";
	}
	@GetMapping("insertBoardPage")
	public String insert() {
		return "insertBoardPage";
	}
	
	// 글 등록
	@PostMapping("/insertBoard")
	public String insertBoard(BoardVO vo) throws IOException {
		System.out.println("글 등록 처리");
		boardService.insertBoard(vo);
		return "redirect:getBoardList";
	}
	
	// 글 수정
	@PostMapping("/updateBoard")
	public String updateBoard(@ModelAttribute("board") BoardVO vo) {
		System.out.println("글 수정 처리");
		
		boardService.updateBoard(vo);
		return "redirect:getBoardList";
	}
	
	// 글 삭제
	@PostMapping("/deleteBoard")
	public String deleteBoard(BoardVO vo) {
		System.out.println("글 삭제 처리");
		
		boardService.deleteBoard(vo);
		return "redirect:getBoardList";
	}
	
	// 글 상세 조회
	@GetMapping("/getBoard")
	public String getBoard(BoardVO vo, Model model) {
		System.out.println("글 상세 조회 처리");
		
		model.addAttribute("board", boardService.getBoard(vo));		// Model 정보 저장
		return "getBoard";		// View 이름 리턴
	}	
	
	// 글 목록 검색
	@GetMapping("/getBoardList")
	public String getBoardList(BoardVO vo, Model model) {
		System.out.println("글 목록 검색 처리");
		
		// Null Check
		if(vo.getSearchCondition() == null) vo.setSearchCondition("TITLE");
		if(vo.getSearchKeyword() == null) vo.setSearchKeyword("");
		
		model.addAttribute("boardList", boardService.getBoardList(vo));		// Model 정보 저장 
    	return "getBoardList";							
	}
	
}
