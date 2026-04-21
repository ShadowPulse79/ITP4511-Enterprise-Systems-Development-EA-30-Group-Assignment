<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-HK">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登入 - CCHC 社區診所系統</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            min-height: 100vh;
            display: flex;
            font-family: 'Segoe UI', 'PingFang HK', 'Microsoft YaHei', sans-serif;
            background: linear-gradient(135deg, #0f4c81 0%, #1a73e8 50%, #0d9488 100%);
            position: relative;
            overflow: hidden;
        }

        /* 背景裝飾圓形 */
        body::before, body::after {
            content: '';
            position: fixed;
            border-radius: 50%;
            opacity: 0.08;
            background: #fff;
        }
        body::before { width: 600px; height: 600px; top: -200px; right: -150px; }
        body::after  { width: 400px; height: 400px; bottom: -150px; left: -100px; }

        /* 左側品牌區 */
        .brand-panel {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 60px 40px;
            color: #fff;
            text-align: center;
        }
        .brand-logo {
            width: 90px; height: 90px;
            background: rgba(255,255,255,0.15);
            border: 2px solid rgba(255,255,255,0.35);
            border-radius: 24px;
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 28px;
            backdrop-filter: blur(6px);
        }
        .brand-logo svg { width: 50px; height: 50px; }
        .brand-name {
            font-size: 2rem; font-weight: 700; letter-spacing: 2px;
            text-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .brand-subtitle {
            margin-top: 10px; font-size: 1rem;
            opacity: 0.85; letter-spacing: 1px;
        }
        .brand-tagline {
            margin-top: 40px; font-size: 0.9rem; opacity: 0.7;
            max-width: 280px; line-height: 1.8;
        }
        .brand-features {
            margin-top: 48px; list-style: none; text-align: left;
        }
        .brand-features li {
            display: flex; align-items: center; gap: 12px;
            margin-bottom: 18px; font-size: 0.92rem; opacity: 0.88;
        }
        .brand-features li .icon {
            width: 36px; height: 36px; border-radius: 10px;
            background: rgba(255,255,255,0.15);
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0; font-size: 1.1rem;
        }

        /* 右側登入卡片 */
        .login-panel {
            width: 480px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 24px;
        }
        .login-card {
            width: 100%;
            background: #fff;
            border-radius: 20px;
            padding: 48px 44px;
            box-shadow: 0 24px 64px rgba(0,0,0,0.18);
        }
        .card-header { margin-bottom: 36px; }
        .card-header h2 {
            font-size: 1.6rem; font-weight: 700;
            color: #0f2d55; margin-bottom: 6px;
        }
        .card-header p { font-size: 0.88rem; color: #8a9bb5; }

        /* 提示訊息 */
        .alert {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 12px 16px; border-radius: 10px;
            font-size: 0.875rem; margin-bottom: 20px;
            animation: slideIn 0.3s ease;
        }
        .alert-error { background: #fff0f0; border: 1px solid #ffc5c5; color: #d93025; }
        .alert-success { background: #f0fff4; border: 1px solid #b3f0c8; color: #1a7a3f; }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-8px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* 表單 */
        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block; font-size: 0.85rem;
            font-weight: 600; color: #3d5278; margin-bottom: 8px;
        }
        .input-wrapper { position: relative; }
        .input-wrapper .input-icon {
            position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
            color: #8a9bb5; pointer-events: none;
        }
        .form-control {
            width: 100%; height: 48px;
            border: 1.5px solid #d8e1ef; border-radius: 10px;
            padding: 0 14px 0 42px;
            font-size: 0.9rem; color: #1e3a5f;
            background: #f7f9fc;
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
            outline: none;
        }
        .form-control:focus {
            border-color: #1a73e8;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(26,115,232,0.12);
        }
        .form-control::placeholder { color: #b0bdd0; }

        /* 密碼顯示切換 */
        .toggle-password {
            position: absolute; right: 14px; top: 50%; transform: translateY(-50%);
            background: none; border: none; cursor: pointer;
            color: #8a9bb5; padding: 0; line-height: 1;
            transition: color 0.2s;
        }
        .toggle-password:hover { color: #1a73e8; }

        /* 底部輔助行 */
        .form-footer {
            display: flex; justify-content: flex-end;
            margin-top: -8px; margin-bottom: 28px;
        }
        .form-footer a {
            font-size: 0.82rem; color: #1a73e8; text-decoration: none;
            transition: color 0.2s;
        }
        .form-footer a:hover { color: #0f4c81; text-decoration: underline; }

        /* 登入按鈕 */
        .btn-primary {
            width: 100%; height: 50px;
            background: linear-gradient(90deg, #1a73e8, #0d9488);
            border: none; border-radius: 12px;
            color: #fff; font-size: 1rem; font-weight: 600;
            cursor: pointer; letter-spacing: 1px;
            transition: opacity 0.2s, transform 0.15s, box-shadow 0.2s;
            box-shadow: 0 4px 16px rgba(26,115,232,0.35);
        }
        .btn-primary:hover {
            opacity: 0.92; transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(26,115,232,0.42);
        }
        .btn-primary:active { transform: translateY(0); }

        /* 分隔線 */
        .divider {
            display: flex; align-items: center;
            gap: 12px; margin: 28px 0 24px;
            color: #b0bdd0; font-size: 0.8rem;
        }
        .divider::before, .divider::after {
            content: ''; flex: 1;
            height: 1px; background: #e8edf5;
        }

        /* 底部連結 */
        .card-footer {
            text-align: center;
            font-size: 0.875rem; color: #6b7f9a;
        }
        .card-footer a {
            color: #1a73e8; font-weight: 600;
            text-decoration: none; transition: color 0.2s;
        }
        .card-footer a:hover { color: #0f4c81; }

        /* 測試帳號提示 */
        .test-accounts {
            margin-top: 24px;
            background: #f7f9fc; border: 1px solid #e3eaf5;
            border-radius: 10px; padding: 14px 16px;
        }
        .test-accounts p {
            font-size: 0.78rem; color: #8a9bb5; margin-bottom: 8px;
            font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .test-accounts ul {
            list-style: none; display: flex; flex-direction: column; gap: 4px;
        }
        .test-accounts ul li {
            font-size: 0.8rem; color: #5a7099;
            display: flex; align-items: center; gap: 8px;
        }
        .test-accounts ul li::before {
            content: ''; width: 6px; height: 6px;
            border-radius: 50%; background: #1a73e8; flex-shrink: 0;
        }

        /* 響應式 */
        @media (max-width: 820px) {
            .brand-panel { display: none; }
            body { background: linear-gradient(160deg, #0f4c81, #1a73e8); }
            .login-panel { width: 100%; }
            .login-card { padding: 36px 28px; }
        }
    </style>
</head>
<body>

    <!-- 左側品牌 -->
    <div class="brand-panel">
        <div class="brand-logo">
            <svg viewBox="0 0 50 50" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="22" y="6" width="6" height="38" rx="3" fill="white"/>
                <rect x="6" y="22" width="38" height="6" rx="3" fill="white"/>
                <circle cx="25" cy="25" r="22" stroke="white" stroke-width="2" fill="none" opacity="0.4"/>
            </svg>
        </div>
        <div class="brand-name">CCHC</div>
        <div class="brand-subtitle">Community Clinic Healthcare System</div>
        <div class="brand-tagline">為社區提供專業、高效的醫療健康管理服務</div>
        <ul class="brand-features">
            <li>
                <span class="icon">📋</span>
                <span>預約管理 · 輕鬆掌握就診安排</span>
            </li>
            <li>
                <span class="icon">🏥</span>
                <span>診所資訊 · 即時查閱門診動態</span>
            </li>
            <li>
                <span class="icon">🔔</span>
                <span>通知提醒 · 不錯過任何重要訊息</span>
            </li>
            <li>
                <span class="icon">🔒</span>
                <span>安全加密 · 全程保障個人隱私</span>
            </li>
        </ul>
    </div>

    <!-- 右側登入卡片 -->
    <div class="login-panel">
        <div class="login-card">
            <div class="card-header">
                <h2>歡迎回來</h2>
                <p>請登入您的 CCHC 帳號以繼續</p>
            </div>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null && !error.isEmpty()) {
            %>
            <div class="alert alert-error">
                <span>⚠</span>
                <span><%= error %></span>
            </div>
            <% } %>

            <%
                String message = (String) request.getAttribute("message");
                if (message != null && !message.isEmpty()) {
            %>
            <div class="alert alert-success">
                <span>✓</span>
                <span><%= message %></span>
            </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/user/login" method="post">
                <div class="form-group">
                    <label for="username">用戶名</label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                            </svg>
                        </span>
                        <input type="text" id="username" name="username" class="form-control"
                               placeholder="請輸入用戶名" required autocomplete="username">
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">密碼</label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                            </svg>
                        </span>
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="請輸入密碼" required autocomplete="current-password">
                        <button type="button" class="toggle-password" onclick="togglePassword()" title="顯示/隱藏密碼">
                            <svg id="eyeIcon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <div class="form-footer">
                    <a href="#">忘記密碼？</a>
                </div>

                <button type="submit" class="btn-primary">登 入</button>
            </form>

            <div class="divider">或</div>

            <div class="card-footer">
                還沒有帳號？ <a href="${pageContext.request.contextPath}/user/register">立即註冊</a>
            </div>

            <div class="test-accounts">
                <p>測試帳號</p>
                <ul>
                    <li>管理員：admin / password123</li>
                    <li>患者：patient / password123</li>
                    <li>員工：staff_cw / password123</li>
                </ul>
            </div>
        </div>
    </div>

    <script>
        function togglePassword() {
            const input = document.getElementById('password');
            const icon  = document.getElementById('eyeIcon');
            if (input.type === 'password') {
                input.type = 'text';
                icon.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>';
            } else {
                input.type = 'password';
                icon.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
            }
        }

        // 自動隱藏提示訊息
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
