package com.leese.cchcsystem.controller;

import com.leese.cchcsystem.model.entity.Clinic;
import com.leese.cchcsystem.service.ClinicService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet({
    "/admin/clinics",
    "/admin/clinic/create",
    "/admin/clinic/edit",
    "/admin/clinic/delete",
    "/admin/clinic/schedule",
    "/admin/clinic/schedule/update"
})
public class AdminClinicController extends HttpServlet {
    private ClinicService clinicService = new ClinicService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String path = request.getServletPath();
        if ("/admin/clinics".equals(path)) {
            request.setAttribute("clinics", clinicService.getAllClinics());
            request.getRequestDispatcher("/WEB-INF/views/admin/clinic_list.jsp").forward(request, response);
        } else if ("/admin/clinic/create".equals(path)) {
            request.getRequestDispatcher("/WEB-INF/views/admin/clinic_form.jsp").forward(request, response);
        } else if ("/admin/clinic/edit".equals(path)) {
            int id = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("clinic", clinicService.getClinicById(id));
            request.getRequestDispatcher("/WEB-INF/views/admin/clinic_form.jsp").forward(request, response);
        } else if ("/admin/clinic/schedule".equals(path)) {
            showSchedule(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String path = request.getServletPath();
        if ("/admin/clinic/create".equals(path) || "/admin/clinic/edit".equals(path)) {
            saveClinic(request, response);
        } else if ("/admin/clinic/delete".equals(path)) {
            int id = Integer.parseInt(request.getParameter("id"));
            clinicService.deleteClinic(id);
            response.sendRedirect(request.getContextPath() + "/admin/clinics");
        } else if ("/admin/clinic/schedule".equals(path)) {
            generateSchedule(request, response);
        } else if ("/admin/clinic/schedule/update".equals(path)) {
            updateSchedule(request, response);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("role") != null && (int)session.getAttribute("role") == 3;
    }

    private void saveClinic(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Clinic c = new Clinic();
        String idStr = request.getParameter("id");
        if (idStr != null) c.setId(Integer.parseInt(idStr));
        c.setName(request.getParameter("name"));
        c.setLocation(request.getParameter("location"));
        c.setWalkInEnabled(request.getParameter("walkInEnabled") != null);
        clinicService.saveClinic(c);
        response.sendRedirect(request.getContextPath() + "/admin/clinics");
    }

    private void showSchedule(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int clinicId = Integer.parseInt(request.getParameter("id"));
        String dateStr = request.getParameter("date");
        Date date = (dateStr == null) ? new Date(System.currentTimeMillis()) : Date.valueOf(dateStr);
        
        request.setAttribute("clinic", clinicService.getClinicById(clinicId));
        request.setAttribute("selectedDate", date);
        request.setAttribute("schedules", clinicService.getSchedules(clinicId, date, date));
        request.getRequestDispatcher("/WEB-INF/views/admin/clinic_schedule.jsp").forward(request, response);
    }

    private void generateSchedule(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int clinicId = Integer.parseInt(request.getParameter("id"));
        Date date = Date.valueOf(request.getParameter("date"));
        clinicService.generateDailySchedule(clinicId, date);
        response.sendRedirect(request.getContextPath() + "/admin/clinic/schedule?id=" + clinicId + "&date=" + date);
    }

    private void updateSchedule(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
        int maxQuota = Integer.parseInt(request.getParameter("maxQuota"));
        boolean isAvailable = request.getParameter("isAvailable") != null;

        com.leese.cchcsystem.model.entity.ClinicSchedule sch = clinicService.getScheduleById(scheduleId);
        if (sch != null) {
            sch.setMaxQuota(maxQuota);
            sch.setAvailable(isAvailable);
            clinicService.updateSchedule(sch);
            response.sendRedirect(request.getContextPath() + "/admin/clinic/schedule?id=" + sch.getClinicId() + "&date=" + sch.getSlotDate());
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/clinics");
        }
    }
}
