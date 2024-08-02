package com.springbook.biz.Pdata;

import com.springbook.biz.VO.PdataVO;
import com.springbook.biz.Pdata.PdataDAO;

import java.util.List;

public interface PdataService {
    List<PdataVO> getAllPdata();
}
