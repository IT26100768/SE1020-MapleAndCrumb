package com.mapleandcrumb.dao;

import com.mapleandcrumb.model.User;

import java.util.List;

public interface UserDAO {

    void registerUser(User user);

    User searchUserByEmail(String email);

    User searchUserById(String userId);

    List<User> getAllUsers();

    void updateUser(User user);

    void deleteUser(String userId);
}
