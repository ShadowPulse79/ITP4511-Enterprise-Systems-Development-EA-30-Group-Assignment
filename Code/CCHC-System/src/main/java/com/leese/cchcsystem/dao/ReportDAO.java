package com.leese.cchcsystem.dao;

import com.leese.cchcsystem.util.DBUtil;
import java.sql.*;
import java.util.*;

public class ReportDAO {

    public List<Map<String, Object>> getAppointments(Integer clinicId, Integer serviceId, String monthYear, String status) {
        List<Map<String, Object>> result = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT a.id, a.appointmentDate, a.startTime as timeSlot, a.status, u.fullName as patientName, c.name as clinicName, s.name as serviceName " +
            "FROM appointments a " +
            "JOIN users u ON a.patientId = u.id " +
            "JOIN clinics c ON a.clinicId = c.id " +
            "JOIN services s ON a.serviceId = s.id " +
            "WHERE 1=1 "
        );
        
        List<Object> params = new ArrayList<>();

        if (clinicId != null && clinicId > 0) {
            sql.append(" AND a.clinicId = ? ");
            params.add(clinicId);
        }
        if (serviceId != null && serviceId > 0) {
            sql.append(" AND a.serviceId = ? ");
            params.add(serviceId);
        }
        if (monthYear != null && !monthYear.isEmpty()) {
            sql.append(" AND DATE_FORMAT(a.appointmentDate, '%Y-%m') = ? ");
            params.add(monthYear);
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND a.status = ? ");
            params.add(status);
        }

        sql.append(" ORDER BY a.appointmentDate DESC, a.startTime DESC");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("appointmentDate", rs.getDate("appointmentDate"));
                row.put("timeSlot", rs.getString("timeSlot"));
                row.put("status", rs.getString("status"));
                row.put("patientName", rs.getString("patientName"));
                row.put("clinicName", rs.getString("clinicName"));
                row.put("serviceName", rs.getString("serviceName"));
                result.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getUtilisationRate(String monthYear) {
        List<Map<String, Object>> result = new ArrayList<>();
        
        String sql = "SELECT c.name as clinicName, s.name as serviceName, " +
                     "(SELECT COUNT(*) FROM appointments a WHERE a.clinicId = cs.clinicId AND a.serviceId = cs.serviceId";
                     
        if (monthYear != null && !monthYear.isEmpty()) {
            sql += " AND DATE_FORMAT(a.appointmentDate, '%Y-%m') = ?";
        }
        
        sql += ") as bookedSlots, " +
               "SUM(IFNULL(cs.maxQuota, 0)) as totalSlots " +
               "FROM clinicSchedules cs " +
               "JOIN clinics c ON cs.clinicId = c.id " +
               "JOIN services s ON cs.serviceId = s.id ";
        
        if (monthYear != null && !monthYear.isEmpty()) {
            sql += " WHERE DATE_FORMAT(cs.slotDate, '%Y-%m') = ? ";
        }
        
        sql += " GROUP BY c.id, s.id, cs.clinicId, cs.serviceId";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            int paramIndex = 1;
            if (monthYear != null && !monthYear.isEmpty()) {
                ps.setString(paramIndex++, monthYear);
                ps.setString(paramIndex++, monthYear);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("clinicName", rs.getString("clinicName"));
                row.put("serviceName", rs.getString("serviceName"));
                int booked = rs.getInt("bookedSlots");
                int total = rs.getInt("totalSlots");
                row.put("bookedSlots", booked);
                row.put("totalSlots", total);
                row.put("rate", total > 0 ? String.format("%.2f%%", (double) booked / total * 100) : "0.00%");
                result.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getNoShowSummary(String monthYear) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT c.name as clinicName, s.name as serviceName, COUNT(a.id) as noShowCount " +
                     "FROM appointments a " +
                     "JOIN clinics c ON a.clinicId = c.id " +
                     "JOIN services s ON a.serviceId = s.id " +
                     "WHERE a.status = 'no_show' ";
        
        if (monthYear != null && !monthYear.isEmpty()) {
            sql += " AND DATE_FORMAT(a.appointmentDate, '%Y-%m') = ? ";
        }
        
        sql += " GROUP BY c.id, s.id ORDER BY noShowCount DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            if (monthYear != null && !monthYear.isEmpty()) {
                ps.setString(1, monthYear);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("clinicName", rs.getString("clinicName"));
                row.put("serviceName", rs.getString("serviceName"));
                row.put("noShowCount", rs.getInt("noShowCount"));
                result.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}
