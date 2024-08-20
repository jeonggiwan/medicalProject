package com.springbook.biz.security;



import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String rawPassword = "1234"; // 원하는 실제 비밀번호를 여기에 입력하세요
        String encodedPassword = encoder.encode(rawPassword);
        System.out.println(encodedPassword);
    }
}