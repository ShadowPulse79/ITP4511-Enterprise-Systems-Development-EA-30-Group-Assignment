package com.leese.cchcsystem.controller;

import com.leese.cchcsystem.model.entity.User;
import com.leese.cchcsystem.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet({
        "/user/login",
        "/user/register",
        "/user/logout",
        "/user/profile",
        "/user/updateInfo",
        "/user/changePassword"
})
public class UserController extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException{
        String path = request.getServletPath();
        if ("/user/login".equals(path)) {
            showLoginPage(request, response);
        } else if ("/user/register".equals(path)) {
            showRegisterPage(request, response);
        } else if ("/user/logout".equals(path)) {
            logout(request, response);
        } else if ("/user/profile".equals(path)) {
            showProfilePage(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/user/login".equals(path)) {
            login(request, response);
        } else if ("/user/register".equals(path)) {
            register(request, response);
        } else if ("/user/updateInfo".equals(path)) {
            updateProfile(request, response);
        } else if ("/user/changePassword".equals(path)) {
            changePassword(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }

    }

    private void showLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    private void showRegisterPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    private void showProfilePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        User user = userService.getUserById(userId);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/user/login");
    }

    // 下面都是post方法
    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userService.login(password, username);

        if (user == null) {
            request.setAttribute("error", "用户名或密码错误，或账号已被禁用");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("role", user.getRole());
            session.setAttribute("clinicId", user.getClinicId());

            String redirectUrl = getDashboardUrl(user.getRole());
            response.sendRedirect(request.getContextPath() + redirectUrl);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // 校验密码一致
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "两次输入的密码不一致");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPhone(phone);

        boolean success = userService.register(newUser);

        if (success) {
            request.setAttribute("message", "注册成功，请登录");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "注册失败，用户名可能已存在或密码长度不足4位");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        User user = new User();
        user.setId(userId);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);

        boolean success = userService.updateInfo(user);

        if (success) {
            session.setAttribute("fullName", fullName);
            request.setAttribute("message", "资料更新成功");
        } else {
            request.setAttribute("error", "资料更新失败");
        }

        // 刷新页面显示最新数据
        User updatedUser = userService.getUserById(userId);
        request.setAttribute("user", updatedUser);
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        // 校验新密码与确认密码一致
        if (!newPassword.equals(confirmNewPassword)) {
            request.setAttribute("pwdError", "新密码与确认密码不一致");
            showProfilePage(request, response);
            return;
        }

        boolean success = userService.changePassword(userId, oldPassword, newPassword);

        if (success) {
            request.setAttribute("pwdMessage", "密码修改成功，请重新登录");
            session.invalidate();
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else {
            request.setAttribute("pwdError", "原密码错误或新密码长度不足4位");
            showProfilePage(request, response);
        }
    }

    //路径稍后记得更改
    private String getDashboardUrl(int role) {
        switch (role) {
            case 1: return "/patient/dashboard";
            case 2: return "/staff/dashboard";
            case 3: return "/admin/dashboard";
            default: return "/user/login";
        }
    }
}
