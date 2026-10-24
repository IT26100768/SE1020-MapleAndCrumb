package com.mapleandcrumb.dao.comp01;

import com.mapleandcrumb.model.comp01.User;

import java.util.List;

public interface UserDAO {

    void registerUser(User user);

    User searchUserByEmail(String email);

    User searchUserByUsername(String username);

    User searchUserByEmailOrUsername(String identifier);

    User searchUserById(String userId);

    List<User> getAllUsers();

    int getUserCount();

    void updateUser(User user);

    boolean deleteUser(String userId);
}

