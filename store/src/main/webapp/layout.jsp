<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/layout_style.css">
</head>
<body>
    <div class="header">
        <div class="header-container">
            <form action="<%= request.getContextPath() %>/layout.jsp" method="get">
                    <input type="hidden" name="contentPage" value="/product_list.jsp">
                    <input type="hidden" name="company" value="all">
                    <button type="submit" class="logo">Store</button>
            </form>

            <div class="category">
                <img src="img\icons\category.png" class="category-icon"/>
                <div class="category-title">카테고리</div>
                <div class="triangle1"></div>
                <div class="category-dropdown">
                    <form class="category1" action="<%= request.getContextPath() %>/layout.jsp" method="get">
                        <input type="hidden" name="contentPage" value="/category_result.jsp">
                        <input type="hidden" name="category" value="음료">
                        <button type="submit" class="category-btn">음료</button>
                    </form>
                    <form class="category2" action="<%= request.getContextPath() %>/layout.jsp" method="get">
                        <input type="hidden" name="contentPage" value="/category_result.jsp">
                        <input type="hidden" name="category" value="카테고리2">
                        <button type="submit" class="category-btn">카테고리2</button>
                    </form>
                    <form class="category3" action="<%= request.getContextPath() %>/layout.jsp" method="get">
                        <input type="hidden" name="contentPage" value="/category_result.jsp">
                        <input type="hidden" name="category" value="카테고리3">
                        <button type="submit" class="category-btn">카테고리3</button>
                    </form>
                    <form class="category4" action="<%= request.getContextPath() %>/layout.jsp" method="get">
                        <input type="hidden" name="contentPage" value="/category_result.jsp">
                        <input type="hidden" name="category" value="카테고리4">
                        <button type="submit" class="category-btn">카테고리4</button>
                    </form>
                </div>
            </div>

            <form class="search" action="<%= request.getContextPath() %>/layout.jsp" method="get">
                <input type="hidden" name="contentPage" value="/search_result.jsp">
                <img src="img\icons\search.png" class="search-icon"/>
                <input type="text" class="search-box" name="search">
            </form>

            <div class="user">
                <img src="img\icons\user.png" class="user-icon"/>
                <div class="triangle2"></div>
                <%
                    // 세션에서 로그인된 사용자 ID를 가져옴
                    String loggedInUser = (String) session.getAttribute("loggedInUser");
                    boolean isLoggedIn = (loggedInUser != null); // 로그인 상태인지 확인
                %>
                <div class="user-dropdown">
                    <div class="user-dropdown-left">
                        <% if (!isLoggedIn) { %>
                            <form action="<%= request.getContextPath() %>/layout.jsp" method="get">
                                <input type="hidden" name="contentPage" value="/sign_in.jsp">
                                <button type="submit" class="signin-btn">로그인</button>
                            </form>
                        <% } else { %>
                            <p class="welcome-message">환영합니다, <%= loggedInUser %>님!</p>
                        <% } %>
                    </div>
                    <div class="user-dropdown-right">
                        <% if (!isLoggedIn) { %>
                            <form action="<%= request.getContextPath() %>/layout.jsp" method="get">
                                <input type="hidden" name="contentPage" value="/sign_up.jsp">
                                <button type="submit" class="signup-btn">회원가입</button>
                            </form>
                        <% } else { %>
                            <form action="<%= request.getContextPath() %>/logout_process.jsp" method="post">
                                <button type="submit" class="logout-btn">로그아웃</button>
                            </form>
                        <% } %>
                    </div>
                </div>
            </div>

            <form class="favorite" action="<%= request.getContextPath() %>/layout.jsp" method="get">
                <input type="hidden" name="contentPage" value="/favorite.jsp">
                <button type="submit" class="favorite-btn">
                    <img src="img\icons\heart.png" class="favorite-icon"/>
                </button>
            </form>

            <form class="cart" action="<%= request.getContextPath() %>/layout.jsp" method="get">
                <input type="hidden" name="contentPage" value="/cart.jsp">
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