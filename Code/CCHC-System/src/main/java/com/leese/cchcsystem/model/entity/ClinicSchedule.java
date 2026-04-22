package com.leese.cchcsystem.model.entity;

import java.sql.Date;
import java.sql.Time;

public class ClinicSchedule {
    private int id;
    private int clinicId;
    private int serviceId;
    private Date slotDate;
    private Time startTime;
    private Time endTime;
    private int maxQuota;
    private boolean available;

    // Helper fields for display
    private String clinicName;
    private String serviceName;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getClinicId() { return clinicId; }
    public void setClinicId(int clinicId) { this.clinicId = clinicId; }
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public Date getSlotDate() { return slotDate; }
    public void setSlotDate(Date slotDate) { this.slotDate = slotDate; }
    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }
    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }
    public int getMaxQuota() { return maxQuota; }
    public void setMaxQuota(int maxQuota) { this.maxQuota = maxQuota; }
    public boolean isAvailable() { return available; }
    public void setAvailable(boolean available) { this.available = available; }
    public String getClinicName() { return clinicName; }
    public void setClinicName(String clinicName) { this.clinicName = clinicName; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
}
