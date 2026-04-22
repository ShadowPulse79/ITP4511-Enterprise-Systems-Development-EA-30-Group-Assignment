<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics Hub - CCHC System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/index.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .apple-nav {
            background: rgba(255, 255, 255, 0.72);
            backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border-bottom: 1px solid var(--border-color);
            height: 52px;
            display: flex;
            align-items: center;
            padding: 0 22px;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        .back-btn {
            text-decoration: none;
            color: var(--primary-color);
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 4px;
            transition: opacity 0.2s;
        }
        .back-btn:hover { opacity: 0.7; }
        
        .report-header {
            padding: 80px 0 60px;
            text-align: center;
        }
        .report-title {
            font-size: 56px;
            font-weight: 800;
            letter-spacing: -0.02em;
            margin: 0;
            background: linear-gradient(180deg, #1d1d1f 0%, #434345 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .report-subtitle {
            font-size: 24px;
            color: var(--text-muted);
            margin-top: 16px;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Interactive Report Cards */
        .report-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 32px;
            margin-top: 20px;
        }
        
        .report-card {
            background: white;
            border-radius: 32px;
            padding: 48px 32px;
            text-decoration: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            transition: all 0.6s cubic-bezier(0.16, 1, 0.3, 1);
            border: 1px solid transparent;
            box-shadow: var(--shadow-apple);
            position: relative;
            overflow: hidden;
        }

        .report-card:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: var(--shadow-apple-hover);
            border-color: rgba(0, 113, 227, 0.2);
        }

        .icon-circle {
            width: 100px;
            height: 100px;
            background: #f5f5f7;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 42px;
            margin-bottom: 24px;
            transition: all 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
        }

        .report-card:hover .icon-circle {
            background: var(--primary-color);
            color: white;
            transform: rotateY(180deg) scale(1.1);
        }

        .card-title {
            font-size: 24px;
            font-weight: 700;
            color: #1d1d1f;
            margin-bottom: 12px;
        }

        .card-desc {
            font-size: 16px;
            color: #86868b;
            line-height: 1.5;
            margin-bottom: 24px;
        }

        .arrow-link {
            font-size: 17px;
            font-weight: 600;
            color: var(--primary-color);
            display: flex;
            align-items: center;
            gap: 4px;
            opacity: 0;
            transform: translateX(-10px);
            transition: all 0.3s ease;
        }

        .report-card:hover .arrow-link {
            opacity: 1;
            transform: translateX(0);
        }

        @media (max-width: 992px) {
            .report-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <nav class="apple-nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-btn">
            <span>‹</span> Dashboard
        </a>
    </nav>

    <div class="admin-container">
        <header class="report-header animate-apple">
            <h1 class="report-title">Analytics</h1>
            <p class="report-subtitle">
                Explore deep insights into your health network's operational performance and patient outcomes.
            </p>
        </header>

        <div class="report-grid animate-apple" style="animation-delay: 0.1s;">
            <a href="${pageContext.request.contextPath}/admin/reports/appointments" class="report-card">
                <div class="icon-circle">📅</div>
                <div class="card-title">Bookings</div>
                <div class="card-desc">Review every patient interaction with comprehensive filtering and status logs.</div>
                <div class="arrow-link">View Report <span>›</span></div>
            </a>

            <a href="${pageContext.request.contextPath}/admin/reports/utilisation" class="report-card">
                <div class="icon-circle">⚡</div>
                <div class="card-title">Utilization</div>
                <div class="card-desc">Analyze resource allocation and booking-to-capacity ratios across all clinics.</div>
                <div class="arrow-link">Analyze Data <span>›</span></div>
            </a>

            <a href="${pageContext.request.contextPath}/admin/reports/noshow" class="report-card">
                <div class="icon-circle">⚠️</div>
                <div class="card-title">Attendance</div>
                <div class="card-desc">Identify no-show patterns and optimize scheduling to minimize operational loss.</div>
                <div class="arrow-link">Track Trends <span>›</span></div>
            </a>
        </div>

        <div style="margin-top: 80px; text-align: center;" class="animate-apple" style="animation-delay: 0.3s;">
            <p style="color: var(--text-muted); font-size: 14px; font-weight: 500;">
                All data is synchronized in real-time with the CCHC core network.
            </p>
        </div>
    </div>
</body>
</html>
