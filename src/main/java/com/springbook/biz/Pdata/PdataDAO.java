package com.springbook.biz.Pdata;

import com.springbook.biz.VO.PdataVO;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class PdataDAO {

    private JdbcTemplate oracleJdbcTemplate;

    public void setOracleJdbcTemplate(JdbcTemplate oracleJdbcTemplate) {
        this.oracleJdbcTemplate = oracleJdbcTemplate;
    }

    private static final String SQL_SELECT_ALL = "SELECT * FROM pacsplus.studytab";

    private RowMapper<PdataVO> rowMapper = new RowMapper<PdataVO>() {
        @Override
        public PdataVO mapRow(ResultSet rs, int rowNum) throws SQLException {
            PdataVO pdata = new PdataVO();
            pdata.setPid(rs.getString("PID"));
            pdata.setPname(rs.getString("PNAME"));
            pdata.setModality(rs.getString("MODALITY"));
            pdata.setStudyDesc(rs.getString("STUDYDESC"));
            pdata.setStudyDate(rs.getString("STUDYDATE"));
            pdata.setReportStatus(rs.getString("REPORTSTATUS"));
            pdata.setImageCnt(rs.getInt("IMAGECNT"));
            return pdata;
        }
    };

    public List<PdataVO> getAllPdata() {
        return oracleJdbcTemplate.query(SQL_SELECT_ALL, rowMapper);
    }
}
