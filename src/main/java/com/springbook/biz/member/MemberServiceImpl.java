package com.springbook.biz.member;

import com.springbook.biz.VO.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service("memberService")
public class MemberServiceImpl implements MemberService {
    
    @Autowired
    private MemberDAOMybatis memberDAO;

    @Override
    public MemberVO login(MemberVO vo) {
        return memberDAO.login(vo);
    }

    @Override
    public MemberVO getMemberById(String id) {
        return memberDAO.getMemberById(id);
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        MemberVO member = getMemberById(username);
        if (member == null) {
            throw new UsernameNotFoundException("User not found with username: " + username);
        }
        return User.withUsername(member.getId())
                   .password(member.getPassword())
                   .roles("USER")
                   .build();
    }
}