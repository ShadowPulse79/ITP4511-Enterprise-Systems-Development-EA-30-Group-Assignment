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
import java.util.List;

@WebServlet({
        "/admin/users",
        "/admin/user/create",
        "/admin/user/edit",
        "/admin/user/delete"
})
public class AdminUserController extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String path = request.getServletPath();
        if ("/admin/users".equals(path)) {
            listUsers(request, response);
        } else if ("/admin/user/create".equals(path)) {
            showCreateForm(request, response);
        } else if ("/admin/user/edit".equals(path)) {
            showEditForm(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String path = request.getServletPath();
        if ("/admin/user/create".equals(path)) {
            createUser(request, response);
        } else if ("/admin/user/edit".equals(path)) {
            updateUser(request, response);
        } else if ("/admin/user/delete".equals(path)) {
            deleteUser(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Integer role = (Integer) session.getAttribute("role");
            return role != null && role == 3; // 3 = admin
        }
        return false;
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> users = userService.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/admin/user_list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User user = userService.getUserById(id);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/admin/user_form.jsp").forward(request, response);
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = new User();
        user.setUsername(request.getParameter("username"));
        user.setPassword(request.getParameter("password"));
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setRole(Integer.parseInt(request.getParameter("role")));
        
        String clinicIdStr = request.getParameter("clinicId");
        if (clinicIdStr != null && !clinicIdStr.trim().isEmpty()) {
            user.setClinicId(Integer.parseInt(clinicIdStr));
        }

        user.setActive(request.getParameter("isActive") != null);

        userService.adminCreateUser(user);
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User user = userService.getUserById(id);
        if (user != null) {
            user.setFullName(request.getParameter("fullName"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            user.setRole(Integer.parseInt(request.getParameter("role")));
            
            String clinicIdStr = request.getParameter("clinicId");
            if (clinicIdStr != null && !clinicIdStr.trim().isEmpty()) {
                user.setClinicId(Integer.parseInt(clinicIdStr));
            } else {
                user.setClinicId(null);
            }

            user.setActive(request.getParameter("isActive") != null);

            userService.updateInfo(user);
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        userService.deleteUser(id);
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
