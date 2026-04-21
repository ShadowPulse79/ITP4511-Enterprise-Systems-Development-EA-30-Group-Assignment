package com.leese.cchcsystem.dao;

import com.leese.cchcsystem.model.entity.User;
import com.leese.cchcsystem.util.DBUtil;

import java.sql.*;

public class UserDAO {
    public User findByUsername(String username){
        String sql = "select * from users where username = ?";

        try(Connection conn = DBUtil.getConnection();
            //创建一个预编译的 SQL 语句执行器
            PreparedStatement ps = conn.prepareStatement(sql)){
                ps.setString(1,username);
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    return mapResultSetToUser(rs);
                }
            }catch (SQLException e){
            e.printStackTrace();
        }
        return null;
    }

    public User findById(int id){
        String sql = "select * from users where id = ?";
        try(Connection conn = DBUtil.getConnection();
            //创建一个预编译的 SQL 语句执行器
            PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1,id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                return mapResultSetToUser(rs);
            }
        }catch (SQLException e){
            e.printStackTrace();
        }
        return null;
    }

    public boolean createUser(User user){
        String sql = "INSERT INTO users (username, password, fullName, email, phone, role, clinicId, isActive) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             //第二个参数很关键：意思是"执行完后，把数据库自动生成的ID返回给我"
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setInt(6, user.getRole());
            ps.setObject(7, user.getClinicId(), java.sql.Types.INTEGER);
            ps.setBoolean(8, user.isActive());

            int affectedRows = ps.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setId(rs.getInt(1));
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
     * 只更新用户基本信息（fullName/email/phone），不修改角色、诊所、状态
     */
    public boolean updateBasicInfo(User user) {
        String sql = "UPDATE users SET fullName = ?, email = ?, phone = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUser(User user){
        String sql = "UPDATE users SET fullName = ?, email = ?, phone = ?, role = ?, " +
                "clinicId = ?, isActive = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1,user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getRole());
            ps.setObject(5, user.getClinicId(), java.sql.Types.INTEGER);
            ps.setBoolean(6, user.isActive());
            ps.setInt(7, user.getId());

            return ps.executeUpdate() > 0;

        }catch(SQLException e){
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePassword(int userId,String newP){
        String sql = "update users set password =? where id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newP);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public java.util.List<User> getAllUsers() {
        java.util.List<User> users = new java.util.ArrayList<>();
        String sql = "select * from users";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean deleteUser(int id) {
        String sql = "delete from users where id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ResultSet 映射为 User 对象
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("fullName"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getInt("role"));
        int clinicId = rs.getInt("clinicId");
        if (!rs.wasNull()) {
            user.setClinicId(clinicId);
        }
        user.setActive(rs.getBoolean("isActive"));
        return user;
    }
}
