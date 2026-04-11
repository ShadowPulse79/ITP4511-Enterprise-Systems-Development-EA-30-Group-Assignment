<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>患者首页</title>
</head>
<body>
<h2>患者仪表盘</h2>
<p>欢迎，<%= session.getAttribute("fullName") %>！</p>
<p>登录成功！✅</p>
<a href="${pageContext.request.contextPath}/user/logout">登出</a>
</body>
</html>