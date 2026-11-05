package com.mapleandcrumb.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public final class ParamUtil {

    private ParamUtil() {}

    public static String getTrimmed(HttpServletRequest request, String paramName, String defaultValue) {
        if (request == null || paramName == null) {
            return defaultValue;
        }
        String value = request.getParameter(paramName);
        if (value == null) {
            return defaultValue;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? defaultValue : trimmed;
    }


    public static String getTrimmed(HttpServletRequest request, String paramName) {
        return getTrimmed(request, paramName, null);
    }

    public static int getInt(HttpServletRequest request, String paramName, int defaultValue) {
        String val = getTrimmed(request, paramName, null);
        if (val == null) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(val);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static Integer getInteger(HttpServletRequest request, String paramName) {
        String val = getTrimmed(request, paramName, null);
        if (val == null) {
            return null;
        }
        try {
            return Integer.parseInt(val);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    public static double getDouble(HttpServletRequest request, String paramName, double defaultValue) {
        String val = getTrimmed(request, paramName, null);
        if (val == null) {
            return defaultValue;
        }
        try {
            return Double.parseDouble(val);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static Double getDouble(HttpServletRequest request, String paramName) {
        String val = getTrimmed(request, paramName, null);
        if (val == null) {
            return null;
        }
        try {
            return Double.parseDouble(val);
        } catch (NumberFormatException e) {
            return null;
        }
    }
    public static boolean getBoolean(HttpServletRequest request, String paramName) {
        String val = getTrimmed(request, paramName, null);
        if (val == null) {
            return false;
        }
        return "true".equalsIgnoreCase(val) || "1".equals(val) || "yes".equalsIgnoreCase(val) || "on".equalsIgnoreCase(val);
    }

    public static boolean isAjax(HttpServletRequest request) {
        return request != null && "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));
    }

    public static void writeJson(HttpServletResponse response, boolean success, String message) throws IOException {
        if (response == null) return;
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String safeMsg = message != null ? message.replace("\"", "\\\"") : "";
        response.getWriter().write(String.format("{\"success\": %b, \"message\": \"%s\"}", success, safeMsg));
    }
}
