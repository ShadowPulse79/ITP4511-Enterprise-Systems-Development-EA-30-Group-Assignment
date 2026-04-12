package com.leese.cchcsystem.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Timestamp;

@Data
@NoArgsConstructor //无参构造
@AllArgsConstructor //有参构造
public class Notification {
    private int id;
    private int userId;
    private int type;
    // 1=预约确认,2=预约改期,3=预约取消,4=预约提醒,5=排队叫号,6=排队跳过,7=排队完成,8=缺席警告
    private String title;
    private String message;
    private boolean isRead;
    private Integer relatedAppointmentId;
    private Integer relatedQueueId;
    private Timestamp createdAt;

    public Notification(int userId, int type, String title, String message) {
        this.userId = userId;
        this.type = type;
        this.title = title;
        this.message = message;
        this.isRead = false;
        this.relatedAppointmentId = null;
        this.relatedQueueId = null;
    }
    // 辅助方法：获取通知类型名称
    public String getTypeName() {
        switch (type) {
            case 1: return "预约确认";
            case 2: return "预约改期";
            case 3: return "预约取消";
            case 4: return "预约提醒";
            case 5: return "排队叫号";
            case 6: return "排队跳过";
            case 7: return "排队完成";
            case 8: return "缺席警告";
            default: return "系统通知";
        }
    }
}
