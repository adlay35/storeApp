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

        DecimalFormat formatter = new DecimalFormat("###,###"); // 3자리마다 콤마 추가

        try {
            Class.forName(driverName);
            conn = DriverManager.getConnection(url, username, password);
            stmt = conn.createStatement();

            String sql = "SELECT id, img_url, company, name, price FROM product_tb LIMIT 20";
            rs = stmt.executeQuery(sql);
    %>
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
                                <form class="product-cart">
                                    <button type="submit" class="product-cart-btn">
                                        <p>+</p>
                                        <img src="img\icons\cart.png" class="product-cart-icon"/>
                                    </button>
                                </form>
                            </div>
                        </div>
    <%
                count++;
                if (count % 4 == 0) {
    %>
                    </div>
    <%
                }
            }
            // 마지막 줄이 4개가 안 돼서 안 닫혔다면 수동으로 닫기
            if (count % 4 != 0) {
    %>
                </div>
    <%
            }
        } catch (Exception e) {
            out.println("에러 발생: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
    </div>

</body>
</html>