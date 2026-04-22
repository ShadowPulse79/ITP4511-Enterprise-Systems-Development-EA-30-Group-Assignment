<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>No-Show Summary - CCHC System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/index.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="admin-container">
        <header class="page-header">
            <div class="animate-fade-in">
                <h1 class="page-title">No-Show Analysis</h1>
                <p style="color: var(--text-muted); margin-top: 0.5rem;">Summary of missed appointments by clinic and service.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline">Back to Reports Hub</a>
        </header>

        <div class="stats-grid animate-fade-in" style="animation-delay: 0.1s;">
            <div class="stat-card">
                <div class="stat-label"><span>⚠️</span> Total No-Shows</div>
                <div class="stat-value">
                    <c:set var="totalNoshow" value="0" />
                    <c:forEach var="item" items="${noshow}">
                        <c:set var="totalNoshow" value="${totalNoshow + item.noShowCount}" />
                    </c:forEach>
                    ${totalNoshow}
                </div>
        </div>

        <form action="${pageContext.request.contextPath}/admin/reports/noshow" method="get" class="card animate-fade-in" style="padding: 1.5rem; margin-bottom: 2rem; border-radius: var(--radius); animation-delay: 0.2s;">
            <div style="display: flex; align-items: end; gap: 1rem;">
                <div class="form-group" style="margin-bottom: 0; flex: 1;">
                    <label class="form-label">Analysis Period</label>
                    <input type="month" name="monthYear" class="form-control" value="${param.monthYear}" style="border-radius: 0.5rem;">
                </div>
                <button type="submit" class="btn btn-primary">Generate Report</button>
                <a href="${pageContext.request.contextPath}/admin/reports/noshow" class="btn btn-outline">Clear Filters</a>
            </div>
        </form>

        <div class="card animate-fade-in" style="animation-delay: 0.3s; border: none; box-shadow: var(--shadow-md); border-radius: var(--radius);">
            <div class="table-responsive">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th style="padding-left: 2rem;">Clinic Location</th>
                            <th>Service Category</th>
                            <th style="text-align: center;">No-Show Count</th>
                            <th>Operational Impact</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${noshow}">
                            <tr>
                                <td style="padding-left: 2rem;">
                                    <span style="font-weight: 700; color: var(--text-main);">${item.clinicName}</span>
                                </td>
                                <td>
                                    <span class="badge badge-info" style="padding: 0.35rem 0.85rem; font-weight: 600;">${item.serviceName}</span>
                                </td>
                                <td style="text-align: center;">
                                    <span style="font-size: 1.375rem; font-weight: 800; color: var(--danger-color);">${item.noShowCount}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.noShowCount > 10}">
                                            <span class="badge badge-danger" style="padding: 0.35rem 0.85rem;">CRITICAL IMPACT</span>
                                        </c:when>
                                        <c:when test="${item.noShowCount > 5}">
                                            <span class="badge badge-warning" style="padding: 0.35rem 0.85rem;">HIGH ALERT</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-success" style="padding: 0.35rem 0.85rem;">NORMAL</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty noshow}">
                            <tr>
                                <td colspan="4" style="text-align: center; padding: 3rem; color: var(--text-muted);">
                                    Great news! No "No-Show" records found for this period.
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
