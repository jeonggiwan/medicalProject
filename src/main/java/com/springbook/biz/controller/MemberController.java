package com.springbook.biz.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springbook.biz.VO.MemberVO;
import com.springbook.biz.member.MemberService;


@Controller
public class MemberController {
    
    private final MemberService memberService;

    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    @GetMapping("/login")
    public String loginPage(@RequestParam(value = "error", required = false) String error, Model model) {
        if (error != null) {
            model.addAttribute("error", "Invalid username or password");
        }
        return "login";
    }
    
    @PostMapping("/login")
    @ResponseBody
    public ResponseEntity<Map<String, String>> login(@RequestParam String id, @RequestParam String password, HttpServletResponse response) {
        return memberService.login(id, password, response);
    }

    @PostMapping("/logout")
    @ResponseBody
    public ResponseEntity<String> logout(HttpServletRequest request, HttpServletResponse response) {
        return memberService.logout(request, response);
    }
    
    @GetMapping("/memberList")
    public String getMemberList(Model model) {
        List<MemberVO> memberList = memberService.getAllMembers();
        model.addAttribute("memberList", memberList);
        return "memberDetail";
    }
    @GetMapping("/searchMembers")
    @ResponseBody
    public List<MemberVO> searchMembers(@RequestParam(required = false) String searchKeyword,
                                        @RequestParam(required = false) String searchType) {
        return memberService.searchMembers(searchKeyword, searchType);
    }
    

    @PostMapping("/deleteMembers")
    @ResponseBody
    public ResponseEntity<String> deleteMembers(@RequestBody List<String> memberIds) {
        try {
            memberService.deleteMembers(memberIds);
            return ResponseEntity.ok("Members deleted successfully");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("Error deleting members: " + e.getMessage());
        }
    }
    
    @GetMapping("/sign")
    public String signPage() {
        return "sign";
    }

    @PostMapping("/sign")
    @ResponseBody
    public ResponseEntity<String> signUp(@RequestBody MemberVO memberVO) {
        try {
            memberService.signUp(memberVO);
            return ResponseEntity.ok("회원가입이 완료되었습니다.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("회원가입 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

}