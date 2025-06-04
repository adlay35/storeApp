<!DOCTYPE html>
<html>
<body>
    <jsp:forward page="/layout.jsp">
        <jsp:param name="contentPage" value="/product_list.jsp"/>
        <jsp:param name="company" value="all"/>
    </jsp:forward>
</body>
</html>