package com.leese.cchcsystem.dao;

import com.leese.cchcsystem.model.entity.ClinicSchedule;
import com.leese.cchcsystem.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {
    public List<ClinicSchedule> getSchedulesByClinic(int clinicId, Date startDate, Date endDate) {
        List<ClinicSchedule> list = new ArrayList<>();
        String sql = "SELECT cs.*, c.name as clinicName, s.name as serviceName " +
                     "FROM clinicSchedules cs " +
                     "JOIN clinics c ON cs.clinicId = c.id " +
                     "JOIN services s ON cs.serviceId = s.id " +
                     "WHERE cs.clinicId = ? AND cs.slotDate BETWEEN ? AND ? " +
                     "ORDER BY s.name ASC, cs.startTime ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clinicId);
            ps.setDate(2, startDate);
            ps.setDate(3, endDate);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSchedule(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean createSchedule(ClinicSchedule sch) {
        String sql = "INSERT INTO clinicSchedules (clinicId, serviceId, slotDate, startTime, endTime, maxQuota, isAvailable) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sch.getClinicId());
            ps.setInt(2, sch.getServiceId());
            ps.setDate(3, sch.getSlotDate());
            ps.setTime(4, sch.getStartTime());
            ps.setTime(5, sch.getEndTime());
            ps.setInt(6, sch.getMaxQuota());
            ps.setBoolean(7, sch.isAvailable());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public ClinicSchedule getScheduleById(int id) {
        String sql = "SELECT cs.*, c.name as clinicName, s.name as serviceName " +
                     "FROM clinicSchedules cs " +
                     "JOIN clinics c ON cs.clinicId = c.id " +
                     "JOIN services s ON cs.serviceId = s.id " +
                     "WHERE cs.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapResultSetToSchedule(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateSchedule(ClinicSchedule sch) {
        String sql = "UPDATE clinicSchedules SET maxQuota = ?, isAvailable = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sch.getMaxQuota());
            ps.setBoolean(2, sch.isAvailable());
            ps.setInt(3, sch.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteSchedules(int clinicId, Date date) {
        String sql = "DELETE FROM clinicSchedules WHERE clinicId = ? AND slotDate = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clinicId);
            ps.setDate(2, date);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private ClinicSchedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        ClinicSchedule s = new ClinicSchedule();
        s.setId(rs.getInt("id"));
        s.setClinicId(rs.getInt("clinicId"));
        s.setServiceId(rs.getInt("serviceId"));
        s.setSlotDate(rs.getDate("slotDate"));
        s.setStartTime(rs.getTime("startTime"));
        s.setEndTime(rs.getTime("endTime"));
        s.setMaxQuota(rs.getInt("maxQuota"));
        s.setAvailable(rs.getBoolean("isAvailable"));
        s.setClinicName(rs.getString("clinicName"));
        s.setServiceName(rs.getString("serviceName"));
        return s;
    }
}
