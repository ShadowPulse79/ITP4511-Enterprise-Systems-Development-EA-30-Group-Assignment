package com.leese.cchcsystem.service;

import com.leese.cchcsystem.dao.UserDAO;
import com.leese.cchcsystem.model.entity.User;

public class UserService {
    private UserDAO userDAO = new UserDAO();

    /**
     * 用户登录
     */

    public User login(String password,String username){
        System.out.println("1. 输入的用户名: [" + username + "]");
        System.out.println("2. 输入的密码: [" + password + "]");
        if(username == null || password == null){
            return null;
        }

        User user = userDAO.findByUsername(username);

        if(user == null){
            return null;
        }
        System.out.println("3. 用户存在, ID: " + user.getId());
        System.out.println("4. 数据库中的密码: [" + user.getPassword() + "]");
        System.out.println("5. 密码是否匹配: " + password.equals(user.getPassword()));
        if(!password.equals(user.getPassword())){
            return null;
        }

        // 检查用户是否被禁用（isActive == false）
        if (!user.isActive()) {
            System.out.println("6. 登录失败：该账号已被管理员禁用");
            return null; 
        }

        user.setPassword(null);
        return user;
    }

    /**
     * 用户注册
     */
    public boolean register(User user){
        if(user == null || user.getPassword()== null || user.getUsername() ==null ||user.getFullName()==null ){
            return false;
        }
        if(user.getPassword().length()<4){
            return false;
        }
        user.setRole(1);//默认患者
        user.setActive(true);
        return userDAO.createUser(user);
    }

    /**
     * 管理员创建用户（保留角色和状态）
     */
    public boolean adminCreateUser(User user){
        if(user == null || user.getPassword()== null || user.getUsername() ==null ||user.getFullName()==null ){
            return false;
        }
        if(user.getPassword().length()<4){
            return false;
        }
        return userDAO.createUser(user);
    }

    /**
     * 更新用户基本信息（仅 fullName / email / phone）
     */
    public boolean updateInfo(User user){
        return userDAO.updateBasicInfo(user);
    }

    /**
     * 管理员更新用户所有信息（包含角色、状态等）
     */
    public boolean adminUpdateUser(User user){
        return userDAO.updateUser(user);
    }


    public User getUserById(int id){
        return userDAO.findById(id);
    }

    /**
     * 更新用户密码
     */
    public boolean changePassword(int id,String oldP,String newP){
        User user = getUserById(id);
        if(user == null){
            return false;
        }
        if(!oldP.equals(user.getPassword())){
            return false;
        }
        //密码校验
        if(newP == null || newP.length()< 4){
            return false;
        }
        return userDAO.updatePassword(id, newP);
    }

    public java.util.List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    public boolean deleteUser(int id) {
        return userDAO.deleteUser(id);
    }
}
