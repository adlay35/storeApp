<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="layout_style.css">
</head>
<body>
    <!-- 상단 UI -->
    <div class="header">
        <div class="header-container">
            <a class="logo">Store</a>

            <div class="category">
                <img src="img\icons\category.png" class="category-icon"/>
                <div class="category-title">카테고리</div>
                <div class="triangle1"></div>
                <div class="category-dropdown">
                    <form class="category1">카테고리1</form>
                    <form class="category2">카테고리2</form>
                    <form class="category3">카테고리3</form>
                    <form class="category4">카테고리4</form>
                </div>
            </div>

            <form class="search">
                <img src="img\icons\search.png" class="search-icon"/>
                <input type="text" class="search-box">
            </form>

            <form class="user">
                <img src="img\icons\user.png" class="user-icon"/>
                <div class="triangle2"></div>
                <div class="user-dropdown">
                    <div class="user-dropdown-left">
                        <button type="submit" class="signin-btn">로그인</button>
                        <!-- div 로그인 된 경우에, 회원 아이디 -->
                    </div>
                    <div class="user-dropdown-right">
                        <button type="submit" class="signup-btn">회원가입</button>
                        <!-- button 로그인 된 경우에, 로그아웃 버튼 -->
                    </div>
                </div>
            </form>

            <form class="favorite">
                <button type="submit" class="favorite-btn">
                    <img src="img\icons\heart.png" class="favorite-icon"/>
                </button>
            </form>

            <form class="cart">
                <button type="submit" class="cart-btn">
                    <img src="img\icons\cart.png" class="cart-icon"/>
                </button>
            </form>
        </div>
    </div>

    <!-- content 요소가 들어갈 영역 -->
    <div class="container">
        <jsp:include page="<%= request.getParameter(\"contentPage\") %>"/>
    </div>
</body>
</html>