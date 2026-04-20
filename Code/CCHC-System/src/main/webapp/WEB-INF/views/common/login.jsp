<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登录 - CCHC诊所系统</title>
</head>
<body>
<h2>CCHC 社区诊所系统 - 登录</h2>

<%-- 显示错误信息 --%>
<%
    String error = (String) request.getAttribute("error");
    if (error != null && !error.isEmpty()) {
%>
<div style="color: red; margin-bottom: 10px;">
    <%= error %>
</div>
<%
    }
%>

<%-- 显示成功信息 --%>
<%
    String message = (String) request.getAttribute("message");
    if (message != null && !message.isEmpty()) {
%>
<div style="color: green; margin-bottom: 10px;">
    <%= message %>
</div>
<%
    }
%>

<form action="${pageContext.request.contextPath}/user/login" method="post">
    <div style="margin-bottom: 10px;">
        <label>用户名：</label>
        <input type="text" name="username" required>
    </div>
    <div style="margin-bottom: 10px;">
        <label>密码：</label>
        <input type="password" name="password" required>
    </div>
    <button type="submit">登录</button>
</form>

<div style="margin-top: 20px; font-size: 12px; color: #666;">
    <p>测试账号：</p>
    <p>管理员：admin / password123</p>
    <p>患者：patient / password123</p>
    <p>员工：staff_cw / password123</p>
</div>
</body>
</html>