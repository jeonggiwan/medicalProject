package com.springbook.biz.image;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.springbook.biz.VO.ImageVO;

@Repository
public class ImageDAOMybatis {
    
    @Autowired
    @Qualifier("oracleSqlSession")
    private SqlSessionTemplate mybatis;
    
    

    
}