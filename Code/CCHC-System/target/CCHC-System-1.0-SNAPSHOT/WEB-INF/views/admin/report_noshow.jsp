<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>No-show Summary</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; max-width: 800px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
        .filter-form { margin-bottom: 20px; padding: 15px; background: #f9f9f9; border: 1px solid #ddd; }
        .btn { padding: 5px 10px; background-color: #28a745; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <h2>No-show Summary</h2>
    <a href="${pageContext.request.contextPath}/admin/reports">Back to Reports</a>
    <hr/>
    <form class="filter-form" action="${pageContext.request.contextPath}/admin/reports/noshow" method="get">
        <label>Month: <input type="month" name="monthYear" value="${param.monthYear}"></label>
        <button type="submit" class="btn">Filter</button>
        <a href="${pageContext.request.contextPath}/admin/reports/noshow" style="margin-left: 10px; text-decoration: none;">Clear</a>
    </form>

    <table>
        <thead>
            <tr>
                <th>Clinic</th>
                <th>Service</th>
                <th>No-show Count</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${noshow}">
                <tr>
                    <td>${item.clinicName}</td>
                    <td>${item.serviceName}</td>
                    <td>${item.noShowCount}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty noshow}">
                <tr><td colspan="3" style="text-align: center;">No records found.</td></tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>
