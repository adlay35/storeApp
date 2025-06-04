<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String uid = request.getParameter("uid");
    String password = request.getParameter("password");

    String driverName = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/store_db";
    String dbuid = "root";
    String dbPassword = "123456";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName(driverName);
        conn = DriverManager.getConnection(url, dbuid, dbPassword);
        conn.setAutoCommit(false);

        String checkuidSql = "SELECT COUNT(*) FROM user_tb WHERE uid = ?";
        pstmt = conn.prepareStatement(checkuidSql);
        pstmt.setString(1, uid);
        rs = pstmt.executeQuery();
        if (rs.next() && rs.getInt(1) > 0) {
            session.setAttribute("signupMessage", "이미 존재하는 아이디입니다.");
            response.sendRedirect("layout.jsp?contentPage=sign_up.jsp");
            conn.rollback();
            return;
        }
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();

        String insertSql = "INSERT INTO user_tb (uid, password) VALUES (?, ?)";
        pstmt = conn.prepareStatement(insertSql);
        pstmt.setString(1, uid);
        pstmt.setString(2, password);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            conn.commit();
            session.setAttribute("signupMessage", "회원가입이 성공적으로 완료되었습니다!");
            response.sendRedirect("layout.jsp?contentPage=sign_in.jsp");
        } else {
            conn.rollback();
            session.setAttribute("signupMessage", "회원가입에 실패했습니다. 다시 시도해주세요.");
            response.sendRedirect("layout.jsp?contentPage=sign_up.jsp");
        }

    } catch (SQLIntegrityConstraintViolationException e) {
        conn.rollback();
        if (e.getMessage().contains("uid")) {
            session.setAttribute("signupMessage", "이미 존재하는 아이디입니다.");
        } else {
            session.setAttribute("signupMessage", "데이터 중복 오류가 발생했습니다.");
        }
        response.sendRedirect("layout.jsp?contentPage=sign_up.jsp");
    } catch (Exception e) {
        try {
            if (conn != null) conn.rollback();
        } catch (SQLException rollbackEx) {
            System.err.println("Rollback failed: " + rollbackEx.getMessage());
        }
        System.err.println("에러 발생: " + e.getMessage());
        e.printStackTrace();
        session.setAttribute("signupMessage", "에러 발생.");
        response.sendRedirect("layout.jsp?contentPage=sign_up.jsp");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { System.err.println("ResultSet close error: " + e.getMessage()); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { System.err.println("PreparedStatement close error: " + e.getMessage()); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { System.err.println("Connection close error: " + e.getMessage()); }
    }
%>