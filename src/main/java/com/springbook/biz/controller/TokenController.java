package com.springbook.biz.controller;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.springbook.biz.member.MemberService;

@RestController
public class TokenController {

    
    private final MemberService memberService;

    public TokenController(MemberService memberService) {
        this.memberService = memberService;
    }
    
    @GetMapping("/validateToken")
    public ResponseEntity<String> validateToken() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return ResponseEntity.ok("Token is valid");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Token is invalid");
        }
    }
    
    @GetMapping("/refreshToken")
    @ResponseBody
    public ResponseEntity<Void> refreshToken(HttpServletRequest request, HttpServletResponse response) {
        return memberService.refreshToken(request, response);
    }
}