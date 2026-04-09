package com.leese.cchcsystem.service;

import com.leese.cchcsystem.dao.UserDAO;
import com.leese.cchcsystem.model.entity.User;

public class UserService {
    private UserDAO userDAO = new UserDAO();

    /**
     * 用户登录
     */

    public User login(String password,String username){
        if(username == null || password == null){
            return null;
        }

        User user = userDAO.findByUsername(username);

        if(user == null){
            return null;
        }
        if(!password.equals(user.getPassword())){
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
     * 更新用户数据
     */
    public boolean updateInfo(User user){
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
}
