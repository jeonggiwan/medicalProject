package com.springbook.biz.dicom.dicomService;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

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
        System.out.println(dicomFiles);
        return dicomFiles;
    }
}
