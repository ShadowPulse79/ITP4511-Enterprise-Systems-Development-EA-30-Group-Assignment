
DROP DATABASE IF EXISTS itp4511_cchcSystem;
CREATE DATABASE itp4511_cchcSystem;
USE itp4511_cchcSystem;

-- =====================================================
-- 表1: users（用户表）
-- =====================================================
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fullName VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    role INT NOT NULL COMMENT '1=patient, 2=staff, 3=admin',
    clinicId INT NULL COMMENT '员工所属诊所ID',
    isActive BOOLEAN DEFAULT TRUE,
    createTime DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- =====================================================
-- 表2: clinics（诊所表）
-- =====================================================
CREATE TABLE clinics (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(200),
    walkInEnabled BOOLEAN DEFAULT TRUE,
    serviceQuota TEXT NULL COMMENT 'JSON格式: {"1":5, "2":3}',
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =====================================================
-- 表3: services（服务表）
-- =====================================================
CREATE TABLE services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =====================================================
-- 表4: clinicSchedules（诊所日程表）
-- =====================================================
CREATE TABLE clinicSchedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    clinicId INT NOT NULL,
    serviceId INT NOT NULL,
    slotDate DATE NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    maxQuota INT DEFAULT 5,
    isAvailable BOOLEAN DEFAULT TRUE,
    UNIQUE KEY uk_schedule (clinicId, serviceId, slotDate, startTime)
);


-- =====================================================
-- 表5: appointments（预约表）
-- =====================================================
CREATE TABLE appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patientId INT NOT NULL,
    clinicId INT NOT NULL,
    serviceId INT NOT NULL,
    scheduleId INT NOT NULL,
    appointmentDate DATE NOT NULL,
    startTime TIME NOT NULL,
    status ENUM('confirmed','completed','cancelled','no_show') DEFAULT 'confirmed',
    cancelReason VARCHAR(255) NULL,
    checkInTime TIMESTAMP NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patientId) REFERENCES users(id),
    FOREIGN KEY (scheduleId) REFERENCES clinicSchedules(id)
);


-- =====================================================
-- 表6: walkinQueues（即场排队表）
-- =====================================================
CREATE TABLE walkinQueues (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patientId INT NOT NULL,
    clinicId INT NOT NULL,
    serviceId INT NOT NULL,
    queueDate DATE NOT NULL,
    queueNumber INT NOT NULL,
    status ENUM('waiting','calling','served','skipped') DEFAULT 'waiting',
    calledAt TIMESTAMP NULL,
    servedAt TIMESTAMP NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uniqueActiveQueue (patientId, clinicId, serviceId, queueDate, status)
);


-- =====================================================
-- 表7: notifications（通知表）
-- =====================================================
CREATE TABLE notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    userId INT NOT NULL,
    -- '1=预约确认,2=预约改期,3=预约取消,4=预约提醒,5=排队叫号,6=排队跳过,7=排队完成,8=缺席警告',
    type INT NOT NULL COMMENT '1=预约确认,2=预约改期,3=预约取消,4=预约提醒,5=排队叫号,6=排队跳过,7=排队完成,8=缺席警告',
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    isRead BOOLEAN DEFAULT FALSE,
    relatedAppointmentId INT NULL,
    relatedQueueId INT NULL,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES users(id),
    INDEX idx_user_read (userId, isRead)
);

-- 管理员 (role = 3)
INSERT INTO users (username, password, fullName, email, phone, role, clinicId, isActive) VALUES
('admin', 'password', '系统管理员', 'admin@cchc.com', '123456', 3, NULL, TRUE);

-- 诊所员工 (role = 2) - 分别属于5个不同的诊所
INSERT INTO users (username, password, fullName, email, phone, role, clinicId, isActive) VALUES
('staff', 'password', '陈医生', 'staff.cw@cchc.com', '23456789', 2, 1, TRUE);

-- 患者 (role = 1)
INSERT INTO users (username, password, fullName, email, phone, role, clinicId, isActive) VALUES
('patient', 'password', '张三', 'patient@example.com', '91234567', 1, NULL, TRUE);
