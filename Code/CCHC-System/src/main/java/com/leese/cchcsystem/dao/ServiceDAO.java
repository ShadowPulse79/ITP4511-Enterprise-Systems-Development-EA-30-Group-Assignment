package com.leese.cchcsystem.dao;

import com.leese.cchcsystem.model.entity.ServiceItem;
import com.leese.cchcsystem.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {
    public List<ServiceItem> getAllServices() {
        List<ServiceItem> services = new ArrayList<>();
        String sql = "SELECT * FROM services ORDER BY id ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ServiceItem s = new ServiceItem();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setDescription(rs.getString("description"));
                s.setCreatedAt(rs.getTimestamp("createdAt"));
                services.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return services;
    }
}
