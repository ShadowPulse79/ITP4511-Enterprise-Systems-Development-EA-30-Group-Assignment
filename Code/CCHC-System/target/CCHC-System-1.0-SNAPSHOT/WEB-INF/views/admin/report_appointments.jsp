<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Appointments Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
        .filter-form { margin-bottom: 20px; padding: 15px; background: #f9f9f9; border: 1px solid #ddd; }
        .filter-form input, .filter-form select { margin-right: 10px; padding: 5px; }
        .btn { padding: 5px 10px; background-color: #28a745; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <h2>Appointments Record</h2>
    <a href="${pageContext.request.contextPath}/admin/reports">Back to Reports</a>
    <hr/>
    <form class="filter-form" action="${pageContext.request.contextPath}/admin/reports/appointments" method="get">
        <label>Clinic ID: <input type="number" name="clinicId" value="${param.clinicId}"></label>
        <label>Service ID: <input type="number" name="serviceId" value="${param.serviceId}"></label>
        <label>Month: <input type="month" name="monthYear" value="${param.monthYear}"></label>
        <label>Status: 
            <select name="status">
                <option value="">All</option>
                <option value="confirmed" ${param.status == 'confirmed' ? 'selected' : ''}>Confirmed</option>
                <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Completed</option>
                <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                <option value="no_show" ${param.status == 'no_show' ? 'selected' : ''}>No-show</option>
            </select>
        </label>
        <button type="submit" class="btn">Filter</button>
        <a href="${pageContext.request.contextPath}/admin/reports/appointments" style="margin-left: 10px; text-decoration: none;">Clear</a>
    </form>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Patient</th>
                <th>Clinic</th>
                <th>Service</th>
                <th>Date</th>
                <th>Time Slot</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="appt" items="${appointments}">
                <tr>
                    <td>${appt.id}</td>
                    <td>${appt.patientName}</td>
                    <td>${appt.clinicName}</td>
                    <td>${appt.serviceName}</td>
                    <td>${appt.appointmentDate}</td>
                    <td>${appt.timeSlot}</td>
                    <td>${appt.status}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty appointments}">
                <tr><td colspan="7" style="text-align: center;">No records found.</td></tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>
