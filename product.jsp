<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Stream Foods - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
// Get product name to search for
// TODO: Retrieve and display info for the product

String productId = request.getParameter("id");

String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";



try{
    NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);
    String sql = "Select productName, productPrice,productImage from product where productId = "+productId;
    Connection con = DriverManager.getConnection(url, uid, pw);
    PreparedStatement pstmt = con.prepareStatement(sql); 
    ResultSet rs = pstmt.executeQuery();
    rs.next();
    String name = rs.getString(1);
    String price = currFormat.format(rs.getDouble(2));
    //String image = rs.getString(3);
    //out.println(image);
    out.println("<h1>"+name+"</h1>");
    out.println("<img src= 'img/" + productId + ".jpg'>");
    out.println("<table><tr><td><b>Id</b></td><td>"+productId+"</td></tr>");
    out.println("<tr><td><b>Price</b></td><td>"+price+"</td></tr></table>");
        //out.println(name+" "+price);
    out.println("\n<a href='addcart.jsp?id=" + productId + "&name=" + name + "&price=" + price + "'><h3>Add to cart</h3></a>"); 
    } 
    catch (Exception e){
       out.println("<h1>"+e+"</h1>");
    }

//String sql = "Select productName, productPrice from product where productId = "+productId;
//outprintln(productId,productName,productPrice)
// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
%>
<h3><a href="listprod.jsp">Continue Shopping</a></h3>
</body>
</html>

