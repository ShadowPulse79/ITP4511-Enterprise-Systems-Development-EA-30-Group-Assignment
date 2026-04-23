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
                <p style="color: var(--text-muted); margin-top: 0.5rem; display: flex; align-items: center; gap: 0.5rem;">
                    <span class="badge" style="background: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; font-size: 0.7rem;">Simplified Mode</span>
                    AM/PM service structure for <strong>${selectedDate}</strong>.
                </p>
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
            <div class="animate-fade-in" style="animation-delay: 0.3s;">
                <c:set var="currentService" value="" />
                <c:forEach var="s" items="${schedules}" varStatus="status">
                    <c:if test="${s.serviceName != currentService}">
                        <c:if test="${not empty currentService}">
                                </div> <!-- Close previous grid -->
                            </div> <!-- Close previous group -->
                        </c:if>
                        <c:set var="currentService" value="${s.serviceName}" />
                        <div class="service-section" style="margin-bottom: 2.5rem;">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 1px solid var(--border-color);">
                                <h3 style="margin: 0; font-size: 1.125rem; font-weight: 700; color: var(--primary-color); display: flex; align-items: center; gap: 0.75rem;">
                                    <span style="display: inline-block; width: 4px; height: 1.25rem; background: var(--primary-color); border-radius: 2px;"></span>
                                    ${s.serviceName}
                                </h3>
                                <span style="font-size: 0.75rem; color: var(--text-muted); font-weight: 500; text-transform: uppercase; letter-spacing: 0.05em;">Service Blocks</span>
                            </div>
                            <div class="schedule-grid" style="grid-template-columns: repeat(2, 1fr); max-width: 900px; margin-top: 1rem;">
                    </c:if>
                    
                    <div class="slot-card" onclick="openEditModal('${s.id}', '${s.serviceName}', '${s.startTime}', '${s.endTime}', '${s.maxQuota}', ${s.available})">
                        <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 0.5rem;">
                            <c:choose>
                                <c:when test="${s.startTime.toString().startsWith('09')}">
                                    <span class="badge" style="background: #f0f9ff; color: #0369a1; border: 1px solid #bae6fd; font-weight: 700;">AM SESSION</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge" style="background: #fffbeb; color: #92400e; border: 1px solid #fde68a; font-weight: 700;">PM SESSION</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div style="font-size: 1.25rem; font-weight: 800; color: var(--text-main); letter-spacing: -0.02em;">
                            ${s.startTime.toString().substring(0, 5)} - ${s.endTime.toString().substring(0, 5)}
                        </div>
                        <div style="margin-top: 1.25rem; display: flex; justify-content: space-between; align-items: center; padding-top: 0.75rem; border-top: 1px dashed var(--border-color);">
                            <span style="font-size: 0.8125rem; color: var(--text-muted);">Quota: <strong>${s.maxQuota}</strong></span>
                            <c:choose>
                                <c:when test="${s.available}">
                                    <span style="color: var(--success-color); font-size: 0.75rem; font-weight: 700; display: flex; align-items: center; gap: 0.25rem;">
                                        <span style="width: 6px; height: 6px; background: var(--success-color); border-radius: 50%;"></span> ACTIVE
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: var(--danger-color); font-size: 0.75rem; font-weight: 700; display: flex; align-items: center; gap: 0.25rem;">
                                        <span style="width: 6px; height: 6px; background: var(--danger-color); border-radius: 50%;"></span> DISABLED
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <c:if test="${status.last}">
                            </div> <!-- Close last grid -->
                        </div> <!-- Close last group -->
                    </c:if>
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
