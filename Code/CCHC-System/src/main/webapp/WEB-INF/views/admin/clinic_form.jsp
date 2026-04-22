<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${clinic == null ? 'Add Clinic' : 'Edit Clinic'} - CCHC System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/index.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="admin-container">
        <header class="page-header" style="max-width: 600px; margin: 0 auto 2rem;">
            <div>
                <h1 class="page-title">${clinic == null ? 'Add New Clinic' : 'Edit Clinic'}</h1>
                <p style="color: var(--text-muted); margin-top: 0.5rem;">Configure general settings for this clinic branch.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/clinics" class="btn btn-outline">Back</a>
        </header>

        <div class="card form-container" style="padding: 2rem;">
            <form action="${pageContext.request.contextPath}/admin/clinic/${clinic == null ? 'create' : 'edit'}" method="post">
                <c:if test="${clinic != null}">
                    <input type="hidden" name="id" value="${clinic.id}">
                </c:if>

                <div class="form-group">
                    <label class="form-label">Clinic Name</label>
                    <input type="text" name="name" class="form-control" value="${clinic.name}" required placeholder="e.g. Central Medical Center">
                </div>

                <div class="form-group">
                    <label class="form-label">Location / Address</label>
                    <input type="text" name="location" class="form-control" value="${clinic.location}" required placeholder="Detailed address">
                </div>

                <div class="form-group" style="padding-top: 1rem; border-top: 1px solid var(--border-color);">
                    <label class="form-check">
                        <input type="checkbox" name="walkInEnabled" class="checkbox" value="true" ${clinic == null || clinic.walkInEnabled ? 'checked' : ''}>
                        <span style="font-weight: 500;">Enable Walk-in Queue</span>
                    </label>
                    <p style="color: var(--text-muted); font-size: 0.8125rem; margin-top: 0.25rem; margin-left: 1.5rem;">
                        If enabled, patients can get a queue number on-site without prior appointment.
                    </p>
                </div>

                <div style="margin-top: 2rem; display: flex; gap: 1rem;">
                    <button type="submit" class="btn btn-primary" style="flex: 1; justify-content: center; padding: 0.75rem;">
                        Save Clinic
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/clinics" class="btn btn-outline" style="flex: 1; justify-content: center; padding: 0.75rem;">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
