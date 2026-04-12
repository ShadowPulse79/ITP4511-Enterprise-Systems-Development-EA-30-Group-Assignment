package com.leese.cchcsystem.dao;


import com.leese.cchcsystem.model.entity.Notification;
import com.leese.cchcsystem.util.DBUtil;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    /**
     * 插入通知
     */
    public boolean insert(Notification notification) {
        String sql = "INSERT INTO notifications (userId, type, title, message, isRead, relatedAppointmentId, relatedQueueId) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, notification.getUserId());
            ps.setInt(2, notification.getType());
            ps.setString(3, notification.getTitle());
            ps.setString(4, notification.getMessage());
            ps.setBoolean(5, notification.isRead());
            ps.setObject(6, notification.getRelatedAppointmentId(), Types.INTEGER);
            ps.setObject(7, notification.getRelatedQueueId(), Types.INTEGER);

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        notification.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 获取用户的所有通知（按时间倒序）
     */
    public List<Notification> findByUserId(int userId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE userId = ? ORDER BY createdAt DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    /**
     * 获取用户未读通知数量
     */
    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE userId = ? AND isRead = FALSE";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 获取用户最近的 N 条通知
     */
    public List<Notification> getRecent(int userId, int limit) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE userId = ? ORDER BY createdAt DESC LIMIT ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                notifications.add(mapResultSetToNotification(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    /**
     * 标记单条通知为已读
     */
    public boolean markAsRead(int notificationId, int userId) {
        String sql = "UPDATE notifications SET isRead = TRUE WHERE id = ? AND userId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 标记用户所有通知为已读
     */
    public boolean markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET isRead = TRUE WHERE userId = ? AND isRead = FALSE";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 删除通知
     */
    public boolean delete(int notificationId, int userId) {
        String sql = "DELETE FROM notifications WHERE id = ? AND userId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 删除用户所有通知
     */
    public boolean deleteAll(int userId) {
        String sql = "DELETE FROM notifications WHERE userId = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ResultSet 映射为 Notification 对象
     */
    private Notification mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setId(rs.getInt("id"));
        notification.setUserId(rs.getInt("userId"));
        notification.setType(rs.getInt("type"));
        notification.setTitle(rs.getString("title"));
        notification.setMessage(rs.getString("message"));
        notification.setRead(rs.getBoolean("isRead"));

        int appointmentId = rs.getInt("relatedAppointmentId");
        if (!rs.wasNull()) {
            notification.setRelatedAppointmentId(appointmentId);
        }

        int queueId = rs.getInt("relatedQueueId");
        if (!rs.wasNull()) {
            notification.setRelatedQueueId(queueId);
        }

        notification.setCreatedAt(rs.getTimestamp("createdAt"));
        return notification;
    }
}