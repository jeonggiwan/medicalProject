package com.springbook.biz.member;


import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

public class VerificationUtil {
    private static ConcurrentHashMap<String, String> verificationCodes = new ConcurrentHashMap<>();
    
    public static String generateVerificationCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }
    
    public static void saveVerificationCode(String email, String code) {
        verificationCodes.put(email, code);
    }
    
    public static boolean verifyCode(String email, String code) {
        String savedCode = verificationCodes.get(email);
        return savedCode != null && savedCode.equals(code);
    }
}