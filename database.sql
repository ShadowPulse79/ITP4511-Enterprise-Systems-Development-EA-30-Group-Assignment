
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
-- 表3: services（服务表）
-- =====================================================
CREATE TABLE services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =====================================================
-- 表1: clinics（诊所表）
-- 功能：存储诊所的基本信息，用于诊所管理
-- =====================================================
CREATE TABLE clinics (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '诊所ID，主键',
    name VARCHAR(100) NOT NULL COMMENT '诊所名称，如：柴湾诊所',
    location VARCHAR(200) COMMENT '诊所地址/位置',
    walkInEnabled BOOLEAN DEFAULT TRUE COMMENT '是否接受现场排队，TRUE=可walk-in，FALSE=仅限预约',
    serviceQuota TEXT NULL COMMENT '【预留字段】JSON格式服务配额，如{"1":20,"2":10}，建议改用clinicSchedules.maxQuota',
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) COMMENT='诊所基本信息表 - 用于诊所管理功能';


-- =====================================================
-- 表2: clinicSchedules（诊所日程表）
-- 功能：存储诊所的营业时间、服务时段、容量配额，用于营业时间和容量规则配置
-- =====================================================
CREATE TABLE clinicSchedules (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '时段ID，主键',
    clinicId INT NOT NULL COMMENT '所属诊所ID，关联clinics.id',
    serviceId INT NOT NULL COMMENT '服务ID，关联services.id',
    slotDate DATE NOT NULL COMMENT '营业日期，如：2026-04-23',
    startTime TIME NOT NULL COMMENT '时段开始时间，如：09:00:00',
    endTime TIME NOT NULL COMMENT '时段结束时间，如：12:00:00',
    maxQuota INT DEFAULT 5 COMMENT '该时段最大预约配额（容量规则），如：最多10人',
    isAvailable BOOLEAN DEFAULT TRUE COMMENT '该时段是否可用，FALSE表示临时关闭（如医生请假）',
    UNIQUE KEY uk_schedule (clinicId, serviceId, slotDate, startTime) COMMENT '唯一约束：同一诊所同一服务同一天同一时段不能重复'
) COMMENT='诊所时段配额表 - 用于营业时间配置和容量规则配置';

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
