<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments Report - CCHC System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/index.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .filter-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            background: #fff;
            padding: 1.5rem;
            border-radius: var(--radius);
            box-shadow: var(--shadow-sm);
            margin-bottom: 2rem;
            align-items: end;
        }
        .status-pill {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-confirmed { background: #e0f2fe; color: #0369a1; }
        .status-completed { background: #dcfce7; color: #15803d; }
        .status-cancelled { background: #fee2e2; color: #b91c1c; }
        .status-no_show { background: #fef3c7; color: #92400e; }
    </style>
</head>
<body>
    <div class="admin-container">
        <header class="page-header">
            <div class="animate-fade-in">
                <h1 class="page-title">Appointments Record</h1>
                <p style="color: var(--text-muted); margin-top: 0.5rem;">Detailed analysis of patient bookings and attendance.</p>
            </div>
            <div style="display: flex; gap: 1rem;">
                <button class="btn btn-outline" onclick="window.print()">Export PDF</button>
                <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline">Back to Hub</a>
            </div>
        </header>



        <form action="${pageContext.request.contextPath}/admin/reports/appointments" method="get" class="filter-bar animate-fade-in" style="animation-delay: 0.2s;">
            <div class="form-group" style="margin-bottom: 0;">
                <label class="form-label">Clinic</label>
                <select name="clinicId" class="form-control" style="border-radius: 0.5rem;">
                    <option value="">All Clinics</option>
                    <c:forEach var="c" items="${clinics}">
                        <option value="${c.id}" ${param.clinicId == c.id ? 'selected' : ''}>${c.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group" style="margin-bottom: 0;">
                <label class="form-label">Service</label>
                <select name="serviceId" class="form-control" style="border-radius: 0.5rem;">
                    <option value="">All Services</option>
                    <c:forEach var="s" items="${services}">
                        <option value="${s.id}" ${param.serviceId == s.id ? 'selected' : ''}>${s.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group" style="margin-bottom: 0;">
                <label class="form-label">Status</label>
                <select name="status" class="form-control" style="border-radius: 0.5rem;">
                    <option value="">All Statuses</option>
                    <option value="confirmed" ${param.status == 'confirmed' ? 'selected' : ''}>Confirmed</option>
                    <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Completed</option>
                    <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                    <option value="no_show" ${param.status == 'no_show' ? 'selected' : ''}>No-Show</option>
                </select>
            </div>
            <div class="form-group" style="margin-bottom: 0;">
                <label class="form-label">Month/Year</label>
                <input type="month" name="monthYear" class="form-control" value="${param.monthYear}" style="border-radius: 0.5rem;">
            </div>
            <div style="display: flex; gap: 0.5rem;">
                <button type="submit" class="btn btn-primary" style="padding-left: 1.5rem; padding-right: 1.5rem;">Filter</button>
                <a href="${pageContext.request.contextPath}/admin/reports/appointments" class="btn btn-outline">Reset</a>
            </div>
        </form>

        <div class="card animate-fade-in" style="animation-delay: 0.3s; border: none; box-shadow: var(--shadow-md);">
            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th style="padding-left: 2rem;">Date & Time</th>
                            <th>Patient Information</th>
                            <th>Clinic & Service</th>
                            <th>Attendance Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="appt" items="${appointments}">
                            <tr>
                                <td style="padding-left: 2rem;">
                                    <div style="font-weight: 700; color: var(--text-main);">${appt.appointmentDate}</div>
                                    <div style="font-size: 0.75rem; color: var(--text-muted); font-weight: 500;">🕒 ${appt.timeSlot}</div>
                                </td>
                                <td>
                                    <div style="font-weight: 600; color: var(--text-main);">${appt.patientName}</div>
                                    <div style="font-size: 0.75rem; color: var(--text-muted);">UID: ${appt.patientId}</div>
                                </td>
                                <td>
                                    <div style="font-weight: 500;">${appt.clinicName}</div>
                                    <div style="font-size: 0.8125rem; color: var(--primary-color); font-weight: 600;">${appt.serviceName}</div>
                                </td>
                                <td>
                                    <span class="status-pill status-${appt.status}" style="padding: 0.4rem 1rem; letter-spacing: 0.025em;">
                                        ${appt.status.replace('_', ' ')}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty appointments}">
                            <tr>
                                <td colspan="4" style="text-align: center; padding: 3rem; color: var(--text-muted);">
                                    No records found matching the selected criteria.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
