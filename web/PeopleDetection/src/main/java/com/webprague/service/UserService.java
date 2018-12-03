package com.webprague.service;

public interface UserService {
    public boolean loginUser(String username, String password);
    public int registerUser(String username, String password, String repeat_password, String phonenumber);
}
