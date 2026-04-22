package com.leese.cchcsystem.controller;

import com.leese.cchcsystem.service.ReportService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet({
        "/admin/reports",
        "/admin/reports/appointments",
        "/admin/reports/utilisation",
        "/admin/reports/noshow"
})
public class AdminReportController extends HttpServlet {

    private ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || (int) session.getAttribute("role") != 3) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String path = request.getServletPath();
        String monthYear = request.getParameter("monthYear"); // e.g. "2026-04"

        // 为所有报表页面提供筛选基础数据
        request.setAttribute("clinics", reportService.getAllClinics());
        request.setAttribute("services", reportService.getAllServices());

        if ("/admin/reports".equals(path)) {

            request.getRequestDispatcher("/WEB-INF/views/admin/report_dashboard.jsp").forward(request, response);
        } else if ("/admin/reports/appointments".equals(path)) {
            String clinicIdStr = request.getParameter("clinicId");
            String serviceIdStr = request.getParameter("serviceId");
            String status = request.getParameter("status");

            Integer clinicId = (clinicIdStr != null && !clinicIdStr.isEmpty()) ? Integer.parseInt(clinicIdStr) : null;
            Integer serviceId = (serviceIdStr != null && !serviceIdStr.isEmpty()) ? Integer.parseInt(serviceIdStr) : null;

            request.setAttribute("appointments", reportService.getAppointments(clinicId, serviceId, monthYear, status));
            request.getRequestDispatcher("/WEB-INF/views/admin/report_appointments.jsp").forward(request, response);
            
        } else if ("/admin/reports/utilisation".equals(path)) {
            request.setAttribute("utilisation", reportService.getUtilisationRate(monthYear));
            request.getRequestDispatcher("/WEB-INF/views/admin/report_utilisation.jsp").forward(request, response);
            
        } else if ("/admin/reports/noshow".equals(path)) {
            request.setAttribute("noshow", reportService.getNoShowSummary(monthYear));
            request.getRequestDispatcher("/WEB-INF/views/admin/report_noshow.jsp").forward(request, response);
            
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
