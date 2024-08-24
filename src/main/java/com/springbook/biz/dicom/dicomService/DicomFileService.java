package com.springbook.biz.dicom.dicomService;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;

@Service
public class DicomFileService {
    public List<String> getDicomFiles(String directoryPath) {
        List<String> dicomFiles = new ArrayList<>();
        File directory = new File("c:/" + directoryPath);
        if (directory.exists() && directory.isDirectory()) {
            for (File file : directory.listFiles()) {
                if (file.isFile() && file.getName().toLowerCase().endsWith(".dcm")) {
                    dicomFiles.add(file.getName());
                }
            }
        }
        
        // 파일 이름의 마지막 숫자를 기준으로 정렬
        Collections.sort(dicomFiles, new Comparator<String>() {
            @Override
            public int compare(String o1, String o2) {
                Integer n1 = extractLastNumber(o1);
                Integer n2 = extractLastNumber(o2);
                return n1.compareTo(n2);
            }
        });
        
        System.out.println(dicomFiles);
        return dicomFiles;
    }
    
    private Integer extractLastNumber(String filename) {
        Pattern pattern = Pattern.compile("(\\d+)[^\\d]*\\.dcm$", Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(filename);
        if (matcher.find()) {
            return Integer.parseInt(matcher.group(1));
        }
        return 0; // 숫자를 찾지 못한 경우 0을 반환
    }
}