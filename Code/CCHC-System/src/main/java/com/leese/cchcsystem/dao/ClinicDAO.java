package com.leese.cchcsystem.dao;

import com.leese.cchcsystem.model.entity.Clinic;
import com.leese.cchcsystem.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClinicDAO {
    public List<Clinic> getAllClinics() {
        List<Clinic> clinics = new ArrayList<>();
        String sql = "SELECT * FROM clinics ORDER BY id ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                clinics.add(mapResultSetToClinic(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return clinics;
    }

    public Clinic getClinicById(int id) {
        String sql = "SELECT * FROM clinics WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapResultSetToClinic(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean createClinic(Clinic clinic) {
        String sql = "INSERT INTO clinics (name, location, walkInEnabled) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, clinic.getName());
            ps.setString(2, clinic.getLocation());
            ps.setBoolean(3, clinic.isWalkInEnabled());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateClinic(Clinic clinic) {
        String sql = "UPDATE clinics SET name = ?, location = ?, walkInEnabled = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, clinic.getName());
            ps.setString(2, clinic.getLocation());
            ps.setBoolean(3, clinic.isWalkInEnabled());
            ps.setInt(4, clinic.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteClinic(int id) {
        String sql = "DELETE FROM clinics WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Clinic mapResultSetToClinic(ResultSet rs) throws SQLException {
        Clinic clinic = new Clinic();
        clinic.setId(rs.getInt("id"));
        clinic.setName(rs.getString("name"));
        clinic.setLocation(rs.getString("location"));
        clinic.setWalkInEnabled(rs.getBoolean("walkInEnabled"));
        clinic.setCreatedAt(rs.getTimestamp("createdAt"));
        return clinic;
    }

    public int getClinicCount() {
        String sql = "SELECT COUNT(*) FROM clinics";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
