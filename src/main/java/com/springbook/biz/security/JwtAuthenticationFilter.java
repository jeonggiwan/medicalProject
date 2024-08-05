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

        String token = jwtTokenProvider.resolveRefreshToken(httpRequest);
        if (token == null) {
            token = httpRequest.getHeader("Authorization");
        }
        
        if (token != null) {
            if (jwtTokenProvider.validateToken(token)) {
                Authentication auth = jwtTokenProvider.getAuthentication(token);
                SecurityContextHolder.getContext().setAuthentication(auth);
            } else {
                // 액세스 토큰이 만료된 경우
                String refreshToken = jwtTokenProvider.resolveRefreshToken(httpRequest);
         
                if (refreshToken != null && jwtTokenProvider.validateToken(refreshToken)) {
                    String username = jwtTokenProvider.getUserPk(refreshToken);
                    String newAccessToken = jwtTokenProvider.createAccessToken(username);
                    httpResponse.setHeader("Authorization", "Bearer " + newAccessToken);
                    Authentication auth = jwtTokenProvider.getAuthentication(newAccessToken);
                    SecurityContextHolder.getContext().setAuthentication(auth);
                    
                    System.out.println("New access token created: " + newAccessToken);
                }
            }
        }
        
        filterChain.doFilter(servletRequest, servletResponse);
    }
}