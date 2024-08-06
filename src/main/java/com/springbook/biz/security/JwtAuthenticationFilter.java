package com.springbook.biz.security;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.GenericFilterBean;

public class JwtAuthenticationFilter extends GenericFilterBean {

    private final JwtTokenProvider jwtTokenProvider;

    public JwtAuthenticationFilter(JwtTokenProvider jwtTokenProvider) {
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) servletRequest;
        HttpServletResponse httpResponse = (HttpServletResponse) servletResponse;
        
        String token = httpRequest.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        System.out.println("Access token received: " + token);
        
        String refreshToken = jwtTokenProvider.resolveRefreshToken(httpRequest);
        System.out.println("Refresh token received: " + refreshToken);
        
        if (token != null) {
            processAccessToken(token, httpResponse);
        } else if (refreshToken != null) {
            processRefreshToken(refreshToken, httpResponse);
        } else {
            System.out.println("No tokens found");
        }
        
        filterChain.doFilter(servletRequest, servletResponse);
    }

    private void processAccessToken(String token, HttpServletResponse httpResponse) {
        boolean isValid = jwtTokenProvider.validateToken(token);
        System.out.println("Access token valid: " + isValid);
        
        if (isValid) {
            Authentication auth = jwtTokenProvider.getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(auth);
        } else {
            System.out.println("Access token invalid");
        }
    }

    private void processRefreshToken(String refreshToken, HttpServletResponse httpResponse) {
        System.out.println("Checking refresh token");
        if (jwtTokenProvider.validateToken(refreshToken)) {
            System.out.println("Refresh token valid, creating new access token");
            String username = jwtTokenProvider.getUserPk(refreshToken);
            String newAccessToken = jwtTokenProvider.createAccessToken(username);
            httpResponse.setHeader("Authorization", "Bearer " + newAccessToken);
            Authentication auth = jwtTokenProvider.getAuthentication(newAccessToken);
            SecurityContextHolder.getContext().setAuthentication(auth);
            
            System.out.println("New access token created: " + newAccessToken);
        } else {
            System.out.println("Refresh token invalid");
        }
    }
    
}
