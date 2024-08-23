package com.springbook.biz.security;

import java.util.Base64;
import java.util.Date;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@Component
public class JwtTokenProvider {

    private String secretKey;

    private long accessTokenValidMillisecond = 1000L * 60 * 30; // 30분
    private long refreshTokenValidMillisecond = 1000L * 60 * 60 * 24 * 7; // 7일

    private final UserDetailsService userDetailsService;

    public JwtTokenProvider(@Value("${jwt.secret}") String secretKey, @Lazy UserDetailsService userDetailsService) {
        this.secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
        this.userDetailsService = userDetailsService;
    }

    public String createAccessToken(String username) {
        return createToken(username, accessTokenValidMillisecond);
    }

    public String createRefreshToken(String username) {
        return createToken(username, refreshTokenValidMillisecond);
    }

    private String createToken(String username, long validityInMilliseconds) {
        Claims claims = Jwts.claims().setSubject(username);
        Date now = new Date();
        Date validity = new Date(now.getTime() + validityInMilliseconds);

        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(now)
                .setExpiration(validity)
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();
    }

    public TokenInfo createAccessTokenInfo(String username) {
        return createTokenInfo(username, accessTokenValidMillisecond);
    }

    public TokenInfo createRefreshTokenInfo(String username) {
        return createTokenInfo(username, refreshTokenValidMillisecond);
    }

    private TokenInfo createTokenInfo(String username, long validityInMilliseconds) {
        Claims claims = Jwts.claims().setSubject(username);
        Date now = new Date();
        Date validity = new Date(now.getTime() + validityInMilliseconds);

        String token = Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(now)
                .setExpiration(validity)
                .signWith(SignatureAlgorithm.HS256, secretKey)
                .compact();

        return new TokenInfo(token, validity);
    }

    public Authentication getAuthentication(String token) {
        UserDetails userDetails = this.userDetailsService.loadUserByUsername(getUsername(token));
        return new UsernamePasswordAuthenticationToken(userDetails, "", userDetails.getAuthorities());
    }

    public String getUsername(String token) {
        return Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token).getBody().getSubject();
    }

    public String resolveToken(HttpServletRequest req) {
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("ACCESS_TOKEN".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }
    
    public void setAccessTokenCookie(HttpServletResponse response, String token) {
        Cookie cookie = new Cookie("ACCESS_TOKEN", token);
        cookie.setHttpOnly(true);
        cookie.setPath("/");
        cookie.setMaxAge((int) (accessTokenValidMillisecond / 1000)); // Convert to seconds
        response.addCookie(cookie);
    }
    
    public boolean validateToken(String token) {
        try {
            Jws<Claims> claims = Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token);
            return !claims.getBody().getExpiration().before(new Date());
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }
    
    public long getExpiration(String token) {
        try {
            Jws<Claims> claims = Jwts.parser().setSigningKey(secretKey).parseClaimsJws(token);
            return claims.getBody().getExpiration().getTime();
        } catch (JwtException | IllegalArgumentException e) {
            return 0;
        }
    }

    public long getRefreshTokenValidMillisecond() {
        return refreshTokenValidMillisecond;
    }
    
    public void removeAccessTokenCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie("ACCESS_TOKEN", null);
        cookie.setHttpOnly(true);
        cookie.setPath("/");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
    }

}