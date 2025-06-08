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
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        DecimalFormat formatter = new DecimalFormat("###,###");

        String searchTerm = request.getParameter("search");

        String companyFilter = request.getParameter("company");

        if (companyFilter == null || companyFilter.isEmpty() || companyFilter.equals("all")) {
            companyFilter = "all";
        }
        
        if (searchTerm == null) {
            searchTerm = "";
        }

        try {
            Class.forName(driverName);
            conn = DriverManager.getConnection(url, username, password);

            StringBuilder sql = new StringBuilder("SELECT id, img_url, company, name, price FROM product_tb");
            boolean whereAdded = false;

            if (!companyFilter.equals("all")) {
                sql.append(" WHERE company = ?");
                whereAdded = true;
            }

            if (!searchTerm.isEmpty()) {
                if (!whereAdded) {
                    sql.append(" WHERE");
                    whereAdded = true;
                } else {
                    sql.append(" AND");
                }
                sql.append(" (name LIKE ? OR company LIKE ?)");
            }
            
            sql.append(" LIMIT 20"); 

            pstmt = conn.prepareStatement(sql.toString());
            int paramIndex = 1;

            if (!companyFilter.equals("all")) {
                pstmt.setString(paramIndex++, companyFilter);
            }
            if (!searchTerm.isEmpty()) {
                pstmt.setString(paramIndex++, "%" + searchTerm + "%");
                pstmt.setString(paramIndex++, "%" + searchTerm + "%");
            }

            rs = pstmt.executeQuery();
    %>
    <% if (!searchTerm.isEmpty()) { %>
            <div class="search-result-info">
                <p>'<strong><%= searchTerm %></strong>'(으)로 검색한 결과입니다.</p>
            </div>
    <% } %>

            <div class="company-filter-container">
                <p>제조사</p>
                <p>|</p>
                <form action="<%= request.getContextPath() %>/layout.jsp" method="get">
                    <input type="hidden" name="contentPage" value="/search_result.jsp">
                    <input type="hidden" name="company" value="all">
                    <input type="hidden" name="search" value="<%= searchTerm %>">
                    <button type="submit" class="company-filter-btn">전체</button>
                </form>
                <form action="<%= request.getContextPath() %>/layout.jsp" method="get">
                    <input type="hidden" name="contentPage" value="/search_result.jsp">
                    <input type="hidden" name="company" value="A사">
                    <input type="hidden" name="search" value="<%= searchTerm %>">
                    <button type="submit" class="company-filter-btn">A사</button>
                </form>
                <form action="<%= request.getContextPath() %>/layout.jsp" method="get">
                    <input type="hidden" name="contentPage" value="/search_result.jsp">
                    <input type="hidden" name="company" value="B사">
                    <input type="hidden" name="search" value="<%= searchTerm %>">
                    <button type="submit" class="company-filter-btn">B사</button>
                </form>
                <form action="<%= request.getContextPath() %>/layout.jsp" method="get">
                    <input type="hidden" name="contentPage" value="/search_result.jsp">
                    <input type="hidden" name="company" value="C사">
                    <input type="hidden" name="search" value="<%= searchTerm %>">
                    <button type="submit" class="company-filter-btn">C사</button>
                </form>
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
                            <img class="product-img" src="<%= rs.getString("img_url") %>" alt="<%= rs.getString("name") %>" />
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
                                        <img src="img\icons\cart.png" class="product-cart-icon" alt="장바구니"/>
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
                if (count > 0 && count % 4 != 0) {
    %>
                        </div>
    <%
                }
                if (count == 0) {
    %>
                    <div class="no-results">
                        <p>검색 결과가 없습니다.</p>
                    </div>
    <%
                }
        } catch (Exception e) {
            out.println("에러 발생: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { System.err.println("ResultSet close error: " + e.getMessage()); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { System.err.println("PreparedStatement close error: " + e.getMessage()); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { System.err.println("Connection close error: " + e.getMessage()); }
        }
    %>
            </div> <%-- class="col" 닫기 --%>

    <%
        String cartMessage = (String) session.getAttribute("cartMessage");
        String loginMessage = (String) session.getAttribute("loginMessage");

        if (cartMessage != null) {
            out.println("<script>alert('" + cartMessage + "');</script>");
            session.removeAttribute("cartMessage");
        }
        if (loginMessage != null) {
            out.println("<script>alert('" + loginMessage + "');</script>");
            session.removeAttribute("loginMessage");
        }
    %>
</body>
</html>