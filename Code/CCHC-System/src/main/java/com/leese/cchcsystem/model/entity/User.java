package com.leese.cchcsystem.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data // GET/SET方法
@NoArgsConstructor //无参构造
@AllArgsConstructor //有参构造
public class User {
    private int id;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phone;
    private int role;       // 1=patient, 2=staff, 3=admin
    private Integer clinicId;
    private boolean isActive;
    private Timestamp createTime;

}
