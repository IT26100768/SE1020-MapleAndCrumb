package com.mapleandcrumb.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;

public class FileUtil {

    private static final String DATA_FOLDER = "data/";

    public static void writeToFile(String fileName, List<String> lines) {

        try {
            Path dataPath = Paths.get(DATA_FOLDER);

            if (!Files.exists(dataPath)) {
                Files.createDirectories(dataPath);
            }
            Path filePath = dataPath.resolve(fileName);

            Files.write(filePath, lines);
        } catch (IOException e) {
            System.err.println("Error writing to file: " + fileName);
            e.printStackTrace();
        }
    }

    public static void appendToFile(String fileName, String line) {
        try {
            Path dataPath = Paths.get(DATA_FOLDER);
            if (!Files.exists(dataPath)) {
                Files.createDirectories(dataPath);
            }

            Path filePath = dataPath.resolve(fileName);

            if (!Files.exists(filePath)) {
                Files.createFile(filePath);
            }

            Files.write(filePath, (line + System.lineSeparator()).getBytes(),
                    StandardOpenOption.APPEND);
        } catch (IOException e) {
            System.err.println("Error appending to file: " + fileName);
            e.printStackTrace();
        }
    }

    public static List<String> readFromFile(String fileName) {
        List<String> lines = new ArrayList<>();
        try {
            Path filePath = Paths.get(DATA_FOLDER, fileName);

            if (Files.exists(filePath)) {
                lines = Files.readAllLines(filePath);
            }
        } catch (IOException e) {
            System.err.println("Error reading from file: " + fileName);
            e.printStackTrace();
        }
        return lines;
    }

    public static boolean deleteFile(String fileName) {
        try {
            Path filePath = Paths.get(DATA_FOLDER, fileName);
            return Files.deleteIfExists(filePath);
        } catch (IOException e) {
            System.err.println("Error deleting file: " + fileName);
            e.printStackTrace();
            return false;
        }
    }

    public static boolean fileExists(String fileName) {
        return Files.exists(Paths.get(DATA_FOLDER, fileName));
    }
}