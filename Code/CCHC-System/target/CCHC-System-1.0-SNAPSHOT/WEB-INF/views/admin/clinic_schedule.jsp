<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Schedule - ${clinic.name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/index.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .schedule-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1.5rem;
        }
        .slot-card {
            padding: 1rem;
            background: #fff;
            border: 1px solid var(--border-color);
            border-radius: var(--radius);
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .slot-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background-color: #fff;
            padding: 2rem;
            border-radius: var(--radius);
            width: 100%;
            max-width: 400px;
            box-shadow: var(--shadow-lg);
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <header class="page-header">
            <div>
                <h1 class="page-title">${clinic.name} - Scheduling</h1>
                <p style="color: var(--text-muted); margin-top: 0.5rem;">Configure service slots and capacity for <strong>${selectedDate}</strong>.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/clinics" class="btn btn-outline">Back to Clinics</a>
        </header>

        <div class="card" style="padding: 1.5rem; margin-bottom: 2rem;">
            <form action="${pageContext.request.contextPath}/admin/clinic/schedule" method="get" style="display: flex; gap: 1rem; align-items: end;">
                <input type="hidden" name="id" value="${clinic.id}">
                <div class="form-group" style="margin-bottom: 0; flex: 1;">
                    <label class="form-label">Select Date</label>
                    <input type="date" name="date" class="form-control" value="${selectedDate}" onchange="this.form.submit()">
                </div>
                <div style="flex: 2;"></div>
            </form>
        </div>

        <c:if test="${empty schedules}">
            <div class="card" style="padding: 3rem; text-align: center;">
                <div style="font-size: 3rem; margin-bottom: 1rem;">📅</div>
                <h3 style="margin-bottom: 1rem;">No schedule for this date</h3>
                <p style="color: var(--text-muted); margin-bottom: 1.5rem;">Would you like to generate the default slots for this clinic?</p>
                <form action="${pageContext.request.contextPath}/admin/clinic/schedule" method="post">
                    <input type="hidden" name="id" value="${clinic.id}">
                    <input type="hidden" name="date" value="${selectedDate}">
                    <button type="submit" class="btn btn-primary">Generate Default Slots</button>
                </form>
            </div>
        </c:if>

        <c:if test="${not empty schedules}">
            <div class="schedule-grid">
                <c:forEach var="s" items="${schedules}">
                    <div class="slot-card" onclick="openEditModal('${s.id}', '${s.serviceName}', '${s.startTime}', '${s.endTime}', '${s.maxQuota}', ${s.available})">
                        <div style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; margin-bottom: 0.25rem;">
                            ${s.serviceName}
                        </div>
                        <div style="font-size: 1.125rem; font-weight: 700; color: var(--text-main);">
                            ${s.startTime} - ${s.endTime}
                        </div>
                        <div style="margin-top: 1rem; display: flex; justify-content: space-between; align-items: center;">
                            <span class="badge badge-info">Quota: ${s.maxQuota}</span>
                            <c:choose>
                                <c:when test="${s.available}">
                                    <span style="color: var(--success-color); font-size: 0.75rem; font-weight: 600;">● Available</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: var(--danger-color); font-size: 0.75rem; font-weight: 600;">● Unavailable</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>

    <!-- Edit Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <h3 id="modalTitle" style="margin-bottom: 1.5rem;">Edit Slot</h3>
            <form action="${pageContext.request.contextPath}/admin/clinic/schedule/update" method="post">
                <input type="hidden" name="scheduleId" id="modalScheduleId">
                <div class="form-group">
                    <label class="form-label">Maximum Quota</label>
                    <input type="number" name="maxQuota" id="modalQuota" class="form-control" required min="1">
                </div>
                <div class="form-group">
                    <label class="form-check">
                        <input type="checkbox" name="isAvailable" id="modalAvailable" value="true" class="checkbox">
                        <span style="font-weight: 500;">Is Available</span>
                    </label>
                </div>
                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                    <button type="submit" class="btn btn-primary" style="flex: 1;">Save Changes</button>
                    <button type="button" class="btn btn-outline" style="flex: 1;" onclick="closeEditModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openEditModal(id, service, start, end, quota, available) {
            document.getElementById('modalScheduleId').value = id;
            document.getElementById('modalTitle').innerText = service + ' (' + start + ' - ' + end + ')';
            document.getElementById('modalQuota').value = quota;
            document.getElementById('modalAvailable').checked = available;
            document.getElementById('editModal').style.display = 'flex';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById('editModal')) {
                closeEditModal();
            }
        }
    </script>
</body>
</html>
