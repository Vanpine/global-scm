package com.globalscm.util;

import jakarta.servlet.http.HttpServletRequest;

/**
 * 语言解析工具
 * 从 Accept-Language 请求头解析当前语言：zh / en
 */
public class LangResolver {

    public static String resolve(HttpServletRequest request) {
        if (request == null) return "zh";
        String header = request.getHeader("Accept-Language");
        if (header != null && header.toLowerCase().contains("en")) {
            return "en";
        }
        return "zh";
    }
}
