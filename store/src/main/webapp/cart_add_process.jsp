<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String productIdStr = request.getParameter("product_id");
    int productId = 0;
    try {
        productId = Integer.parseInt(productIdStr);
    } catch (NumberFormatException e) {
        session.setAttribute("cartMessage", "유효하지 않은 상품 정보입니다.");
        response.sendRedirect("layout.jsp?contentPage=product_list.jsp");
        return;
    }

    String loggedInUserUid = (String) session.getAttribute("loggedInUser");
    boolean isLoggedIn = (loggedInUserUid != null);

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

        if (isLoggedIn) {
            //로그인된 사용자 장바구니
            int userId = -1;
            String getUserSql = "SELECT id FROM user_tb WHERE uid = ?";
            pstmt = conn.prepareStatement(getUserSql);
            pstmt.setString(1, loggedInUserUid);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("id");
            } else {
                session.setAttribute("cartMessage", "사용자 정보를 찾을 수 없습니다.");
                response.sendRedirect("layout.jsp?contentPage=product_list.jsp");
                return;
            }
            rs.close();
            pstmt.close();

            String checkCartSql = "SELECT count FROM cart_tb WHERE user_id = ? AND product_id = ?";
            pstmt = conn.prepareStatement(checkCartSql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, productId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int currentCount = rs.getInt("count");
                String updateCartSql = "UPDATE cart_tb SET count = ? WHERE user_id = ? AND product_id = ?";
                pstmt.close();
                pstmt = conn.prepareStatement(updateCartSql);
                pstmt.setInt(1, currentCount + 1);
                pstmt.setInt(2, userId);
                pstmt.setInt(3, productId);
                pstmt.executeUpdate();
                session.setAttribute("cartMessage", "상품 수량이 증가되었습니다.");
            } else {
                String insertCartSql = "INSERT INTO cart_tb (user_id, product_id, count) VALUES (?, ?, 1)";
                pstmt.close();
                pstmt = conn.prepareStatement(insertCartSql);
                pstmt.setInt(1, userId);
                pstmt.setInt(2, productId);
                pstmt.executeUpdate();
                session.setAttribute("cartMessage", "상품이 장바구니에 추가되었습니다.");
            }

        } else {
            //게스트 장바구니, 쿠키
            String guestCartCookieName = "guest_cart";
            String guestCartValue = "";
            Cookie[] cookies = request.getCookies();
            
            //현재 쿠키 값
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals(guestCartCookieName)) {
                        guestCartValue = cookie.getValue();
                        break;
                    }
                }
            }

            //쿠키 값 파싱, 저장
            int[] tempProductIds = new int[100];
            int[] tempQuantities = new int[100];
            int currentGuestItemCount = 0;

            if (!guestCartValue.isEmpty()) {
                String[] items = guestCartValue.split("\\|");
                for (String item : items) {
                    String[] parts = item.split(":");
                    if (parts.length == 2 && currentGuestItemCount < 100) {
                        try {
                            tempProductIds[currentGuestItemCount] = Integer.parseInt(parts[0]);
                            tempQuantities[currentGuestItemCount] = Integer.parseInt(parts[1]);
                            currentGuestItemCount++;
                        } catch (NumberFormatException e) {
                            // 유효하지 않은 쿠키 항목은 무시
                        }
                    }
                }
            }

            //장바구니에 있는지 확인, 수량 업데이트
            boolean productFound = false;
            for (int i = 0; i < currentGuestItemCount; i++) {
                if (tempProductIds[i] == productId) {
                    tempQuantities[i]++;
                    productFound = true;
                    session.setAttribute("cartMessage", "장바구니 상품 수량이 증가되었습니다 (게스트).");
                    break;
                }
            }

            // 장바구니에 없는 상품일 경우
            if (!productFound) {
                if (currentGuestItemCount < 100) {
                    tempProductIds[currentGuestItemCount] = productId;
                    tempQuantities[currentGuestItemCount] = 1;
                    currentGuestItemCount++;
                    session.setAttribute("cartMessage", "상품이 장바구니에 추가되었습니다 (게스트).");
                } else {
                    session.setAttribute("cartMessage", "장바구니에 더 이상 상품을 추가할 수 없습니다 (용량 초과).");
                }
            }

            //쿠키 저장
            StringBuilder newGuestCartValueBuilder = new StringBuilder();
            for (int i = 0; i < currentGuestItemCount; i++) {
                if (newGuestCartValueBuilder.length() > 0) {
                    newGuestCartValueBuilder.append("|");
                }
                newGuestCartValueBuilder.append(tempProductIds[i]).append(":").append(tempQuantities[i]);
            }
            String newGuestCartValue = newGuestCartValueBuilder.toString();

            Cookie guestCartCookie = new Cookie(guestCartCookieName, newGuestCartValue);
            guestCartCookie.setMaxAge(60 * 60 * 24 * 7);
            guestCartCookie.setPath(request.getContextPath() + "/");
            response.addCookie(guestCartCookie);
        }

    }  catch (Exception e) {
            out.println("에러 발생: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { System.err.println("ResultSet close error: " + e.getMessage()); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { System.err.println("PreparedStatement close error: " + e.getMessage()); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { System.err.println("Connection close error: " + e.getMessage()); }
    }

    response.sendRedirect("layout.jsp?contentPage=product_list.jsp");
%>