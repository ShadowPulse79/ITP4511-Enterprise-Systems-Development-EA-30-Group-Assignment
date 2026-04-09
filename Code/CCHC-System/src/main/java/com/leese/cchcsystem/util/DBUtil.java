package com.leese.cchcsystem.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/itp4511_cchcsystem:";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";

    static{
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException{
        //建立并返回一个到MySQL数据库的连接对象（Connection），后续可以通过这个连接来执行SQL语句。
        return DriverManager.getConnection(URL,USERNAME,PASSWORD);
    }

    public static void closeConnection(Connection conn) throws SQLException {
        if(conn!=null){
            conn.close();
        }
    }
}
