package com.leese.cchcsystem.service;

import com.leese.cchcsystem.dao.NotificationDAO;
import com.leese.cchcsystem.model.entity.Notification;

import java.util.List;

public class NotificationService {
    private NotificationDAO notificationDAO = new NotificationDAO();

//    public boolean send(int userId, int type, String title, String message) {
//        Notification notification = new Notification(userId, type, title, message);
//        return notificationDAO.insert(notification);
//    }
    //notification的实列模块，下面所有方法类都使用此父类
    public boolean send(int userId, int type, String title, String message) {
        Notification n = new Notification(userId,type,title,message);
        return notificationDAO.insert(n);
    }
    // ==================== 患者通知 ====================

    /**
     * 预约确认通知
     */
    public void sendAppointmentConfirmed(int userId, String clinicName, String serviceName, String date, String time) {
        String title = "预约确认";
        String message = String.format("您已成功预约 %s - %s，就诊时间：%s %s，请准时到达。",
                clinicName, serviceName, date, time);
        send(userId, 1, title, message);
    }

    /**
     * 预约更新通知
     */
    public void sendAppointmentUpdated(int userId, String clinicName, String serviceName, String oldDate, String newDate) {
        String title = "预约更新";
        String message = String.format("您的预约已改期：%s - %s，原时间 %s → 新时间 %s",
                clinicName, serviceName, oldDate, newDate);
        send(userId, 2, title, message);
    }

    /**
     * 预约取消通知
     */
    public void sendAppointmentCancelled(int userId, String clinicName, String serviceName, String date){
        String title = "就诊提醒";
        String message = String.format("您已取消 %s - %s 的预约（%s）", clinicName, serviceName, date);
        send(userId,3,title,message);
    }

    /**
     * 就诊提醒通知
     */
    public void sendAppointmentReminder(int userId,String clinicName, String serviceName,String date, String time){
        String title = "就诊提醒";
        String message = String.format("您有一笔预约即将就诊：%s - %s，时间：%s %s，请提前10分钟到达！",
                clinicName, serviceName, date, time);
        send(userId,4,title,message);
    }

    /**
     * 队列已呼叫通知
     */
    public void sendQueueCalled(int userId, String clinicName, String serviceName,int queNum){
        String title = "队列以呼叫";
        String message = String.format("%s - %s 正在叫号，您的排队号：%d, 请尽快前往！",clinicName,serviceName,queNum);{
            send(userId,5,title,message);
        }
    }

    /**
     * 队列已跳过通知
     */
    public void sendQueueSkipped(int userId, String clinicName, String serviceName, int queueNumber) {
        String title = "队列已跳过";
        String message = String.format("%s - %s 您的排队号 %d 已被跳过，请联系工作人员。",
                clinicName, serviceName, queueNumber);
        send(userId, 6, title, message);
    }

    /**
     * 队列已完成通知
     */
    public void sendQueueServed(int userId, String clinicName, String serviceName) {
        String title = "队列完成";
        String message = String.format("%s - %s 您的服务已完成，感谢您的就诊！", clinicName, serviceName);
        send(userId, 7, title, message);
    }

    /**
     * 缺席警告通知
     */
    public void sendNoShowWarning(int userId, String clinicName, String serviceName, String date) {
        String title = "缺席警告";
        String message = String.format("您于 %s 在 %s - %s 的预约未到诊，已被记录为缺席。",
                date, clinicName, serviceName);
        send(userId, 8, title, message);
    }

    // ==================== 员工通知 ====================

    /**
     * 患者已签到通知（员工收到）
     */
    public void sendPatientCheckedIn(int staffId, String patientName, String clinicName, String appointmentId) {
        String title = "患者已签到";
        String message = String.format("患者 %s 已在 %s 完成签到，预约号：%s",
                patientName, clinicName, appointmentId);
        send(staffId, 11, title, message);
    }

    /**
     * 取消预约待审批通知（员工收到）
     */
    public void sendCancellationRequest(int staffId, String patientName, String serviceName, String date) {
        String title = "取消审批待办";
        String message = String.format("患者 %s 申请取消 %s（%s）的预约，请审批",
                patientName, serviceName, date);
        send(staffId, 12, title, message);
    }

    /**
     * 医生临时停诊通知（员工收到）
     */
    public void sendDoctorUnavailable(int staffId, String doctorName, String date, String timeSlot, int affectedCount) {
        String title = "医生停诊通知";
        String message = String.format("%s 于 %s %s 临时停诊，影响 %d 位患者，请通知改期",
                doctorName, date, timeSlot, affectedCount);
        send(staffId, 13, title, message);
    }

    /**
     * 队列已呼叫通知（员工收到，确认已呼叫）
     */
    public void sendQueueCalledForStaff(int staffId, String clinicName, String serviceName, int queueNumber) {
        String title = "叫号通知";
        String message = String.format("已呼叫 %s - %s 排队号：%d，请等待患者应答",
                clinicName, serviceName, queueNumber);
        send(staffId, 14, title, message);
    }

    // ==================== 管理员通知 ====================

    /**
     * 系统配置变更通知（管理员收到）
     */
    public void sendSystemConfigChanged(int adminId, String configKey, String oldValue, String newValue, String operator) {
        String title = "系统配置变更";
        String message = String.format("%s 已将配置 %s 从 %s 改为 %s",
                operator, configKey, oldValue, newValue);
        send(adminId, 21, title, message);
    }

    /**
     * 用户违规通知（管理员收到）
     */
    public void sendUserViolation(int adminId, String username, String violationType, int count) {
        String title = "用户违规通知";
        String message = String.format("用户 %s 累计 %s %d 次，请处理", username, violationType, count);
        send(adminId, 22, title, message);
    }

    /**
     * 报表生成完成通知（管理员收到）
     */
    public void sendReportReady(int adminId, String reportName, String month) {
        String title = "报表生成完成";
        String message = String.format("%s %s 报表已生成，可下载查看", reportName, month);
        send(adminId, 23, title, message);
    }

    // ==================== 查询方法 ====================

    /**
     * 获取用户所有通知
     */
    public List<Notification> getUserNotifications(int userId) {
        return notificationDAO.findByUserId(userId);
    }

    /**
     * 获取用户未读通知数量
     */
    public int getUnreadCount(int userId) {
        return notificationDAO.getUnreadCount(userId);
    }

    /**
     * 获取用户最近的 N 条通知
     */
    public List<Notification> getRecentNotifications(int userId, int limit) {
        return notificationDAO.getRecent(userId, limit);
    }

    /**
     * 标记单条为已读
     */
    public boolean markAsRead(int notificationId, int userId) {
        return notificationDAO.markAsRead(notificationId, userId);
    }

    /**
     * 全部标记为已读
     */
    public boolean markAllAsRead(int userId) {
        return notificationDAO.markAllAsRead(userId);
    }

    /**
     * 删除通知
     */
    public boolean deleteNotification(int notificationId, int userId) {
        return notificationDAO.delete(notificationId, userId);
    }

    /**
     * 删除所有通知
     */
    public boolean deleteAllNotifications(int userId) {
        return notificationDAO.deleteAll(userId);
    }
}
