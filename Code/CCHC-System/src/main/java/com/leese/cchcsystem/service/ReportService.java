package com.leese.cchcsystem.service;

import com.leese.cchcsystem.dao.ReportDAO;
import java.util.List;
import java.util.Map;

public class ReportService {
    private ReportDAO reportDAO = new ReportDAO();

    public List<Map<String, Object>> getAppointments(Integer clinicId, Integer serviceId, String monthYear, String status) {
        return reportDAO.getAppointments(clinicId, serviceId, monthYear, status);
    }

    public List<Map<String, Object>> getUtilisationRate(String monthYear) {
        return reportDAO.getUtilisationRate(monthYear);
    }

    public List<Map<String, Object>> getNoShowSummary(String monthYear) {
        return reportDAO.getNoShowSummary(monthYear);
    }

    public List<Map<String, Object>> getAllClinics() {
        return reportDAO.getAllClinics();
    }

    public List<Map<String, Object>> getAllServices() {
        return reportDAO.getAllServices();
    }

    public int getTodayBookingCount() {
        return reportDAO.getTodayBookingCount();
    }
}

