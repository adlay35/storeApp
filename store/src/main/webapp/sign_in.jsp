<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/sign_style.css">
</head>
<body>
    <div class="signup-container">
        <p class="signup-p1">로그인</p>
        <form class="signup-form-group" action="sign_in_process.jsp" method="post">
            <input type="text" class="input-box" id="uid" name="uid" required placeholder="아이디">
            <input type="password" class="input-box" id="password" name="password" required placeholder="비밀번호">
            <button type="submit" class="signup-submit-btn">로그인</button>
        </form>
        <p style="margin-top: 20px;">
            계정이 없으신가요? <a href="layout.jsp?contentPage=sign_up.jsp">회원가입</a>
        </p>
    </div>
    <script>
        window.onload = function() {
            var message = "<%= session.getAttribute("signupMessage") != null ? session.getAttribute("signupMessage") : "" %>";

            if (message !== "") {
                alert(message);
                <% session.removeAttribute("signupMessage"); %>
            }
        };
    </script>
</body>
</html>