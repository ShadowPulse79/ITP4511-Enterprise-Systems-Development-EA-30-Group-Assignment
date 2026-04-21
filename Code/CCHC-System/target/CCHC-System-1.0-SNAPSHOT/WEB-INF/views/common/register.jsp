<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-HK">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用戶註冊 - CCHC 社區診所系統</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', 'PingFang HK', 'Microsoft YaHei', sans-serif;
            background: linear-gradient(135deg, #0f4c81 0%, #1a73e8 55%, #0d9488 100%);
            padding: 40px 20px;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: fixed;
            width: 700px; height: 700px;
            top: -280px; right: -200px;
            border-radius: 50%;
            background: rgba(255,255,255,0.06);
            pointer-events: none;
        }
        body::after {
            content: '';
            position: fixed;
            width: 500px; height: 500px;
            bottom: -200px; left: -150px;
            border-radius: 50%;
            background: rgba(255,255,255,0.05);
            pointer-events: none;
        }

        .register-wrapper {
            width: 100%; max-width: 960px;
            display: flex;
            border-radius: 22px;
            overflow: hidden;
            box-shadow: 0 30px 80px rgba(0,0,0,0.22);
            position: relative; z-index: 1;
        }

        /* 左側品牌條 */
        .brand-strip {
            width: 300px; flex-shrink: 0;
            background: rgba(255,255,255,0.08);
            backdrop-filter: blur(12px);
            border-right: 1px solid rgba(255,255,255,0.12);
            padding: 56px 32px;
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            color: #fff; text-align: center;
        }
        .brand-strip .logo-box {
            width: 76px; height: 76px;
            border-radius: 20px;
            background: rgba(255,255,255,0.18);
            border: 2px solid rgba(255,255,255,0.3);
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 22px;
        }
        .brand-strip .logo-box svg { width: 42px; height: 42px; }
        .brand-strip h1 { font-size: 1.8rem; font-weight: 700; letter-spacing: 2px; }
        .brand-strip p  { font-size: 0.82rem; opacity: 0.75; margin-top: 6px; line-height: 1.6; }
        .brand-strip .steps {
            margin-top: 52px; width: 100%;
            display: flex; flex-direction: column; gap: 20px;
        }
        .step-item {
            display: flex; align-items: center; gap: 14px; text-align: left;
        }
        .step-num {
            width: 32px; height: 32px; flex-shrink: 0;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            border: 1.5px solid rgba(255,255,255,0.35);
            display: flex; align-items: center; justify-content: center;
            font-size: 0.82rem; font-weight: 700;
        }
        .step-item span { font-size: 0.85rem; opacity: 0.85; }

        /* 右側表單 */
        .form-panel {
            flex: 1;
            background: #fff;
            padding: 52px 48px;
            overflow-y: auto;
        }
        .form-panel h2 {
            font-size: 1.55rem; font-weight: 700;
            color: #0f2d55; margin-bottom: 4px;
        }
        .form-panel .subtitle {
            font-size: 0.875rem; color: #8a9bb5; margin-bottom: 32px;
        }

        /* 提示訊息 */
        .alert {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 12px 16px; border-radius: 10px;
            font-size: 0.875rem; margin-bottom: 22px;
            animation: slideIn 0.3s ease;
        }
        .alert-error   { background: #fff0f0; border: 1px solid #ffc5c5; color: #d93025; }
        .alert-success { background: #f0fff4; border: 1px solid #b3f0c8; color: #1a7a3f; }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-8px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* 兩欄佈局 */
        .form-row {
            display: grid; grid-template-columns: 1fr 1fr; gap: 18px;
        }
        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block; font-size: 0.845rem;
            font-weight: 600; color: #3d5278; margin-bottom: 7px;
        }
        .form-group label .required { color: #e53e3e; margin-left: 2px; }

        .input-wrapper { position: relative; }
        .input-icon {
            position: absolute; left: 13px; top: 50%; transform: translateY(-50%);
            color: #b0bdd0; pointer-events: none; line-height: 1;
        }
        .form-control {
            width: 100%; height: 46px;
            border: 1.5px solid #d8e1ef; border-radius: 10px;
            padding: 0 14px 0 40px;
            font-size: 0.875rem; color: #1e3a5f;
            background: #f7f9fc;
            transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
            outline: none;
        }
        .form-control:focus {
            border-color: #1a73e8;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(26,115,232,0.11);
        }
        .form-control.error {
            border-color: #e53e3e;
            background: #fff8f8;
        }
        .form-control::placeholder { color: #b0bdd0; }

        /* 密碼強度 */
        .toggle-password {
            position: absolute; right: 12px; top: 50%; transform: translateY(-50%);
            background: none; border: none; cursor: pointer;
            color: #b0bdd0; padding: 0; line-height: 1;
            transition: color 0.2s;
        }
        .toggle-password:hover { color: #1a73e8; }

        .strength-bar {
            display: flex; gap: 4px; margin-top: 6px;
        }
        .strength-seg {
            height: 4px; flex: 1; border-radius: 2px;
            background: #e8edf5;
            transition: background 0.3s;
        }
        .strength-label { font-size: 0.75rem; color: #8a9bb5; margin-top: 4px; }

        /* 錯誤文字 */
        .error-text {
            font-size: 0.78rem; color: #e53e3e;
            margin-top: 5px; display: none;
            animation: fadeIn 0.2s ease;
        }
        .error-text.show { display: block; }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

        /* 分隔線 */
        .section-divider {
            display: flex; align-items: center; gap: 10px;
            margin: 8px 0 22px; color: #b0bdd0; font-size: 0.78rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: 0.8px;
        }
        .section-divider::before, .section-divider::after {
            content: ''; flex: 1; height: 1px; background: #e8edf5;
        }

        /* 提交按鈕 */
        .btn-register {
            width: 100%; height: 50px;
            background: linear-gradient(90deg, #1a73e8, #0d9488);
            border: none; border-radius: 12px;
            color: #fff; font-size: 1rem; font-weight: 600;
            cursor: pointer; letter-spacing: 1px; margin-top: 8px;
            transition: opacity 0.2s, transform 0.15s, box-shadow 0.2s;
            box-shadow: 0 4px 16px rgba(26,115,232,0.32);
        }
        .btn-register:hover {
            opacity: 0.91; transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(26,115,232,0.4);
        }
        .btn-register:active { transform: translateY(0); }

        /* 底部登入連結 */
        .login-link {
            text-align: center; margin-top: 22px;
            font-size: 0.875rem; color: #6b7f9a;
        }
        .login-link a {
            color: #1a73e8; font-weight: 600;
            text-decoration: none; transition: color 0.2s;
        }
        .login-link a:hover { color: #0f4c81; }

        /* 響應式 */
        @media (max-width: 780px) {
            .brand-strip { display: none; }
            .form-panel { padding: 40px 28px; }
            .form-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="register-wrapper">

    <!-- 左側品牌條 -->
    <div class="brand-strip">
        <div class="logo-box">
            <svg viewBox="0 0 50 50" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="22" y="6" width="6" height="38" rx="3" fill="white"/>
                <rect x="6" y="22" width="38" height="6" rx="3" fill="white"/>
                <circle cx="25" cy="25" r="22" stroke="white" stroke-width="2" fill="none" opacity="0.4"/>
            </svg>
        </div>
        <h1>CCHC</h1>
        <p>Community Clinic<br>Healthcare System</p>

        <div class="steps">
            <div class="step-item">
                <div class="step-num">1</div>
                <span>填寫基本帳號資料</span>
            </div>
            <div class="step-item">
                <div class="step-num">2</div>
                <span>填寫個人聯絡方式</span>
            </div>
            <div class="step-item">
                <div class="step-num">3</div>
                <span>完成註冊，即刻使用</span>
            </div>
        </div>
    </div>

    <!-- 右側表單 -->
    <div class="form-panel">
        <h2>建立新帳號</h2>
        <p class="subtitle">請填寫以下資料以完成註冊，帶 <span style="color:#e53e3e">*</span> 為必填項目</p>

        <%
            String error   = (String) request.getAttribute("error");
            String message = (String) request.getAttribute("message");
            if (error != null) {
        %>
        <div class="alert alert-error">
            <span>⚠</span>
            <span><%= error %></span>
        </div>
        <% } %>
        <% if (message != null) { %>
        <div class="alert alert-success">
            <span>✓</span>
            <span><%= message %></span>
        </div>
        <% } %>

        <form id="registerForm" action="${pageContext.request.contextPath}/user/register" method="post" novalidate>

            <div class="section-divider">帳號資料</div>

            <div class="form-row">
                <div class="form-group">
                    <label for="username">用戶名 <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                <circle cx="12" cy="7" r="4"/>
                            </svg>
                        </span>
                        <input type="text" id="username" name="username" class="form-control"
                               placeholder="至少 3 個字符" required autocomplete="off">
                    </div>
                    <div class="error-text" id="usernameError">用戶名至少需要 3 個字符</div>
                </div>

                <div class="form-group">
                    <label for="fullName">真實姓名 <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                                <circle cx="9" cy="7" r="4"/>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                            </svg>
                        </span>
                        <input type="text" id="fullName" name="fullName" class="form-control"
                               placeholder="請輸入真實姓名" required>
                    </div>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="password">密碼 <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                            </svg>
                        </span>
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="至少 4 個字符" required autocomplete="new-password" oninput="checkStrength(this.value)">
                        <button type="button" class="toggle-password" onclick="togglePwd('password','eyeIcon1')" title="顯示/隱藏">
                            <svg id="eyeIcon1" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                            </svg>
                        </button>
                    </div>
                    <div class="strength-bar">
                        <div class="strength-seg" id="seg1"></div>
                        <div class="strength-seg" id="seg2"></div>
                        <div class="strength-seg" id="seg3"></div>
                        <div class="strength-seg" id="seg4"></div>
                    </div>
                    <div class="strength-label" id="strengthLabel"></div>
                    <div class="error-text" id="passwordError">密碼至少需要 4 個字符</div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">確認密碼 <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                            </svg>
                        </span>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                               placeholder="再次輸入密碼" required autocomplete="new-password">
                        <button type="button" class="toggle-password" onclick="togglePwd('confirmPassword','eyeIcon2')" title="顯示/隱藏">
                            <svg id="eyeIcon2" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                            </svg>
                        </button>
                    </div>
                    <div class="error-text" id="confirmError">兩次輸入的密碼不一致</div>
                </div>
            </div>

            <div class="section-divider">聯絡資料（選填）</div>

            <div class="form-row">
                <div class="form-group">
                    <label for="email">電子郵件</label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                                <polyline points="22,6 12,13 2,6"/>
                            </svg>
                        </span>
                        <input type="email" id="email" name="email" class="form-control"
                               placeholder="example@email.com" autocomplete="off">
                    </div>
                    <div class="error-text" id="emailError">請輸入有效的電子郵件地址</div>
                </div>

                <div class="form-group">
                    <label for="phone">聯絡電話</label>
                    <div class="input-wrapper">
                        <span class="input-icon">
                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.6 1.18h3a2 2 0 0 1 2 1.72c.127.96.36 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.78a16 16 0 0 0 6.29 6.29l.96-.96a2 2 0 0 1 2.11-.45c.907.34 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/>
                            </svg>
                        </span>
                        <input type="tel" id="phone" name="phone" class="form-control"
                               placeholder="8 位本地電話號碼">
                    </div>
                    <div class="error-text" id="phoneError">請輸入有效的本地電話號碼（8位）</div>
                </div>
            </div>

            <button type="submit" class="btn-register">立即註冊</button>
        </form>

        <div class="login-link">
            已有帳號？ <a href="${pageContext.request.contextPath}/user/login">立即登入</a>
        </div>
    </div>
</div>

<script>
    /* 密碼顯示切換 */
    function togglePwd(inputId, iconId) {
        const input = document.getElementById(inputId);
        const icon  = document.getElementById(iconId);
        const hidden = `<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>`;
        const visible = `<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>`;
        if (input.type === 'password') { input.type = 'text';     icon.innerHTML = hidden;   }
        else                           { input.type = 'password'; icon.innerHTML = visible;  }
    }

    /* 密碼強度 */
    function checkStrength(val) {
        const segs   = [document.getElementById('seg1'), document.getElementById('seg2'),
                        document.getElementById('seg3'), document.getElementById('seg4')];
        const label  = document.getElementById('strengthLabel');
        const colors = ['#e53e3e', '#f6ad55', '#68d391', '#1a73e8'];
        const labels = ['弱', '一般', '良好', '強'];
        let score = 0;
        if (val.length >= 4)  score++;
        if (val.length >= 8)  score++;
        if (/[A-Z]/.test(val) || /[!@#$%^&*]/.test(val)) score++;
        if (val.length >= 12) score++;
        segs.forEach((s, i) => { s.style.background = i < score ? colors[score - 1] : '#e8edf5'; });
        label.textContent = val.length ? '密碼強度：' + labels[score - 1] : '';
    }

    /* 即時確認密碼驗證 */
    document.getElementById('confirmPassword').addEventListener('input', function() {
        const pw = document.getElementById('password').value;
        if (this.value && pw !== this.value) showError('confirmError');
        else hideError('confirmError');
    });

    /* 表單提交驗證 */
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        let valid = true;
        hideAllErrors();

        const username        = document.getElementById('username').value.trim();
        const password        = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const email           = document.getElementById('email').value.trim();
        const phone           = document.getElementById('phone').value.trim();

        if (username.length < 3)  { showError('usernameError'); valid = false; }
        if (password.length < 4)  { showError('passwordError'); valid = false; }
        if (password !== confirmPassword) { showError('confirmError'); valid = false; }
        if (email && !isValidEmail(email))  { showError('emailError'); valid = false; }
        if (phone && !isValidPhone(phone))  { showError('phoneError'); valid = false; }

        if (!valid) e.preventDefault();
    });

    function showError(id)  { document.getElementById(id).classList.add('show'); }
    function hideError(id)  { document.getElementById(id).classList.remove('show'); }
    function hideAllErrors(){ document.querySelectorAll('.error-text').forEach(el => el.classList.remove('show')); }
    function isValidEmail(e){ return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(e); }
    function isValidPhone(p){ return /^[5-9]\d{7}$/.test(p); }

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
