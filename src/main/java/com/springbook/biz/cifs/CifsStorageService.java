package com.springbook.biz.cifs;

import java.io.IOException;
import java.io.InputStream;



public interface CifsStorageService {
    void storeFile(String fileName, InputStream inputStream) throws IOException;
    InputStream retrieveFile(String fileName) throws IOException;
}