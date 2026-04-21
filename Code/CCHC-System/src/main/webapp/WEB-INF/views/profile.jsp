<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.leese.cchcsystem.model.entity.User" %>
<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user/login");
        return;
    }
    String[] roleNames = {"", "患者", "診所員工", "系統管理員"};
    String roleName = (user.getRole() >= 1 && user.getRole() <= 3) ? roleNames[user.getRole()] : "未知";
    String[] roleColors = {"", "#0d9488", "#1a73e8", "#7c3aed"};
    String roleColor = (user.getRole() >= 1 && user.getRole() <= 3) ? roleColors[user.getRole()] : "#888";

    String dashboardUrl;
    switch (user.getRole()) {
        case 2:  dashboardUrl = request.getContextPath() + "/staff/dashboard";  break;
        case 3:  dashboardUrl = request.getContextPath() + "/admin/dashboard";  break;
        default: dashboardUrl = request.getContextPath() + "/patient/dashboard";
    }

    // 訊息
    String infoMsg  = (String) request.getAttribute("message");
    String infoErr  = (String) request.getAttribute("error");
    String pwdMsg   = (String) request.getAttribute("pwdMessage");
    String pwdErr   = (String) request.getAttribute("pwdError");
%>
<!DOCTYPE html>
<html lang="zh-HK">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>個人資料 - CCHC 診所系統</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', 'PingFang HK', 'Microsoft YaHei', sans-serif;
            background: #f0f4f9;
            min-height: 100vh;
        }

        /* ===== 頂部導航 ===== */
        .navbar {
            background: linear-gradient(90deg, #0f4c81, #1a73e8);
            color: #fff;
            padding: 0 32px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 12px rgba(15,76,129,0.25);
            position: sticky; top: 0; z-index: 100;
        }
        .nav-brand {
            display: flex; align-items: center; gap: 10px;
            font-size: 1.1rem; font-weight: 700; letter-spacing: 1px;
        }
        .nav-brand svg { flex-shrink: 0; }
        .nav-right { display: flex; align-items: center; gap: 16px; }
        .nav-link {
            color: rgba(255,255,255,0.85);
            text-decoration: none; font-size: 0.875rem;
            padding: 6px 14px; border-radius: 8px;
            transition: background 0.2s, color 0.2s;
            display: flex; align-items: center; gap: 6px;
        }
        .nav-link:hover { background: rgba(255,255,255,0.15); color: #fff; }
        .nav-link.logout { background: rgba(255,255,255,0.12); }
        .nav-link.logout:hover { background: rgba(255,255,255,0.22); }

        /* ===== 頁面主體 ===== */
        .page-wrap {
            max-width: 900px;
            margin: 36px auto;
            padding: 0 20px 60px;
        }

        /* 頁首麵包屑 */
        .breadcrumb {
            display: flex; align-items: center; gap: 6px;
            font-size: 0.82rem; color: #8a9bb5; margin-bottom: 24px;
        }
        .breadcrumb a { color: #1a73e8; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span { color: #b0bdd0; }

        /* ===== 用戶卡片（頭部） ===== */
        .profile-header {
            background: #fff;
            border-radius: 18px;
            padding: 32px 36px;
            margin-bottom: 24px;
            box-shadow: 0 2px 16px rgba(15,76,129,0.08);
            display: flex;
            align-items: center;
            gap: 28px;
        }
        .avatar {
            width: 82px; height: 82px;
            border-radius: 50%;
            background: linear-gradient(135deg, #1a73e8, #0d9488);
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-size: 2rem; font-weight: 700;
            flex-shrink: 0;
            box-shadow: 0 4px 16px rgba(26,115,232,0.3);
            user-select: none;
        }
        .profile-info h1 {
            font-size: 1.4rem; font-weight: 700;
            color: #0f2d55; margin-bottom: 6px;
        }
        .role-badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 12px; border-radius: 20px;
            font-size: 0.78rem; font-weight: 600;
            color: #fff; margin-bottom: 8px;
        }
        .profile-meta {
            font-size: 0.82rem; color: #8a9bb5;
            display: flex; gap: 18px; flex-wrap: wrap;
        }
        .profile-meta span { display: flex; align-items: center; gap: 5px; }

        /* ===== 提示訊息 ===== */
        .alert {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 12px 16px; border-radius: 10px;
            font-size: 0.875rem; margin-bottom: 20px;
            animation: slideIn 0.3s ease;
        }
        .alert-success { background: #f0fff4; border: 1px solid #b3f0c8; color: #1a7a3f; }
        .alert-error   { background: #fff0f0; border: 1px solid #ffc5c5; color: #d93025; }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-8px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ===== 卡片通用 ===== */
        .card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 16px rgba(15,76,129,0.08);
            margin-bottom: 24px;
            overflow: hidden;
        }
        .card-header {
            padding: 20px 28px 18px;
            border-bottom: 1px solid #f0f4f9;
            display: flex; align-items: center; gap: 10px;
        }
        .card-header .icon {
            width: 36px; height: 36px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }
        .card-header h2 { font-size: 1rem; font-weight: 700; color: #0f2d55; }
        .card-header p  { font-size: 0.8rem; color: #8a9bb5; margin-top: 2px; }
        .card-body { padding: 28px; }

        /* ===== 表單 ===== */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        .form-group { display: flex; flex-direction: column; gap: 7px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label {
            font-size: 0.845rem; font-weight: 600; color: #3d5278;
        }
        .input-wrap { position: relative; }
        .input-icon {
            position: absolute; left: 13px; top: 50%;
            transform: translateY(-50%);
            color: #b0bdd0; pointer-events: none;
        }
        .form-control {
            width: 100%; height: 46px;
            border: 1.5px solid #d8e1ef; border-radius: 10px;
            padding: 0 14px 0 40px;
            font-size: 0.88rem; color: #1e3a5f;
            background: #f7f9fc;
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
            outline: none;
        }
        .form-control:focus {
            border-color: #1a73e8; background: #fff;
            box-shadow: 0 0 0 3px rgba(26,115,232,0.11);
        }
        .form-control:disabled {
            background: #f0f4f9; color: #8a9bb5; cursor: not-allowed;
            border-color: #e8edf5;
        }
        .form-control::placeholder { color: #b0bdd0; }
        .form-hint { font-size: 0.76rem; color: #b0bdd0; margin-top: 3px; }

        /* 密碼眼睛 */
        .toggle-pwd {
            position: absolute; right: 12px; top: 50%;
            transform: translateY(-50%);
            background: none; border: none; cursor: pointer;
            color: #b0bdd0; transition: color 0.2s; padding: 0;
        }
        .toggle-pwd:hover { color: #1a73e8; }

        /* 密碼強度條 */
        .strength-bar { display: flex; gap: 4px; margin-top: 6px; }
        .s-seg { height: 4px; flex: 1; border-radius: 2px; background: #e8edf5; transition: background 0.3s; }
        .strength-label { font-size: 0.75rem; color: #8a9bb5; margin-top: 3px; }

        /* 按鈕 */
        .btn { height: 44px; border-radius: 10px; border: none; cursor: pointer; font-size: 0.9rem; font-weight: 600; transition: opacity 0.2s, transform 0.15s, box-shadow 0.2s; display: inline-flex; align-items: center; justify-content: center; gap: 7px; padding: 0 24px; }
        .btn:hover { opacity: 0.9; transform: translateY(-1px); }
        .btn:active { transform: translateY(0); }
        .btn-primary {
            background: linear-gradient(90deg, #1a73e8, #0d9488);
            color: #fff;
            box-shadow: 0 3px 12px rgba(26,115,232,0.28);
        }
        .btn-secondary {
            background: #f0f4f9; color: #3d5278;
            border: 1.5px solid #d8e1ef;
        }
        .btn-danger {
            background: linear-gradient(90deg, #e53e3e, #c0392b);
            color: #fff;
            box-shadow: 0 3px 12px rgba(229,62,62,0.25);
        }
        .form-actions {
            display: flex; gap: 12px; justify-content: flex-end;
            margin-top: 24px; padding-top: 20px;
            border-top: 1px solid #f0f4f9;
        }

        /* 只讀顯示行 */
        .info-row {
            display: flex; align-items: center; gap: 14px;
            padding: 14px 0;
            border-bottom: 1px solid #f7f9fc;
        }
        .info-row:last-child { border-bottom: none; }
        .info-icon {
            width: 38px; height: 38px; border-radius: 10px;
            background: #f0f4f9;
            display: flex; align-items: center; justify-content: center;
            color: #6b8ab5; flex-shrink: 0;
        }
        .info-label { font-size: 0.8rem; color: #8a9bb5; margin-bottom: 2px; }
        .info-value { font-size: 0.92rem; font-weight: 600; color: #1e3a5f; }
        .info-value.empty { color: #b0bdd0; font-weight: 400; font-style: italic; }

        /* 響應式 */
        @media (max-width: 680px) {
            .profile-header { flex-direction: column; align-items: flex-start; }
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full { grid-column: auto; }
        }
    </style>
</head>
<body>

<!-- 頂部導航 -->
<nav class="navbar">
    <div class="nav-brand">
        <svg width="22" height="22" viewBox="0 0 50 50" fill="none">
            <rect x="22" y="6" width="6" height="38" rx="3" fill="white"/>
            <rect x="6" y="22" width="38" height="6" rx="3" fill="white"/>
        </svg>
        CCHC 診所系統
    </div>
    <div class="nav-right">
        <a class="nav-link" href="<%= dashboardUrl %>">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                <polyline points="9 22 9 12 15 12 15 22"/>
            </svg>
            返回首頁
        </a>
        <a class="nav-link logout" href="${pageContext.request.contextPath}/user/logout">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                <polyline points="16 17 21 12 16 7"/>
                <line x1="21" y1="12" x2="9" y2="12"/>
            </svg>
            登出
        </a>
    </div>
</nav>

<div class="page-wrap">

    <!-- 麵包屑 -->
    <div class="breadcrumb">
        <a href="<%= dashboardUrl %>">首頁</a>
        <span>›</span>
        <span>個人資料</span>
    </div>

    <!-- 訊息提示 -->
    <% if (infoMsg != null) { %>
    <div class="alert alert-success" id="infoMsg">✓ &nbsp;<%= infoMsg %></div>
    <% } %>
    <% if (infoErr != null) { %>
    <div class="alert alert-error" id="infoErr">⚠ &nbsp;<%= infoErr %></div>
    <% } %>
    <% if (pwdMsg != null) { %>
    <div class="alert alert-success" id="pwdMsgAlert">✓ &nbsp;<%= pwdMsg %></div>
    <% } %>
    <% if (pwdErr != null) { %>
    <div class="alert alert-error" id="pwdErrAlert">⚠ &nbsp;<%= pwdErr %></div>
    <% } %>

    <!-- 用戶資料頭部 -->
    <div class="profile-header">
        <div class="avatar">
            <%= user.getFullName() != null && user.getFullName().length() > 0
                ? String.valueOf(user.getFullName().charAt(0)).toUpperCase() : "?" %>
        </div>
        <div class="profile-info">
            <h1><%= user.getFullName() %></h1>
            <div class="role-badge" style="background:<%= roleColor %>"><%= roleName %></div>
            <div class="profile-meta">
                <span>
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                    @<%= user.getUsername() %>
                </span>
                <span>
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"/>
                        <polyline points="12 6 12 12 16 14"/>
                    </svg>
                    帳號狀態：<strong style="color:<%= user.isActive() ? "#1a7a3f" : "#d93025" %>">
                        <%= user.isActive() ? "正常" : "已停用" %></strong>
                </span>
            </div>
        </div>
    </div>

    <!-- 只讀資訊卡 -->
    <div class="card">
        <div class="card-header">
            <div class="icon" style="background:#eff6ff">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#1a73e8" stroke-width="2">
                    <circle cx="12" cy="12" r="10"/>
                    <line x1="12" y1="8" x2="12" y2="12"/>
                    <line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
            </div>
            <div>
                <h2>帳號概覽</h2>
                <p>系統分配的固定資訊，不可自行修改</p>
            </div>
        </div>
        <div class="card-body">
            <div class="info-row">
                <div class="info-icon">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                </div>
                <div>
                    <div class="info-label">用戶名</div>
                    <div class="info-value"><%= user.getUsername() %></div>
                </div>
            </div>
            <div class="info-row">
                <div class="info-icon">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    </svg>
                </div>
                <div>
                    <div class="info-label">角色權限</div>
                    <div class="info-value"><%= roleName %></div>
                </div>
            </div>
            <% if (user.getRole() == 2 && user.getClinicId() != null) { %>
            <div class="info-row">
                <div class="info-icon">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                    </svg>
                </div>
                <div>
                    <div class="info-label">所屬診所 ID</div>
                    <div class="info-value">#<%= user.getClinicId() %></div>
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <!-- 編輯基本資料 -->
    <div class="card">
        <div class="card-header">
            <div class="icon" style="background:#f0fdf4">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#0d9488" stroke-width="2">
                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                </svg>
            </div>
            <div>
                <h2>編輯基本資料</h2>
                <p>修改姓名、電郵及聯絡電話</p>
            </div>
        </div>
        <div class="card-body">
            <form id="profileForm" action="${pageContext.request.contextPath}/user/updateInfo" method="post" novalidate>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="fullName">真實姓名 <span style="color:#e53e3e">*</span></label>
                        <div class="input-wrap">
                            <span class="input-icon">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                    <circle cx="12" cy="7" r="4"/>
                                </svg>
                            </span>
                            <input type="text" id="fullName" name="fullName" class="form-control"
                                   value="<%= user.getFullName() != null ? user.getFullName() : "" %>"
                                   placeholder="請輸入真實姓名" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="username_display">用戶名</label>
                        <div class="input-wrap">
                            <span class="input-icon">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="8" r="4"/><path d="M6 20v-2a4 4 0 0 1 8 0v2"/>
                                </svg>
                            </span>
                            <input type="text" id="username_display" class="form-control"
                                   value="<%= user.getUsername() %>" disabled>
                        </div>
                        <div class="form-hint">用戶名不可更改</div>
                    </div>
                    <div class="form-group">
                        <label for="email">電子郵件</label>
                        <div class="input-wrap">
                            <span class="input-icon">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                                    <polyline points="22,6 12,13 2,6"/>
                                </svg>
                            </span>
                            <input type="email" id="email" name="email" class="form-control"
                                   value="<%= user.getEmail() != null ? user.getEmail() : "" %>"
                                   placeholder="example@email.com">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="phone">聯絡電話</label>
                        <div class="input-wrap">
                            <span class="input-icon">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.6 1.18h3a2 2 0 0 1 2 1.72c.127.96.36 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.78a16 16 0 0 0 6.29 6.29l.96-.96a2 2 0 0 1 2.11-.45c.907.34 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/>
                                </svg>
                            </span>
                            <input type="tel" id="phone" name="phone" class="form-control"
                                   value="<%= user.getPhone() != null ? user.getPhone() : "" %>"
                                   placeholder="8 位本地電話">
                        </div>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="resetProfileForm()">重置</button>
                    <button type="submit" class="btn btn-primary">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="20 6 9 17 4 12"/>
                        </svg>
                        儲存變更
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- 修改密碼 -->
    <div class="card">
        <div class="card-header">
            <div class="icon" style="background:#fdf4ff">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#7c3aed" stroke-width="2">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                </svg>
            </div>
            <div>
                <h2>修改密碼</h2>
                <p>建議定期更換密碼以保障帳號安全</p>
            </div>
        </div>
        <div class="card-body">
            <form id="pwdForm" action="${pageContext.request.contextPath}/user/changePassword" method="post" novalidate>
                <div class="form-grid">
                    <div class="form-group full">
                        <label for="oldPassword">目前密碼 <span style="color:#e53e3e">*</span></label>
                        <div class="input-wrap">
                            <span class="input-icon">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                </svg>
                            </span>
                            <input type="password" id="oldPassword" name="oldPassword" class="form-control"
                                   placeholder="請輸入目前使用的密碼" required>
                            <button type="button" class="toggle-pwd" onclick="togglePwd('oldPassword','e1')">
                                <svg id="e1" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                                </svg>
                            </button>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="newPassword">新密碼 <span style="color:#e53e3e">*</span></label>
                        <div class="input-wrap">
                            <span class="input-icon">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                </svg>
                            </span>
                            <input type="password" id="newPassword" name="newPassword" class="form-control"
                                   placeholder="至少 4 個字符" required oninput="checkStrength(this.value)">
                            <button type="button" class="toggle-pwd" onclick="togglePwd('newPassword','e2')">
                                <svg id="e2" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                                </svg>
                            </button>
                        </div>
                        <div class="strength-bar">
                            <div class="s-seg" id="s1"></div>
                            <div class="s-seg" id="s2"></div>
                            <div class="s-seg" id="s3"></div>
                            <div class="s-seg" id="s4"></div>
                        </div>
                        <div class="strength-label" id="sLabel"></div>
                    </div>
                    <div class="form-group">
                        <label for="confirmNewPassword">確認新密碼 <span style="color:#e53e3e">*</span></label>
                        <div class="input-wrap">
                            <span class="input-icon">
                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                </svg>
                            </span>
                            <input type="password" id="confirmNewPassword" name="confirmNewPassword" class="form-control"
                                   placeholder="再次輸入新密碼" required>
                            <button type="button" class="toggle-pwd" onclick="togglePwd('confirmNewPassword','e3')">
                                <svg id="e3" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                                </svg>
                            </button>
                        </div>
                        <div id="confirmPwdErr" style="font-size:0.78rem;color:#e53e3e;margin-top:4px;display:none">兩次輸入的密碼不一致</div>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-danger">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                        確認修改密碼
                    </button>
                </div>
            </form>
        </div>
    </div>

</div><!-- /page-wrap -->

<script>
    /* 密碼顯示切換 */
    const EYE_ON  = `<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>`;
    const EYE_OFF = `<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>`;
    function togglePwd(id, iconId) {
        const inp = document.getElementById(id);
        const ico = document.getElementById(iconId);
        if (inp.type === 'password') { inp.type = 'text';     ico.innerHTML = EYE_OFF; }
        else                         { inp.type = 'password'; ico.innerHTML = EYE_ON;  }
    }

    /* 密碼強度 */
    function checkStrength(v) {
        const segs = ['s1','s2','s3','s4'].map(id => document.getElementById(id));
        const lbl  = document.getElementById('sLabel');
        const c    = ['#e53e3e','#f6ad55','#68d391','#1a73e8'];
        const t    = ['弱','一般','良好','強'];
        let sc = 0;
        if (v.length >= 4)  sc++;
        if (v.length >= 8)  sc++;
        if (/[A-Z]/.test(v) || /[!@#$%]/.test(v)) sc++;
        if (v.length >= 12) sc++;
        segs.forEach((s,i) => s.style.background = i < sc ? c[sc-1] : '#e8edf5');
        lbl.textContent = v.length ? '密碼強度：' + t[sc-1] : '';
    }

    /* 即時確認密碼 */
    document.getElementById('confirmNewPassword').addEventListener('input', function() {
        const err = document.getElementById('confirmPwdErr');
        err.style.display = (this.value && this.value !== document.getElementById('newPassword').value) ? 'block' : 'none';
    });

    /* 密碼表單提交驗證 */
    document.getElementById('pwdForm').addEventListener('submit', function(e) {
        const np = document.getElementById('newPassword').value;
        const cp = document.getElementById('confirmNewPassword').value;
        if (np.length < 4) { alert('新密碼至少需要 4 個字符'); e.preventDefault(); return; }
        if (np !== cp) {
            document.getElementById('confirmPwdErr').style.display = 'block';
            e.preventDefault();
        }
    });

    /* 重置個人資料表單 */
    function resetProfileForm() {
        document.getElementById('fullName').value = '<%= user.getFullName() != null ? user.getFullName().replace("'", "\\'") : "" %>';
        document.getElementById('email').value    = '<%= user.getEmail()    != null ? user.getEmail().replace("'", "\\'")    : "" %>';
        document.getElementById('phone').value    = '<%= user.getPhone()    != null ? user.getPhone().replace("'", "\\'")    : "" %>';
    }

    /* 自動隱藏提示訊息 */
    setTimeout(function() {
        document.querySelectorAll('.alert').forEach(function(el) {
            el.style.transition = 'opacity 0.5s';
            el.style.opacity = '0';
            setTimeout(function() { el.style.display = 'none'; }, 500);
        });
    }, 4000);
</script>
</body>
</html>
