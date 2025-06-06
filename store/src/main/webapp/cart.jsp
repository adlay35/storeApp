<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%!
    public class Product {
        int id;
        String name;
        String company;
        int price;
        String imgUrl;
        int quantity;

        public Product(int id, String name, String company, int price, String imgUrl, int quantity) {
            this.id = id;
            this.name = name;
            this.company = company;
            this.price = price;
            this.imgUrl = imgUrl;
            this.quantity = quantity;
        }

        public int getId() { return id; }
        public String getName() { return name; }
        public String getCompany() { return company; }
        public int getPrice() { return price; }
        public String getImgUrl() { return imgUrl; }
        public int getQuantity() { return quantity; }
    }
%>

<%
    request.setCharacterEncoding("UTF-8");

    String loggedInUserUid = (String) session.getAttribute("loggedInUser");
    boolean isLoggedIn = (loggedInUserUid != null);

    Map<Integer, Integer> cartItems = new LinkedHashMap<>();

    if (isLoggedIn) {
        //로그인된 사용자 장바구니
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String driverName = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/store_db";
        String dbUser = "root";
        String dbPassword = "123456";

        try {
            Class.forName(driverName);
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            int userId = -1;
            String getUserSql = "SELECT id FROM user_tb WHERE uid = ?";
            pstmt = conn.prepareStatement(getUserSql);
            pstmt.setString(1, loggedInUserUid);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("id");
            } else {
                out.println("<p>사용자 정보를 찾을 수 없습니다.</p>");
                return;
            }
            rs.close();
            pstmt.close();

            String getCartSql = "SELECT product_id, count FROM cart_tb WHERE user_id = ?";
            pstmt = conn.prepareStatement(getCartSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                cartItems.put(rs.getInt("product_id"), rs.getInt("count"));
            }

        } catch (ClassNotFoundException e) {
            out.println("<p>데이터베이스 드라이버 로드 오류: " + e.getMessage() + "</p>");
        } catch (SQLException e) {
            out.println("<p>데이터베이스 연결 오류: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }

    } else {
        // 게스트 장바구니, 쿠키
        String guestCartCookieName = "guest_cart";
        String guestCartValue = "";
        Cookie[] cookies = request.getCookies();
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(guestCartCookieName)) {
                    guestCartValue = URLDecoder.decode(cookie.getValue(), "UTF-8");
                    break;
                }
            }
        }

        if (!guestCartValue.isEmpty()) {
            String[] items = guestCartValue.split("\\|");
            for (String item : items) {
                String[] parts = item.split(":");
                if (parts.length == 2) {
                    try {
                        cartItems.put(Integer.parseInt(parts[0]), Integer.parseInt(parts[1]));
                    } catch (NumberFormatException e) {
                        // 유효하지 않은 쿠키 항목은 무시
                    }
                }
            }
        }
    }

    // 장바구니에 담긴 상품 정보를 DB에서 조회하여 리스트로 만들기
    List<Product> cartProductList = new ArrayList<>();
    if (!cartItems.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/store_db", "root", "123456");

            StringBuilder productIdsInClause = new StringBuilder();
            for (int productId : cartItems.keySet()) {
                if (productIdsInClause.length() > 0) {
                    productIdsInClause.append(",");
                }
                productIdsInClause.append(productId);
            }

            String getProductsSql = "SELECT id, name, company, price, img_url FROM product_tb WHERE id IN (" + productIdsInClause.toString() + ")";
            pstmt = conn.prepareStatement(getProductsSql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int pId = rs.getInt("id");
                int pQuantity = cartItems.get(pId);
                cartProductList.add(new Product(
                    pId,
                    rs.getString("name"),
                    rs.getString("company"),
                    rs.getInt("price"),
                    rs.getString("img_url"),
                    pQuantity
                ));
            }

        } catch (Exception e) {
            out.println("에러 발생: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { System.err.println("ResultSet close error: " + e.getMessage()); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { System.err.println("PreparedStatement close error: " + e.getMessage()); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { System.err.println("Connection close error: " + e.getMessage()); }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/cart_style.css">
</head>
<body>
    <div class="cart-head">
        <p>장바구니</p>
    </div>
    <div class="cart-row">
        <div class="cart-container">
            <% if (cartProductList.isEmpty()) { %>
                <p>장바구니가 비어 있습니다.</p>
            <% } else { %>
                <% long totalAmount = 0; %>
                <% for (Product p : cartProductList) { %>
                    <div class="cart-item">
                        <img src="<%= p.getImgUrl() %>" alt="<%= p.getName() %>">
                        <div class="cart-item-details">
                            <p><strong><%= p.getCompany() %></strong> <%= p.getName() %></p>
                            <p>가격: <%= String.format("%,d", p.getPrice()) %> 원</p>
                            <p class="cart-item-quantity">수량: <%= p.getQuantity() %></p>
                            <p>총합: <%= String.format("%,d", (long)p.getPrice() * p.getQuantity()) %> 원</p>
                        </div>
                    </div>
                    <% totalAmount += (long)p.getPrice() * p.getQuantity(); %>
                <% } %>
                <div class="cart-total">
                    총 결제 금액: <%= String.format("%,d", totalAmount) %> 원
                </div>
            <% } %>
        </div>
        <div class="cart-calculator">
        </div>
    </div>
</body>
</html>