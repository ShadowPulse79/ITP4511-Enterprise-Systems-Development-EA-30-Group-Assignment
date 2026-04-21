<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.leese.cchcsystem.service.NotificationService" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String fullName = (String) session.getAttribute("fullName");

    NotificationService notificationService = new NotificationService();
    int unreadCount = 0;
    if (userId != null) {
        unreadCount = notificationService.getUnreadCount(userId);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员首页 - CCHC诊所系统</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Microsoft YaHei', Arial, sans-serif; background: #f5f5f5; }
        .navbar {
            background: linear-gradient(135deg, #c0392b 0%, #e74c3c 100%);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .logo { font-size: 20px; font-weight: bold; }
        .nav-right { display: flex; align-items: center; gap: 20px; }
        .notification-icon { position: relative; cursor: pointer; }
        .notification-icon a { color: white; text-decoration: none; font-size: 22px; }
        .notification-badge {
            position: absolute; top: -8px; right: -12px;
            background: #2c3e50; color: white; border-radius: 50%;
            padding: 2px 6px; font-size: 10px; font-weight: bold;
            min-width: 18px; text-align: center;
        }
        .logout-btn {
            color: white; text-decoration: none;
            background: rgba(255,255,255,0.2);
            padding: 5px 12px; border-radius: 5px; transition: background 0.3s;
        }
        .logout-btn:hover { background: rgba(255,255,255,0.3); }
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .welcome-card {
            background: white; border-radius: 10px; padding: 25px;
            margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .welcome-card h2 { color: #333; margin-bottom: 10px; }
        .welcome-card p { color: #666; }
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px; margin-top: 20px;
        }
        .feature-card {
            background: white; border-radius: 10px; padding: 20px;
            text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.2s; cursor: pointer;
        }
        .feature-card:hover { transform: translateY(-3px); box-shadow: 0 5px 15px rgba(0,0,0,0.15); }
        .feature-icon { font-size: 40px; margin-bottom: 10px; }
        .feature-title { font-size: 18px; font-weight: bold; color: #333; margin-bottom: 5px; }
        .feature-desc { font-size: 13px; color: #999; }
        .status-badge {
            display: inline-block; background: #c0392b; color: white;
            padding: 3px 10px; border-radius: 20px; font-size: 12px; margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">🏥 CCHC 社区诊所系统（管理员）</div>
    <div class="nav-right">
        <div class="notification-icon">
            <a href="${pageContext.request.contextPath}/notification/list">🔔</a>
            <% if (unreadCount > 0) { %>
            <span class="notification-badge"><%= unreadCount %></span>
            <% } %>
        </div>
        <a href="${pageContext.request.contextPath}/user/logout" class="logout-btn">登出</a>
    </div>
</div>

<div class="container">
    <div class="welcome-card">
        <h2>欢迎回来，<%= fullName != null ? fullName : "管理员" %>！</h2>
        <p>欢迎使用 CCHC 社区诊所管理后台，您可以在这里管理用户、诊所和系统设置。</p>
        <% if (unreadCount > 0) { %>
        <div class="status-badge">🔔 您有 <%= unreadCount %> 条未读通知</div>
        <% } %>
    </div>

    <h3 style="margin-bottom: 15px; color: #333;">系统管理</h3>
    <div class="feature-grid">
        <div class="feature-card" onclick="location.href='${pageContext.request.contextPath}/admin/users'">
            <div class="feature-icon">👥</div>
            <div class="feature-title">用户管理</div>
            <div class="feature-desc">管理所有用户账号和权限</div>
        </div>
        <div class="feature-card" onclick="location.href='${pageContext.request.contextPath}/admin/clinics'">
            <div class="feature-icon">🏥</div>
            <div class="feature-title">诊所管理</div>
            <div class="feature-desc">管理诊所信息和排班</div>
        </div>
        <div class="feature-card" onclick="location.href='${pageContext.request.contextPath}/admin/reports'">
            <div class="feature-icon">📊</div>
            <div class="feature-title">统计报表</div>
            <div class="feature-desc">查看系统运营数据</div>
        </div>
        <div class="feature-card" onclick="location.href='${pageContext.request.contextPath}/notification/list'">
            <div class="feature-icon">🔔</div>
            <div class="feature-title">系统通知</div>
            <div class="feature-desc">
                查看系统通知
                <% if (unreadCount > 0) { %>
                <span style="color: #e74c3c;">(<%= unreadCount %>)</span>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
    function refreshUnreadCount() {
        fetch('${pageContext.request.contextPath}/notification/count')
            .then(response => response.json())
            .then(data => {
                const badge = document.querySelector('.notification-badge');
                if (data.count > 0) {
                    if (badge) { badge.textContent = data.count; }
                    else {
                        const icon = document.querySelector('.notification-icon');
                        const newBadge = document.createElement('span');
                        newBadge.className = 'notification-badge';
                        newBadge.textContent = data.count;
                        icon.appendChild(newBadge);
                    }
                } else { if (badge) badge.remove(); }
            })
            .catch(err => console.log('刷新通知数失败:', err));
    }
    setInterval(refreshUnreadCount, 30000);
</script>
</body>
</html>
