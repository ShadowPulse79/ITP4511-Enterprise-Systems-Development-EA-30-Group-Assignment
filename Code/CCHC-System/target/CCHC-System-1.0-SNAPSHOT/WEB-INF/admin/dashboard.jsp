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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Portal - CCHC System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/index.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .apple-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo-box {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            font-size: 17px;
            color: var(--text-main);
        }
        .user-nav {
            display: flex;
            align-items: center;
            gap: 24px;
        }
        .notification-btn {
            position: relative;
            cursor: pointer;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: background 0.2s;
        }
        .notification-btn:hover { background: rgba(0,0,0,0.05); }
        .badge-dot {
            position: absolute;
            top: 6px;
            right: 6px;
            width: 8px;
            height: 8px;
            background: var(--danger-color);
            border: 2px solid white;
            border-radius: 50%;
        }
        .hero-section {
            padding: 60px 0 40px;
        }
        .hero-title {
            font-size: 48px;
            font-weight: 700;
            letter-spacing: -0.015em;
            margin: 0;
            background: linear-gradient(180deg, #1d1d1f 0%, #434345 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .hero-subtitle {
            font-size: 21px;
            color: var(--text-muted);
            margin-top: 12px;
            max-width: 600px;
        }
        .btn-signout {
            background: #1d1d1f;
            color: white;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-signout:hover { background: #434345; transform: scale(1.05); }

        /* Apple Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: var(--card-background);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            padding: 24px;
            border-radius: var(--radius-apple);
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-apple);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .stat-card:hover {
            transform: scale(1.02);
            box-shadow: var(--shadow-apple-hover);
        }
        .stat-label {
            font-size: 12px;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-main);
        }
        .stat-trend {
            font-size: 13px;
            margin-top: 12px;
            font-weight: 500;
        }

        .nav-hub {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }
        .hub-card {
            background: white;
            padding: 32px;
            border-radius: 28px;
            text-decoration: none;
            transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1);
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            gap: 16px;
            box-shadow: var(--shadow-apple);
        }
        .hub-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-apple-hover);
        }
        .hub-icon {
            font-size: 2.5rem;
            background: #f5f5f7;
            width: 72px;
            height: 72px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 20px;
            transition: all 0.3s;
        }
        .hub-card:hover .hub-icon {
            background: var(--primary-color);
            color: white;
        }
        .hub-title { font-size: 21px; font-weight: 600; color: #1d1d1f; }
        .hub-desc { font-size: 14px; color: #86868b; line-height: 1.5; }

        @keyframes appleFadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-apple { animation: appleFadeIn 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .admin-container { max-width: 1080px; margin: 40px auto; padding: 0 20px; }
    </style>
</head>
<body>

<nav class="apple-nav">
    <div class="logo-box">
        <span style="font-size: 24px;"></span>
        <span>CCHC Admin</span>
    </div>
    <div class="user-nav">
        <div class="notification-btn" onclick="location.href='${pageContext.request.contextPath}/notification/list'">
            <span style="font-size: 18px;">🔔</span>
            <% if (unreadCount > 0) { %>
                <div class="badge-dot"></div>
            <% } %>
        </div>
        <div style="text-align: right;">
            <div style="font-size: 13px; font-weight: 600;"><%= fullName != null ? fullName : "Administrator" %></div>
            <div style="font-size: 11px; color: var(--text-muted);">Systems Manager</div>
        </div>
        <a href="${pageContext.request.contextPath}/user/logout" class="btn-signout">Sign Out</a>
    </div>
</nav>

<div class="admin-container">
    <header class="hero-section animate-apple">
        <div style="display: flex; justify-content: space-between; align-items: flex-end;">
            <div>
                <h1 class="hero-title" id="greeting">Hello, Admin.</h1>
                <p class="hero-subtitle">
                    Monitor clinic performance and manage your health network from one unified workspace.
                </p>
            </div>
            <div style="text-align: right; color: var(--text-muted); padding-bottom: 8px;">
                <div id="live-clock" style="font-size: 24px; font-weight: 600; color: var(--text-main);">00:00:00</div>
                <div style="font-size: 13px; font-weight: 500;"><%= new java.text.SimpleDateFormat("EEEE, d MMMM").format(new java.util.Date()) %></div>
            </div>
        </div>
    </header>

    <div class="stats-grid animate-apple" style="animation-delay: 0.1s;">
        <div class="stat-card">
            <div class="stat-label"><span>📅</span> Today's Bookings</div>
            <div class="stat-value">${todayBookings != null ? todayBookings : 0}</div>
            <div class="stat-trend" style="color: var(--text-muted);">Real-time count</div>
        </div>
        <div class="stat-card">
            <div class="stat-label"><span>🏥</span> Operational Clinics</div>
            <div class="stat-value">${clinicCount != null ? clinicCount : 0}</div>
            <div class="stat-trend" style="color: var(--text-muted);">Active facilities</div>
        </div>
        <div class="stat-card" onclick="location.href='${pageContext.request.contextPath}/notification/list'" style="cursor:pointer">
            <div class="stat-label"><span>🔔</span> System Alerts</div>
            <div class="stat-value"><%= unreadCount %></div>
            <div class="stat-trend" style="color: <%= unreadCount > 0 ? "var(--warning-color)" : "var(--success-color)" %>">
                <%= unreadCount > 0 ? "Action required" : "No new alerts" %>
            </div>
        </div>
    </div>

    <h2 style="font-size: 24px; font-weight: 600; margin: 48px 0 24px;" class="animate-apple" style="animation-delay: 0.2s;">Management</h2>
    
    <div class="nav-hub animate-apple" style="animation-delay: 0.3s;">
        <a href="${pageContext.request.contextPath}/admin/users" class="hub-card">
            <div class="hub-icon">👥</div>
            <div class="hub-title">User Accounts</div>
            <div class="hub-desc">Manage credentials and access levels for staff and patients.</div>
        </a>
        <a href="${pageContext.request.contextPath}/admin/clinics" class="hub-card">
            <div class="hub-icon">🏥</div>
            <div class="hub-title">Clinic Network</div>
            <div class="hub-desc">Oversee branch operations, schedules, and service capacity.</div>
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports" class="hub-card">
            <div class="hub-icon">📊</div>
            <div class="hub-title">Insights</div>
            <div class="hub-desc">Analyze network trends, utilization rates, and data metrics.</div>
        </a>
        <a href="${pageContext.request.contextPath}/notification/list" class="hub-card">
            <div class="hub-icon">✉️</div>
            <div class="hub-title">Messaging</div>
            <div class="hub-desc">Send network-wide broadcasts and view system logs.</div>
        </a>
    </div>
</div>

<script>
    function updateDashboard() {
        const now = new Date();
        const hours = now.getHours();
        const greetingEl = document.getElementById('greeting');
        const clockEl = document.getElementById('live-clock');
        clockEl.textContent = now.toLocaleTimeString('en-US', { hour12: false });
        let greeting = hours < 12 ? "Good morning, Admin." : (hours < 18 ? "Good afternoon, Admin." : "Good evening, Admin.");
        if (greetingEl.textContent !== greeting) greetingEl.textContent = greeting;
    }
    setInterval(updateDashboard, 1000);
    updateDashboard();

    function refreshUnreadCount() {
        fetch('${pageContext.request.contextPath}/notification/count')
            .then(response => response.json())
            .then(data => {
                const navBtn = document.querySelector('.notification-btn');
                let dot = navBtn.querySelector('.badge-dot');
                if (data.count > 0) {
                    if (!dot) {
                        dot = document.createElement('div');
                        dot.className = 'badge-dot';
                        navBtn.appendChild(dot);
                    }
                } else if (dot) dot.remove();
            });
    }
    setInterval(refreshUnreadCount, 30000);
</script>
</body>
</html>

</body>
</html>
