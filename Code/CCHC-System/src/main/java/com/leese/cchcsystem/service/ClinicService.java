package com.leese.cchcsystem.service;

import com.leese.cchcsystem.dao.ClinicDAO;
import com.leese.cchcsystem.dao.ScheduleDAO;
import com.leese.cchcsystem.dao.ServiceDAO;
import com.leese.cchcsystem.model.entity.Clinic;
import com.leese.cchcsystem.model.entity.ClinicSchedule;
import com.leese.cchcsystem.model.entity.ServiceItem;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

public class ClinicService {
    private ClinicDAO clinicDAO = new ClinicDAO();
    private ServiceDAO serviceDAO = new ServiceDAO();
    private ScheduleDAO scheduleDAO = new ScheduleDAO();

    public List<Clinic> getAllClinics() { return clinicDAO.getAllClinics(); }
    public Clinic getClinicById(int id) { return clinicDAO.getClinicById(id); }
    public boolean saveClinic(Clinic clinic) {
        if (clinic.getId() > 0) return clinicDAO.updateClinic(clinic);
        else return clinicDAO.createClinic(clinic);
    }
    public boolean deleteClinic(int id) { return clinicDAO.deleteClinic(id); }

    public int getClinicCount() { return clinicDAO.getClinicCount(); }

    public List<ServiceItem> getAllServices() { return serviceDAO.getAllServices(); }

    public List<ClinicSchedule> getSchedules(int clinicId, Date start, Date end) {
        return scheduleDAO.getSchedulesByClinic(clinicId, start, end);
    }

    public ClinicSchedule getScheduleById(int id) {
        return scheduleDAO.getScheduleById(id);
    }

    public boolean updateSchedule(ClinicSchedule sch) {
        return scheduleDAO.updateSchedule(sch);
    }

    /**
     * 为诊所生成一天的默认排班（简化为上午 09:00-12:00 和下午 14:00-17:00）
     */
    public void generateDailySchedule(int clinicId, Date date) {
        // 先删除旧的（防止重复）
        scheduleDAO.deleteSchedules(clinicId, date);
        
        List<ServiceItem> services = serviceDAO.getAllServices();
        
        // 商业标准简化：上午 9-12，下午 14-17
        String[][] slots = {
            {"09:00:00", "12:00:00"},
            {"14:00:00", "17:00:00"}
        };
        
        for (ServiceItem s : services) {
            for (String[] slot : slots) {
                ClinicSchedule sch = new ClinicSchedule();
                sch.setClinicId(clinicId);
                sch.setServiceId(s.getId());
                sch.setSlotDate(date);
                sch.setStartTime(Time.valueOf(slot[0]));
                sch.setEndTime(Time.valueOf(slot[1]));
                sch.setMaxQuota(20); // 商业标准：大时段通常配额较多
                sch.setAvailable(true);
                scheduleDAO.createSchedule(sch);
            }
        }
    }
}
