<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DecimalFormat" %>

<%!
    public class FavoriteProduct {
        int id;
        String name;
        String company;
        int price;
        String imgUrl;

        public FavoriteProduct(int id, String name, String company, int price, String imgUrl) {
            this.id = id;
            this.name = name;
            this.company = company;
            this.price = price;
            this.imgUrl = imgUrl;
        }

        public int getId() { return id; }
        public String getName() { return name; }
        public String getCompany() { return company; }
        public int getPrice() { return price; }
        public String getImgUrl() { return imgUrl; }
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    DecimalFormat formatter = new DecimalFormat("###,###"); // 가격 포맷용

    String loggedInUserUid = (String) session.getAttribute("loggedInUser");
    if (loggedInUserUid == null) {
        session.setAttribute("loginMessage", "찜 목록을 보려면 로그인해야 합니다.");
        response.sendRedirect("layout.jsp?contentPage=sign_in.jsp");
        return;
    }

    List<FavoriteProduct> favoriteProducts = new ArrayList<>();
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

        // 찜 목록과 상품 정보가져오기
        String getFavoritesSql = "SELECT p.id, p.name, p.company, p.price, p.img_url " +
                                 "FROM favorite_tb f JOIN product_tb p ON f.product_id = p.id " +
                                 "WHERE f.user_id = ?";
        pstmt = conn.prepareStatement(getFavoritesSql);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            favoriteProducts.add(new FavoriteProduct(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("company"),
                rs.getInt("price"),
                rs.getString("img_url")
            ));
        }

    } catch (Exception e) {
            out.println("에러 발생: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { System.err.println("ResultSet close error: " + e.getMessage()); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { System.err.println("PreparedStatement close error: " + e.getMessage()); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { System.err.println("Connection close error: " + e.getMessage()); }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/favorite_style.css">
</head>
<body>
    <div class="favorite-container">
        <h2>나의 찜 목록</h2>
        <% if (favoriteProducts.isEmpty()) { %>
            <p>찜한 상품이 없습니다.</p>
        <% } else { %>
            <% for (FavoriteProduct p : favoriteProducts) { %>
                <div class="favorite-item">
                    <img src="<%= p.getImgUrl() %>" alt="<%= p.getName() %>">
                    <div class="favorite-item-details">
                        <p><strong><%= p.getName() %></strong> (<%= p.getCompany() %>)</p>
                        <p>가격: <%= formatter.format(p.getPrice()) %> 원</p>
                        </div>
                </div>
            <% } %>
        <% } %>
    </div>
</body>
</html>