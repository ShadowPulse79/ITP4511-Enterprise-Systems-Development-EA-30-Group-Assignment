package com.leese.cchcsystem.controller;

import com.leese.cchcsystem.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
        } else if ("/user/updateProfile".equals(path)) {
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
        HttpSession
    }
}
