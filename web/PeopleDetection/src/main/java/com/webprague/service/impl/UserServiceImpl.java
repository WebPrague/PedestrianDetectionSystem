package com.webprague.service.impl;

import com.webprague.mapper.UserMapper;
import com.webprague.model.User;
import com.webprague.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;


@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper = null;

    @Override
    @Transactional(isolation = Isolation.READ_COMMITTED, propagation = Propagation.REQUIRED)
    public boolean loginUser(String username, String password) {
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        User user1 = userMapper.selectUser(user);
        if (user1 != null) {
            return true;
        } else {
            return false;
        }
    }

    @Override
    @Transactional(isolation = Isolation.READ_COMMITTED, propagation = Propagation.REQUIRED)
    public int registerUser(String username, String password, String repeat_password, String phonenumber) {

        if (!password.equals(repeat_password)) {
            return 1;
        }
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setPhonenumber(phonenumber);
        User user1 = userMapper.selectUser(user);
        if (user1 != null){
            return 2;
        }
        userMapper.insert(user);
        return 0;
    }
}
