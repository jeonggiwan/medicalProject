package com.springbook.biz.security;

import java.io.IOException;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;
import io.jsonwebtoken.JwtException;

public class JwtAuthenticationFilter extends OncePerRequestFilter {
    
    private final JwtTokenProvider jwtTokenProvider;

    public JwtAuthenticationFilter(JwtTokenProvider jwtTokenProvider) {
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) 
            throws ServletException, IOException {
        String token = jwtTokenProvider.resolveToken(request);
        
        if (token != null) {
            try {
                if (jwtTokenProvider.validateToken(token)) {
                    Authentication auth = jwtTokenProvider.getAuthentication(token);
                    SecurityContextHolder.getContext().setAuthentication(auth);
                    System.out.println("Authentication set for user: " + auth.getName());
                } else {
                    System.out.println("Token validation failed");
                    SecurityContextHolder.clearContext();
                }
            } catch (JwtException e) {
                System.out.println("Invalid JWT token: " + e.getMessage());
                SecurityContextHolder.clearContext();
            }
        } else {
            System.out.println("No token found in request");
            SecurityContextHolder.clearContext();
        }

        filterChain.doFilter(request, response);
    }
}