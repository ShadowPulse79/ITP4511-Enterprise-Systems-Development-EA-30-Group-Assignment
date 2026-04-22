package com.leese.cchcsystem.controller;

import com.leese.cchcsystem.service.ClinicService;
import com.leese.cchcsystem.service.ReportService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminController extends HttpServlet {

    private ReportService reportService = new ReportService();
    private ClinicService clinicService = new ClinicService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        // 角色越权校验：非 admin(role=3) 重定向到对应 Dashboard
        int role = (int) session.getAttribute("role");
        if (role != 3) {
            response.sendRedirect(request.getContextPath() + getDashboardUrl(role));
            return;
        }

        // 获取实时数据
        int todayBookings = reportService.getTodayBookingCount();
        int clinicCount = clinicService.getClinicCount();

        request.setAttribute("todayBookings", todayBookings);
        request.setAttribute("clinicCount", clinicCount);

        request.getRequestDispatcher("/WEB-INF/admin/dashboard.jsp").forward(request, response);
    }
  
    private String getDashboardUrl(int role) {
        switch (role) {
            case 1: return "/patient/dashboard";
            case 2: return "/staff/dashboard";
            default: return "/user/login";
        }
    }
}
