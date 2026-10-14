package com.mapleandcrumb.dao.impl;

import com.mapleandcrumb.dao.UserDAO;
import com.mapleandcrumb.model.Customer;
import com.mapleandcrumb.model.User;
import com.mapleandcrumb.util.FileUtil;

import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {

    private static final String FILE_NAME = "users.txt";

    // CREATE
    @Override
    public void registerUser(User user) {

        String line = user.getUserID() + "," + user.getUsername() + "," + user.getPassword() + ","
                + user.getEmail() + "," + user.getPhone();

        if (user instanceof Customer) {
            Customer c = (Customer) user;

            line += "," + c.getDeliveryAddress() + "," + c.getLoyaltyPoints();
        }
        FileUtil.appendToFile(FILE_NAME, line);
    }

    // READ
    @Override
    public User searchUserByEmail(String email) {

        List<String> lines = FileUtil.readFromFile(FILE_NAME);
        for (String line : lines) {
            String[] data = line.split(",");

            if (data.length >= 4 && data[3].equals(email)) {
                return mapLineToUser(data);
            }
        }

        return null;
    }

    @Override
    public User searchUserById(String userId) {

        List<String> lines = FileUtil.readFromFile(FILE_NAME);

        for (String line : lines) {
            String[] data = line.split(",");

            if (data.length > 0 && data[0].equals(userId)) {
                return mapLineToUser(data);
            }
        }

        return null;
    }

    @Override
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        List<String> lines = FileUtil.readFromFile(FILE_NAME);

        for (String line : lines) {
            if (!line.trim().isEmpty()) {
                users.add(mapLineToUser(line.split(",")));
            }
        }
        return users;
    }

    // UPDATE
    @Override
    public void updateUser(User user) {
        deleteUser(user.getUserID());
        registerUser(user);
    }

    // DELETE
    @Override
    public void deleteUser(String userId) {

        List<String> lines = FileUtil.readFromFile(FILE_NAME);
        List<String> updatedLines = new ArrayList<>();

        for (String line : lines) {

            if (!line.startsWith(userId + ",")) {
                updatedLines.add(line);
            }
        }
        FileUtil.writeToFile(FILE_NAME, updatedLines);
    }

    private User mapLineToUser(String[] data) {
        String address = data.length > 5 ? data[5] : "";

        return new Customer(
                data[0],
                data[1],
                data[2],
                data[3],
                data[4],
                address);
    }
}
