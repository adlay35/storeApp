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
        <h2>로그인</h2>
        <form action="sign_in_process.jsp" method="post">
            <div class="signup-form-group">
                <label for="uid">아이디</label>
                <input type="text" id="uid" name="uid" required>
            </div>
            <div class="signup-form-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" required>
            </div>
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