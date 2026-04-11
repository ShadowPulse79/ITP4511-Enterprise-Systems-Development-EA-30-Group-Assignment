package com.leese.cchcsystem.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class AuthFilter implements Filter {

    // 不需要登录即可访问的路径 放行
    private static final List<String> PUBLIC_PATHS = Arrays.asList(
            "/user/login",
            "/user/register",
            "/login.jsp",
            "/register.jsp"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // 公开路径直接放行
        for (String publicPath : PUBLIC_PATHS) {
            if (path.startsWith(publicPath)) {
                chain.doFilter(request, response);
                return;
            }
        }

        // 检查登录状态
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            //doFilter 是干什么的？ 一句话：放行！让请求继续往前走。
            chain.doFilter(request, response);  // 已登录，放行
        } else {
            res.sendRedirect(req.getContextPath() + "/user/login");  // 未登录，跳转
        }
    }
}