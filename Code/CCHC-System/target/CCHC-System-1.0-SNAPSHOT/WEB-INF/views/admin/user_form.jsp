<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>${user == null ? 'Create User' : 'Edit User'}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input[type="text"], input[type="password"], input[type="email"], select { width: 300px; padding: 8px; }
        .btn { padding: 8px 15px; background-color: #28a745; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <h2>${user == null ? 'Create New User' : 'Edit User'}</h2>
    <a href="${pageContext.request.contextPath}/admin/users">Back to User List</a>
    <hr/>
    <form action="${pageContext.request.contextPath}/admin/user/${user == null ? 'create' : 'edit'}" method="post">
        <c:if test="${user != null}">
            <input type="hidden" name="id" value="${user.id}">
        </c:if>
        
        <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" value="${user.username}" ${user != null ? 'readonly' : 'required'}>
        </div>
        
        <c:if test="${user == null}">
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required minlength="4">
            </div>
        </c:if>
        
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="fullName" value="${user.fullName}" required>
        </div>
        
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" value="${user.email}">
        </div>
        
        <div class="form-group">
            <label>Phone</label>
            <input type="text" name="phone" value="${user.phone}">
        </div>
        
        <div class="form-group">
            <label>Role</label>
            <select name="role">
                <option value="1" ${user.role == 1 ? 'selected' : ''}>Patient</option>
                <option value="2" ${user.role == 2 ? 'selected' : ''}>Clinic Staff</option>
                <option value="3" ${user.role == 3 ? 'selected' : ''}>Administrator</option>
            </select>
        </div>
        
        <div class="form-group">
            <label>Clinic ID (For Staff)</label>
            <input type="number" name="clinicId" value="${user.clinicId}">
        </div>
        
        <div class="form-group">
            <label>
                <input type="checkbox" name="isActive" value="true" ${user == null || user.active ? 'checked' : ''}>
                Is Active
            </label>
        </div>
        
        <button type="submit" class="btn">Save</button>
    </form>
</body>
</html>
