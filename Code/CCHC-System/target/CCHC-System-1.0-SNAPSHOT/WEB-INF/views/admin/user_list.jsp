<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
        .btn { padding: 5px 10px; background-color: #007bff; color: white; text-decoration: none; border-radius: 3px; }
        .btn-danger { background-color: #dc3545; }
    </style>
</head>
<body>
    <h2>User Management</h2>
    <a href="${pageContext.request.contextPath}/admin/dashboard">Back to Dashboard</a> |
    <a href="${pageContext.request.contextPath}/admin/user/create" class="btn">Create New User</a>
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Full Name</th>
                <th>Role</th>
                <th>Clinic ID</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td>${user.id}</td>
                    <td>${user.username}</td>
                    <td>${user.fullName}</td>
                    <td>
                        <c:choose>
                            <c:when test="${user.role == 1}">Patient</c:when>
                            <c:when test="${user.role == 2}">Staff</c:when>
                            <c:when test="${user.role == 3}">Admin</c:when>
                            <c:otherwise>Unknown</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${user.clinicId != null ? user.clinicId : 'N/A'}</td>
                    <td>${user.active ? 'Active' : 'Inactive'}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/user/edit?id=${user.id}" class="btn">Edit</a>
                        <form action="${pageContext.request.contextPath}/admin/user/delete" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this user?');">
                            <input type="hidden" name="id" value="${user.id}">
                            <button type="submit" class="btn btn-danger" style="border:none;cursor:pointer;">Delete</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
