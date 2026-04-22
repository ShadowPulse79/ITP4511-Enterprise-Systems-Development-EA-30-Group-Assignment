<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - CCHC System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/index.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="admin-container">
        <header class="page-header">
            <div class="animate-fade-in">
                <h1 class="page-title">User Management</h1>
                <p style="color: var(--text-muted); margin-top: 0.5rem;">Manage system access and roles for all users.</p>
            </div>
            <div style="display: flex; gap: 1rem;">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline">Back to Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/user/create" class="btn btn-primary">
                    <svg style="width: 1.25rem; height: 1.25rem; margin-right: 0.5rem;" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                    </svg>
                    Create New User
                </a>
            </div>
        </header>

        <div class="card animate-fade-in" style="animation-delay: 0.1s;">
            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>User Info</th>
                            <th>Role</th>
                            <th>Clinic</th>
                            <th>Status</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>
                                    <div style="display: flex; flex-direction: column;">
                                        <span style="font-weight: 600; color: var(--text-main);">${user.fullName}</span>
                                        <span style="font-size: 0.8125rem; color: var(--text-muted);">@${user.username}</span>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.role == 3}">
                                            <span class="badge badge-danger">Administrator</span>
                                        </c:when>
                                        <c:when test="${user.role == 2}">
                                            <span class="badge badge-info">Clinic Staff</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-success">Patient</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span style="color: var(--text-muted);">
                                        ${user.clinicId != null ? 'Clinic #'.concat(user.clinicId) : '—'}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.active}">
                                            <div style="display: flex; align-items: center; gap: 0.375rem; color: #166534;">
                                                <span style="width: 0.5rem; height: 0.5rem; background: #22c55e; border-radius: 50%;"></span>
                                                Active
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div style="display: flex; align-items: center; gap: 0.375rem; color: #991b1b;">
                                                <span style="width: 0.5rem; height: 0.5rem; background: #ef4444; border-radius: 50%;"></span>
                                                Inactive
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align: right;">
                                    <div style="display: flex; justify-content: flex-end; gap: 0.5rem;">
                                        <a href="${pageContext.request.contextPath}/admin/user/edit?id=${user.id}" class="btn btn-outline" style="padding: 0.375rem 0.75rem;">
                                            Edit
                                        </a>
                                        <form action="${pageContext.request.contextPath}/admin/user/delete" method="post" onsubmit="return confirm('Are you sure you want to delete this user?');" style="margin: 0;">
                                            <input type="hidden" name="id" value="${user.id}">
                                            <button type="submit" class="btn btn-danger-text" style="padding: 0.375rem 0.75rem; border: none;">
                                                Delete
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <c:if test="${empty users}">
                <div style="padding: 3rem; text-align: center; color: var(--text-muted);">
                    No users found in the system.
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>
