<%--
  Created by IntelliJ IDEA.
  User: leese
  Date: 2026/4/20
  Time: 15:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用戶注冊</title>
</head>
<body>
    <div class="register-container">
        <h2>用戶注冊</h2>
        <!-- 顯示後端返回的錯誤或成功訊息 -->
        <%
            String error = (String)request.getAttribute("error");
            String message = (String)request.getAttribute("message");
            if(error!= null){
        %>
        <div class="error-message" id="errorMsg">
            <%= error %>
        </div>
        <%
            }
            if (message != null) {
        %>
        <div class="success-message" id="successMsg">
            <%= message %>
        </div>
        <%
            }
        %>

        <form id="registerForm" action="${pageContext.request.contextPath}/user/register" method="post">
            <div class="form-group">
                <label for="username">用戶名 *</label>
                <input type="text" id="username" name="username" required
                       placeholder="請輸入用戶名（至少3位）">
                <div class="error-text" id="usernameError">用戶名至少需要3個字符</div>
            </div>

            <div class="form-group">
                <label for="fullName">姓名 *</label>
                <input type="text" id="fullName" name="fullName" required
                       placeholder="請輸入真實姓名">
            </div>

            <div class="form-group">
                <label for="password">密碼 *</label>
                <input type="password" id="password" name="password" required
                       placeholder="請輸入密碼（至少4位）">
                <div class="error-text" id="passwordError">密碼至少需要4位</div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">確認密碼 *</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required
                       placeholder="請再次輸入密碼">
                <div class="error-text" id="confirmError">兩次輸入的密碼不一致</div>
            </div>

            <div class="form-group">
                <label for="email">電子郵件</label>
                <input type="email" id="email" name="email"
                       placeholder="example@email.com">
                <div class="error-text" id="emailError">請輸入有效的電子郵件地址</div>
            </div>

            <div class="form-group">
                <label for="phone">聯絡電話</label>
                <input type="tel" id="phone" name="phone"
                       placeholder="請輸入手機號碼">
                <div class="error-text" id="phoneError">請輸入11位手機號碼</div>
            </div>

            <button type="submit" class="btn-register">立即註冊</button>

        </form>

        <div class="login-link">
            已有帳號？ <a href="${pageContext.request.contextPath}/user/login">立即登錄</a>
        </div>
    </div>

    <script>
        // 前端驗證
        document.getElementById('registerForm').addEventListener('submit',function (e){
            let isValid = true;
            // 獲取各欄位值
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();

            if(username.length<3){
                showError('usernameError');
                isValid = false;
            }

            // 2. 驗證密碼（至少4位）
            if (password.length < 4) {
                showError('passwordError');
                isValid = false;
            }

            // 3. 驗證確認密碼
            if (password !== confirmPassword) {
                showError('confirmError');
                isValid = false;
            }

            // 4. 驗證郵箱格式（如果有填寫）
            if (email && !isValidEmail(email)) {
                showError('emailError');
                isValid = false;
            }

            // 5. 驗證手機號碼（如果有填寫）
            if (phone && !isValidPhone(phone)) {
                showError('phoneError');
                isValid = false;
            }
            if(!isValid){
                e.preventDefault();
            }
        });
        // 即時驗證（可選，提升用戶體驗）
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirm = this.value;
            if (password !== confirm) {
                showError('confirmError');
            } else {
                hideError('confirmError');
            }
        });
        // 輔助函數
        function showError(errorId) {
            document.getElementById(errorId).classList.add('show');
        }

        function hideError(errorId) {
            document.getElementById(errorId).classList.remove('show');
        }

        function hideAllErrors() {
            const errors = document.querySelectorAll('.error-text');
            errors.forEach(error => error.classList.remove('show'));
        }

        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        function isValidPhone(phone) {
            const phoneRegex = /^[5-9]\d{7}$/;
            return phoneRegex.test(phone);
        }

        // 3秒後自動隱藏訊息
        setTimeout(function() {
            const errorMsg = document.getElementById('errorMsg');
            const successMsg = document.getElementById('successMsg');
            if (errorMsg) errorMsg.style.display = 'none';
            if (successMsg) successMsg.style.display = 'none';
        }, 3000);
    </script>
</body>
</html>
