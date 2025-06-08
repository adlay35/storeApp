<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String loggedInUserUid = (String) session.getAttribute("loggedInUser");
    if (loggedInUserUid == null) {
        // 로그인되지 않은 사용자
        session.setAttribute("loginMessage", "찜하기 기능을 이용하려면 로그인해야 합니다.");
        response.sendRedirect("layout.jsp?contentPage=product_list.jsp");
        return;
    }

    String productIdStr = request.getParameter("product_id");
    int productId = 0;
    try {
        productId = Integer.parseInt(productIdStr);
    } catch (NumberFormatException e) {
        session.setAttribute("favoriteMessage", "유효하지 않은 상품 정보입니다.");
        response.sendRedirect("layout.jsp?contentPage=product_list.jsp");
        return;
    }

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
            session.setAttribute("favoriteMessage", "사용자 정보를 찾을 수 없습니다.");
            response.sendRedirect("layout.jsp?contentPage=product_list.jsp");
            return;
        }
        rs.close();
        pstmt.close();

        //이미 찜되어 있는지 확인
        String checkFavoriteSql = "SELECT COUNT(*) FROM favorite_tb WHERE user_id = ? AND product_id = ?";
        pstmt = conn.prepareStatement(checkFavoriteSql);
        pstmt.setInt(1, userId);
        pstmt.setInt(2, productId);
        rs = pstmt.executeQuery();

        if (rs.next() && rs.getInt(1) > 0) {
            // 이미 찜되어 있는 경우 해제
            String deleteFavoriteSql = "DELETE FROM favorite_tb WHERE user_id = ? AND product_id = ?";
            pstmt.close();
            pstmt = conn.prepareStatement(deleteFavoriteSql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, productId);
            pstmt.executeUpdate();
            session.setAttribute("favoriteMessage", "찜 목록에서 상품을 해제했습니다.");
        } else {
            // 찜되어 있지 않은 경우 찜 추가
            String insertFavoriteSql = "INSERT INTO favorite_tb (user_id, product_id) VALUES (?, ?)";
            pstmt.close();
            pstmt = conn.prepareStatement(insertFavoriteSql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, productId);
            pstmt.executeUpdate();
            session.setAttribute("favoriteMessage", "상품을 찜 목록에 추가했습니다.");
        }

    } catch (Exception e) {
            out.println("에러 발생: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { System.err.println("ResultSet close error: " + e.getMessage()); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { System.err.println("PreparedStatement close error: " + e.getMessage()); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { System.err.println("Connection close error: " + e.getMessage()); }
    }

    response.sendRedirect("layout.jsp?contentPage=product_list.jsp");
%>