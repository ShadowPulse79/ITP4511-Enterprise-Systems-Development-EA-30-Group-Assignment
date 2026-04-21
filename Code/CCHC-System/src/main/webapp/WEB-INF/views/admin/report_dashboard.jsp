<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reports Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .card { border: 1px solid #ccc; padding: 20px; border-radius: 5px; width: 300px; text-align: center; display: inline-block; margin-right: 20px; }
        .card a { display: inline-block; margin-top: 10px; padding: 10px 15px; background-color: #007bff; color: white; text-decoration: none; border-radius: 3px; }
    </style>
</head>
<body>
    <h2>Reports & Analytics</h2>
    <a href="${pageContext.request.contextPath}/admin/dashboard">Back to Dashboard</a>
    <hr/>
    <div>
        <div class="card">
            <h3>Appointments Record</h3>
            <p>Filter by clinic, service, month and status.</p>
            <a href="${pageContext.request.contextPath}/admin/reports/appointments">View</a>
        </div>
        <div class="card">
            <h3>Utilisation Rate</h3>
            <p>Booking rate by clinic and service.</p>
            <a href="${pageContext.request.contextPath}/admin/reports/utilisation">View</a>
        </div>
        <div class="card">
            <h3>No-show Summary</h3>
            <p>Count of no-shows by clinic and service.</p>
            <a href="${pageContext.request.contextPath}/admin/reports/noshow">View</a>
        </div>
    </div>
</body>
</html>
