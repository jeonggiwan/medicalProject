package com.springbook.biz.cifs;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import jcifs.CIFSContext;
import jcifs.context.SingletonContext;
import jcifs.smb.NtlmPasswordAuthenticator;
import jcifs.smb.SmbFile;
@Service
public class CifsStorageServiceImpl implements CifsStorageService {
    @Value("${cifs.host}")
    private String host;

    @Value("${cifs.share}")
    private String share;

    @Value("${cifs.username}")
    private String username;

    @Value("${cifs.password}")
    private String password;

    private String getFullPath(String fileName) {
        return "smb://" + host + "/" + share + "/" + fileName;
    }
    private CIFSContext getAuthContext() {
        NtlmPasswordAuthenticator auth = new NtlmPasswordAuthenticator(null, username, password);
        return SingletonContext.getInstance().withCredentials(auth);
    }
    @Override
    public void storeFile(String fileName, InputStream inputStream) throws IOException {
        String fullPath = getFullPath(fileName);
        SmbFile smbFile = new SmbFile(fullPath, getAuthContext());
        System.out.println("dfsfdsfgdsafjdsifjoidsjoijfdsiajfmklgdsmfdi");
        try (OutputStream out = smbFile.openOutputStream()) {
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inputStream.read(buffer)) > 0) {
                out.write(buffer, 0, length);
            }
        }
    }
    @Override
    public InputStream retrieveFile(String fileName) throws IOException {
        String fullPath = getFullPath(fileName);
        SmbFile smbFile = new SmbFile(fullPath, getAuthContext());

        return smbFile.openInputStream();
    }
}