package com.springbook.biz.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
    public ResponseEntity<String> logout(HttpServletResponse response) {
        return memberService.logout(response);
    }
    
 
}