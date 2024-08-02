package com.springbook.biz.Pdata;

import com.springbook.biz.VO.PdataVO;
import java.util.List;

public class PdataServiceImpl implements PdataService {

    private PdataDAO pdataDAO;

    // Setter injection for DAO
    public void setPdataDAO(PdataDAO pdataDAO) {
        this.pdataDAO = pdataDAO;
    }

    @Override
    public List<PdataVO> getAllPdata() {
        return pdataDAO.getAllPdata();
    }
}
