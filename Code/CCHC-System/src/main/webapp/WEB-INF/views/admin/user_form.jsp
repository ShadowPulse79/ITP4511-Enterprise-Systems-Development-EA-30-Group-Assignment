<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${user == null ? 'Create User' : 'Edit User'} - CCHC System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/index.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="admin-container">
        <header class="page-header" style="max-width: 600px; margin: 0 auto 2rem;">
            <div>
                <h1 class="page-title">${user == null ? 'Create New User' : 'Edit User'}</h1>
                <p style="color: var(--text-muted); margin-top: 0.5rem;">
                    ${user == null ? 'Register a new account for the system.' : 'Modify account details and permissions for @'.concat(user.username)}
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline">Back to List</a>
        </header>

        <div class="card form-container">
            <div style="padding: 2rem;">
                <form action="${pageContext.request.contextPath}/admin/user/${user == null ? 'create' : 'edit'}" method="post">
                    <c:if test="${user != null}">
                        <input type="hidden" name="id" value="${user.id}">
                    </c:if>
                    
                    <div class="form-group">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-control" value="${user.username}" 
                               ${user != null ? 'readonly style="background-color: #f1f5f9; cursor: not-allowed;"' : 'required placeholder="Enter unique username"'}>
                        <c:if test="${user != null}">
                            <small style="color: var(--text-muted); display: block; margin-top: 0.25rem;">Username cannot be changed after creation.</small>
                        </c:if>
                    </div>
                    
                    <c:if test="${user == null}">
                        <div class="form-group">
                            <label class="form-label">Password</label>
                            <input type="password" name="password" class="form-control" required minlength="4" placeholder="Minimum 4 characters">
                        </div>
                    </c:if>
                    
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="fullName" class="form-control" value="${user.fullName}" required placeholder="Real name">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Role</label>
                            <select name="role" class="form-control">
                                <option value="1" ${user.role == 1 ? 'selected' : ''}>Patient</option>
                                <option value="2" ${user.role == 2 ? 'selected' : ''}>Clinic Staff</option>
                                <option value="3" ${user.role == 3 ? 'selected' : ''}>Administrator</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <input type="email" name="email" class="form-control" value="${user.email}" placeholder="example@domain.com">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Phone Number</label>
                        <input type="text" name="phone" class="form-control" value="${user.phone}" placeholder="+852 ...">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">Clinic Assignment (Staff Only)</label>
                        <input type="number" name="clinicId" class="form-control" value="${user.clinicId}" placeholder="Enter clinic ID if applicable">
                    </div>
                    
                    <div class="form-group" style="padding-top: 0.5rem; border-top: 1px solid var(--border-color);">
                        <label class="form-check">
                            <input type="checkbox" name="isActive" class="checkbox" value="true" ${user == null || user.active ? 'checked' : ''}>
                            <span style="font-weight: 500;">Account Status: Active</span>
                        </label>
                        <p style="color: var(--text-muted); font-size: 0.8125rem; margin-top: 0.25rem; margin-left: 1.5rem;">
                            If disabled, the user will not be able to log in to the system.
                        </p>
                    </div>
                    
                    <div style="margin-top: 2rem; display: flex; gap: 1rem;">
                        <button type="submit" class="btn btn-primary" style="flex: 1; justify-content: center; padding: 0.75rem;">
                            ${user == null ? 'Create User' : 'Save Changes'}
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline" style="flex: 1; justify-content: center; padding: 0.75rem;">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
