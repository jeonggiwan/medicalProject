package com.springbook.biz.image;

import com.springbook.biz.VO.ImageVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("imageService")
public class ImageServiceImpl implements ImageService {
    
    @Autowired
    private ImageDAOMybatis imageDAO;

}