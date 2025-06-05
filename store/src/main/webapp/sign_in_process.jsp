<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    String uid = request.getParameter("uid");
    String password = request.getParameter("password");

    String driverName = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/store_db";
    String dbUser = "root";
    String dbPassword = "123456";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName(driverName);

        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        String sql = "SELECT uid FROM user_tb WHERE uid = ? AND password = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, uid);
        pstmt.setString(2, password);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            // 세션에 사용자 정보 저장
            session.setAttribute("loggedInUser", uid);
            session.setAttribute("signupMessage", uid + "님, 환영합니다!");

            response.sendRedirect("layout.jsp?contentPage=index.jsp");
        } else {
            session.setAttribute("signupMessage", "아이디 또는 비밀번호가 올바르지 않습니다.");

            response.sendRedirect("layout.jsp?contentPage=sign_in.jsp");
        }

    } catch (Exception e) {
            out.println("에러 발생: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { System.err.println("ResultSet close error: " + e.getMessage()); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { System.err.println("PreparedStatement close error: " + e.getMessage()); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { System.err.println("Connection close error: " + e.getMessage()); }
    }
%>