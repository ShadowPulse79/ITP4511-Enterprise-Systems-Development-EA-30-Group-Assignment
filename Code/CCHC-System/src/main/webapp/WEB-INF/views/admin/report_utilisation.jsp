<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Utilisation Report - CCHC System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/index.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .util-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 1rem;
        }
        .progress-container {
            width: 100%;
            height: 8px;
            background: #e2e8f0;
            border-radius: 999px;
            margin: 1rem 0 0.5rem;
            overflow: hidden;
        }
        .progress-bar {
            height: 100%;
            background: var(--primary-color);
            border-radius: 999px;
        }
        .util-card {
            padding: 1.5rem;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <header class="page-header">
            <div class="animate-fade-in">
                <h1 class="page-title">Clinic Utilisation</h1>
                <p style="color: var(--text-muted); margin-top: 0.5rem;">Resource allocation and booking rates by service.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline">Back to Reports Hub</a>
        </header>


        <form action="${pageContext.request.contextPath}/admin/reports/utilisation" method="get" class="card animate-fade-in" style="padding: 1.5rem; margin-bottom: 2rem; border-radius: var(--radius); animation-delay: 0.2s;">
            <div style="display: flex; align-items: end; gap: 1rem;">
                <div class="form-group" style="margin-bottom: 0; flex: 1;">
                    <label class="form-label">Period (Month/Year)</label>
                    <input type="month" name="monthYear" class="form-control" value="${param.monthYear}">
                </div>
                <button type="submit" class="btn btn-primary">Run Analysis</button>
                <a href="${pageContext.request.contextPath}/admin/reports/utilisation" class="btn btn-outline">Current Month</a>
            </div>
        </form>

        <div class="util-grid animate-fade-in" style="animation-delay: 0.3s;">
            <c:forEach var="item" items="${utilisation}">
                <div class="card util-card" style="border-radius: var(--radius); transition: all 0.3s;">
                    <div style="display: flex; justify-content: space-between; align-items: start;">
                        <div>
                            <h3 style="margin: 0; font-size: 1.125rem; font-weight: 700;">${item.clinicName}</h3>
                            <span class="badge badge-info" style="margin-top: 0.5rem; padding: 0.25rem 0.75rem;">${item.serviceName}</span>
                        </div>
                        <div style="text-align: right;">
                            <div style="font-size: 1.75rem; font-weight: 800; color: var(--primary-color); letter-spacing: -0.025em;">${item.rate}</div>
                            <div style="font-size: 0.7rem; color: var(--text-muted); text-transform: uppercase; font-weight: 700; letter-spacing: 0.05em;">Efficiency</div>
                        </div>
                    </div>
                    
                    <div class="progress-container" style="background: #f1f5f9; height: 10px;">
                        <div class="progress-bar" style="width: ${item.rate}; background: linear-gradient(90deg, var(--primary-color), #818cf8);"></div>
                    </div>
                    
                    <div style="display: flex; justify-content: space-between; font-size: 0.8125rem; margin-top: 0.5rem;">
                        <span style="color: var(--text-muted);">Capacity: <strong>${item.bookedSlots}</strong> / ${item.totalSlots}</span>
                        <span style="font-weight: 600; color: ${item.bookedSlots >= item.totalSlots ? 'var(--danger-color)' : 'var(--success-color)'};">
                            ${item.totalSlots - item.bookedSlots} Left
                        </span>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty utilisation}">
            <div class="card" style="padding: 4rem; text-align: center; color: var(--text-muted);">
                No capacity data found for the selected period. 
                <p style="font-size: 0.875rem;">Please ensure schedules are generated in <i>Clinic Management</i>.</p>
            </div>
        </c:if>
    </div>
</body>
</html>
