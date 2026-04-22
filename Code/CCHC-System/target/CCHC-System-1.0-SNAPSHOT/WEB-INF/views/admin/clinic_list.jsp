<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Clinic Management - CCHC System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/index.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="admin-container">
        <header class="page-header">
            <div class="animate-fade-in">
                <h1 class="page-title">Clinic Management</h1>
                <p style="color: var(--text-muted); margin-top: 0.5rem;">Configure clinic locations, walk-in status and service capacities.</p>
            </div>
            <div style="display: flex; gap: 1rem;">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline">Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/clinic/create" class="btn btn-primary">Add New Clinic</a>
            </div>
        </header>

        <div class="card animate-fade-in" style="animation-delay: 0.1s;">
            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th>Clinic Details</th>
                            <th>Location</th>
                            <th>Walk-in</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${clinics}">
                            <tr>
                                <td>
                                    <div style="font-weight: 600; color: var(--text-main);">${c.name}</div>
                                    <div style="font-size: 0.75rem; color: var(--text-muted);">ID: #${c.id}</div>
                                </td>
                                <td>${c.location}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.walkInEnabled}">
                                            <span class="badge badge-success">Enabled</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-warning">Disabled</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align: right;">
                                    <div style="display: flex; justify-content: flex-end; gap: 0.5rem;">
                                        <a href="${pageContext.request.contextPath}/admin/clinic/schedule?id=${c.id}" class="btn btn-outline" style="color: var(--primary-color);">
                                            Schedule
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/clinic/edit?id=${c.id}" class="btn btn-outline">
                                            Edit
                                        </a>
                                        <form action="${pageContext.request.contextPath}/admin/clinic/delete" method="post" onsubmit="return confirm('Delete this clinic?');" style="margin: 0;">
                                            <input type="hidden" name="id" value="${c.id}">
                                            <button type="submit" class="btn btn-danger-text">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
