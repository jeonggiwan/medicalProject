package com.springbook.biz.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springbook.biz.VO.BoardVO;
import com.springbook.biz.board.impl.BoardService;


@Controller
public class BoardController {
    
    private final BoardService boardService;

    public BoardController(BoardService boardService) {
        this.boardService = boardService;
    }

    @GetMapping("/insertBoardPage")
    public String insert() {
        return "insertBoardPage";
    }
    
    @PostMapping("/insertBoard")
    @ResponseBody
    public ResponseEntity<Map<String, Boolean>> insertBoard(@RequestBody BoardVO vo) {
        System.out.println("Received BoardVO: " + vo);
        boardService.insertBoard(vo);
        Map<String, Boolean> response = new HashMap<>();
        response.put("success", true);
        return ResponseEntity.ok(response);
    }

    
    @PostMapping("/updateBoard")
    public String updateBoard(@ModelAttribute("board") BoardVO vo) {
        boardService.updateBoard(vo);
        return "redirect:getBoardList";
    }
    
    @PostMapping("/deleteBoard")
    public String deleteBoard(BoardVO vo) {
        boardService.deleteBoard(vo);
        return "redirect:getBoardList";
    }
    
    @GetMapping("/getBoard")
    public String getBoard(BoardVO vo, Model model) {
        model.addAttribute("board", boardService.getBoard(vo));
        return "getBoard";
    }
    
    @GetMapping("/getBoardList")
    public String getBoardList(BoardVO vo, Model model) {
        if(vo.getSearchCondition() == null) vo.setSearchCondition("TITLE");
        if(vo.getSearchKeyword() == null) vo.setSearchKeyword("");
        
        model.addAttribute("boardList", boardService.getBoardList(vo));
        return "getBoardList";
    }
    
}