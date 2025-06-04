<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/product_list_style.css">
</head>
<body>
    <div class="signup-container">
        <h2>회원가입</h2>
        <form action="sign_up_process.jsp" method="post" onsubmit="return validateForm()">
            <div class="signup-form-group">
                <label for="uid">아이디</label>
                <input type="text" id="uid" name="uid" required>
                <span id="uidError" class="signup-error-message"></span>
            </div>
            <div class="signup-form-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" required>
                <span id="passwordError" class="signup-error-message"></span>
            </div>
            <div class="signup-form-group">
                <label for="confirmPassword">비밀번호 확인</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
                <span id="confirmPasswordError" class="signup-error-message"></span>
            </div>
            <button type="submit" class="signup-submit-btn">가입하기</button>
        </form>
    </div>
    <script>
        function validateForm() {
            const uid = document.getElementById('uid').value;
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            const uidError = document.getElementById('uidError');
            const passwordError = document.getElementById('passwordError');
            const confirmPasswordError = document.getElementById('confirmPasswordError');

            let isValid = true;
            uidError.style.display = 'none';
            passwordError.style.display = 'none';
            confirmPasswordError.style.display = 'none';

            // 5~20자의 영문 소문자, 숫자, 언더스코어(_)만 허용, 첫 글자는 영문 소문자
            const uidRegex = /^[a-z][a-z0-9_]{4,19}$/;
            if (!uidRegex.test(uid)) {
                uidError.textContent = '아이디는 5~20자의 영문 소문자, 숫자, _ 만 가능하며, 첫 글자는 영문 소문자여야 합니다.';
                uidError.style.display = 'block';
                isValid = false;
            }

            // 8~16자의 영문 대소문자, 숫자, 특수문자(!@#$%^&*)를 각각 1개 이상 포함
            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,16}$/;
            if (!passwordRegex.test(password)) {
                passwordError.textContent = '비밀번호는 8~16자의 영문 대소문자, 숫자, 특수문자를 각각 1개 이상 포함해야 합니다.';
                passwordError.style.display = 'block';
                isValid = false;
            }

            if (password !== confirmPassword) {
                confirmPasswordError.textContent = '비밀번호가 일치하지 않습니다.';
                confirmPasswordError.style.display = 'block';
                isValid = false;
            }

            return isValid;
        }

        document.getElementById('uid').addEventListener('blur', validateForm);
        document.getElementById('password').addEventListener('blur', validateForm);
        document.getElementById('confirmPassword').addEventListener('blur', validateForm);

        window.onload = function() {
            var signupMessage = "<%= session.getAttribute("signupMessage") != null ? session.getAttribute("signupMessage") : "" %>";

            if (signupMessage !== "") {
                alert(signupMessage);
                <% session.removeAttribute("signupMessage"); %>
            }
        };
    </script>
</body>
</html>