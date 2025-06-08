<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DecimalFormat" %>

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

    int[] cartProductIds = new int[100];
    int[] cartQuantities = new int[100];
    int cartItemCount = 0; 
    Product[] cartProductArray = new Product[100];
    int actualProductCount = 0;
%>

<%
    request.setCharacterEncoding("UTF-8");
    DecimalFormat formatter = new DecimalFormat("###,###");

    String loggedInUserUid = (String) session.getAttribute("loggedInUser");
    boolean isLoggedIn = (loggedInUserUid != null);

    cartItemCount = 0; 
    actualProductCount = 0; 

    long totalProductPrice = 0;
    int deliveryFee = 2500;

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

        //로그인된 사용자 장바구니
        if (isLoggedIn) {
            int userId = -1;
            String getUserSql = "SELECT id FROM user_tb WHERE uid = ?";
            pstmt = conn.prepareStatement(getUserSql);
            pstmt.setString(1, loggedInUserUid);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("id");
            } else {
                session.setAttribute("cartMessage", "사용자 정보를 찾을 수 없습니다.");
                response.sendRedirect("layout.jsp?contentPage=index.jsp");
                return;
            }
            rs.close();
            pstmt.close();

            String getCartSql = "SELECT product_id, count FROM cart_tb WHERE user_id = ?";
            pstmt = conn.prepareStatement(getCartSql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            while (rs.next() && cartItemCount < 100) {
                cartProductIds[cartItemCount] = rs.getInt("product_id");
                cartQuantities[cartItemCount] = rs.getInt("count");
                cartItemCount++;
            }
            rs.close();
            pstmt.close();

        } else {
            //게스트 장바구니, 쿠키
            String guestCartCookieName = "guest_cart";
            String guestCartValue = "";
            Cookie[] cookies = request.getCookies();
            
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals(guestCartCookieName)) {
                        guestCartValue = cookie.getValue(); 
                        break;
                    }
                }
            }

            if (!guestCartValue.isEmpty()) {
                String[] items = guestCartValue.split("\\|"); 
                for (String item : items) {
                    String[] parts = item.split(":"); 
                    if (parts.length == 2 && cartItemCount < 100) { 
                        try {
                            cartProductIds[cartItemCount] = Integer.parseInt(parts[0]);
                            cartQuantities[cartItemCount] = Integer.parseInt(parts[1]);
                            cartItemCount++;
                        } catch (NumberFormatException e) {
                            // 유효하지 않은 쿠키 항목은 무시
                        }
                    }
                }
            }
        }

        //상품 정보 조회
        if (cartItemCount > 0) {
            StringBuilder productIdsInClause = new StringBuilder();
            for (int i = 0; i < cartItemCount; i++) {
                if (i > 0) {
                    productIdsInClause.append(",");
                }
                productIdsInClause.append(cartProductIds[i]);
            }

            String getProductsSql = "SELECT id, name, company, price, img_url FROM product_tb WHERE id IN (" + productIdsInClause.toString() + ")";
            pstmt = conn.prepareStatement(getProductsSql);
            rs = pstmt.executeQuery();

            while (rs.next() && actualProductCount < 100) {
                int pId = rs.getInt("id");
                int pQuantity = 0;

                for(int i = 0; i < cartItemCount; i++) {
                    if (cartProductIds[i] == pId) {
                        pQuantity = cartQuantities[i];
                        break;
                    }
                }

                if (pQuantity > 0) { 
                    cartProductArray[actualProductCount] = new Product(
                        pId,
                        rs.getString("name"),
                        rs.getString("company"),
                        rs.getInt("price"),
                        rs.getString("img_url"),
                        pQuantity
                    );
                    totalProductPrice += (long)rs.getInt("price") * pQuantity; 
                    actualProductCount++;
                }
            }
        }

    }  catch (Exception e) {
            out.println("에러 발생: " + e.getMessage());
    }   finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { System.err.println("ResultSet close error: " + e.getMessage()); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { System.err.println("PreparedStatement close error: " + e.getMessage()); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { System.err.println("Connection close error: " + e.getMessage()); }
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
    <div class="cart-main-content">
        <div class="cart-container">
            <% 
            if (actualProductCount == 0) { 
            %>
                <p class="empty-cart-message">장바구니가 비어 있습니다.</p>
            <% } else { %>
                <% 
                    for (int i = 0; i < actualProductCount; i++) { 
                        Product p = cartProductArray[i];
                %>
                    <div class="cart-item">
                        <img src="<%= p.getImgUrl() %>" alt="<%= p.getName() %>">
                        <div class="cart-item-info">
                            <p class="cart-item-company"><%= p.getCompany() %></p>
                            <p class="cart-item-name"><%= p.getName() %></p>
                        </div>
                        <div class="cart-item-price-quantity">
                            <p class="cart-item-subtotal"><strong><%= formatter.format((long)p.getPrice() * p.getQuantity()) %></strong> 원</p>
                            <div class="cart-item-quantity-controls">
                                <form action="<%= request.getContextPath() %>/cart_quantity_process.jsp" method="post">
                                    <input type="hidden" name="product_id" value="<%= p.getId() %>">
                                    <input type="hidden" name="action" value="decrease">
                                    <button type="submit" class="quantity-btn">-</button>
                                </form>
                                
                                <span class="quantity-display"><%= p.getQuantity() %></span>
                                <form action="<%= request.getContextPath() %>/cart_quantity_process.jsp" method="post">
                                    <input type="hidden" name="product_id" value="<%= p.getId() %>">
                                    <input type="hidden" name="action" value="increase">
                                    <button type="submit" class="quantity-btn">+</button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>

        <div class="cart-calculator">
            <h3>주문 예상 금액</h3>
            <div class="calc-row">
                <span>총 상품 가격</span>
                <span><%= formatter.format(totalProductPrice) %> 원</span>
            </div>
            <div class="calc-row">
                <span>배송비</span>
                <span><%= formatter.format(deliveryFee) %> 원</span>
            </div>
            <div class="calc-total">
                <span>총 주문 금액</span>
                <span><%= formatter.format(totalProductPrice + deliveryFee) %> 원</span>
            </div>
            <button type="button" class="order-button">주문하기</button>
        </div>
        
        <% if (session.getAttribute("cartMessage") != null) { %>
            <script>
                alert('<%= session.getAttribute("cartMessage") %>');
                <% session.removeAttribute("cartMessage"); %>
            </script>
        <% } %>
    </div>
</body>
</html>