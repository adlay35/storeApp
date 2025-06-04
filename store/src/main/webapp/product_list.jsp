<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/product_list_style.css">
</head>
<body>
    <%
        String driverName = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/store_db";
        String username = "root";
        String password = "123456";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        DecimalFormat formatter = new DecimalFormat("###,###");

        String companyFilter = request.getParameter("company");
        if (companyFilter == null || companyFilter.isEmpty() || companyFilter.equals("all")) {
            companyFilter = "all";
        }

        try {
            Class.forName(driverName);
            conn = DriverManager.getConnection(url, username, password);
            stmt = conn.createStatement();

            String sql = "SELECT id, img_url, company, name, price FROM product_tb";

            if (!companyFilter.equals("all")) {
                sql += " WHERE company = '" + companyFilter + "'";
            }
            sql += " LIMIT 20";

            rs = stmt.executeQuery(sql);
    %>
            <div class="product-head">
                <p>최근 등록된 상품</p>
            </div>

            <div class="col">
    <%
            int count = 0;
            while (rs.next()) {
                if (count % 4 == 0) {
    %>
                    <div class="row">
    <%
                }
    %>
                        <div class="product">
                            <img class="product-img" src="<%= rs.getString("img_url") %>" />
                            <div class="product-row">
                                <p class="product-company"><%= rs.getString("company") %></p>
                                <p class="product-name"><%= rs.getString("name") %></p>
                            </div>
                            <div class="product-row">
                                <p class="product-price"><%= formatter.format(rs.getInt("price")) %> 원</p>

                                <form action="<%= request.getContextPath() %>/cart_add_process.jsp" method="post" class="product-cart">
                                    <input type="hidden" name="product_id" value="<%= rs.getInt("id") %>">
                                    
                                    <button type="submit" class="product-cart-btn">
                                        <p>+</p>
                                        <img src="img\icons\cart.png" class="product-cart-icon"/>
                                    </button>
                                </form>
                            </div>
                            <form action="<%= request.getContextPath() %>/favorite_add_process.jsp" method="post" class="product-favorite">
                                    <input type="hidden" name="product_id" value="<%= rs.getInt("id") %>">
                                    <button type="submit" class="product-favorite-btn">
                                        <img src="img\icons\heart.png" class="product-favorite-icon"/>
                                    </button>
                            </form>
                        </div>
    <%
                count++;
                if (count % 4 == 0) {
    %>
                    </div>
    <%
                }
            }
            if (count % 4 != 0) {
    %>
                </div>
    <%
            }
        } catch (Exception e) {
            out.println("에러 발생: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { System.err.println("ResultSet close error: " + e.getMessage()); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { System.err.println("Statement close error: " + e.getMessage()); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { System.err.println("Connection close error: " + e.getMessage()); }
        }
    %>
    </div>
    <%
        String cartMessage = (String) session.getAttribute("cartMessage");
        String favoriteMessage = (String) session.getAttribute("favoriteMessage");
        String loginMessage = (String) session.getAttribute("loginMessage");

        if (cartMessage != null) {
            out.println("<script>alert('" + cartMessage + "');</script>");
            session.removeAttribute("cartMessage");
        }
        if (favoriteMessage != null) {
            out.println("<script>alert('" + favoriteMessage + "');</script>");
            session.removeAttribute("favoriteMessage");
        }
        if (loginMessage != null) {
            out.println("<script>alert('" + loginMessage + "');</script>");
            session.removeAttribute("loginMessage");
        }
    %>

</body>
</html>