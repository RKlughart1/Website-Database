<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>

<head>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,700">
    <link rel="stylesheet" href="assets/fonts/font-awesome.min.css">
    <link rel="stylesheet" href="assets/fonts/line-awesome.min.css">
    <link rel="stylesheet" href="assets/css/Dark-NavBar-1.css">
    <link rel="stylesheet" href="assets/css/Dark-NavBar-2.css">
    <link rel="stylesheet" href="assets/css/Dark-NavBar.css">
    <link rel="stylesheet" href="assets/css/Header-Blue.css">
    <link rel="stylesheet" href="assets/css/Highlight-Clean.css">
    <link rel="stylesheet" href="assets/css/Navbar---Apple-1.css">
    <link rel="stylesheet" href="assets/css/Navbar---Apple.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <title>Grocery Order List</title>
    <style>
        tr,
        th,
        td {
            border: 1px solid grey;
            padding: 10px;
            overflow: hidden;
        }

        th {
            text-align: left;

        }

        table {
            table-layout: fixed;
            width: 100%;
            border-collapse: collapse;
        }

        body {
            font-family: 'Roboto', sans-serif;
        }
        span{
            background: rgb(119,158,203);
            border-radius: 10%;
            padding: .5em 1.3em;
            color:white;
                box-decoration-break: clone;
        }
       
    </style>
</head>

<body>
<nav class="navbar navbar-dark navbar-expand-md fixed-top bg-dark navbar--apple">
    <div class="container"><button data-toggle="collapse" class="navbar-toggler" data-target="#menu"><span
                class="sr-only">Toggle navigation</span><span class="navbar-toggler-icon"><i
                    class="la la-navicon"></i></span></button>
        <div class="collapse navbar-collapse" id="menu">
            <ul class="nav navbar-nav flex-grow-1 justify-content-between">
            <li class="nav-item d-none d-xs-block d-md-block" style="color:white">Stream Grocery</li>
                <li class="nav-item"><a class="nav-link" href="shop.html">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="listprod.jsp">Shop</a></li>
                <li class="nav-item"><a class="nav-link" href="listorder.jsp">Orders</a></li>
                <li class="nav-item d-none d-xs-block d-md-block"><a class="nav-link" href="showcart.jsp"><i
                            class="fa fa-shopping-bag"></i></a></li>
            </ul>
        </div>
    </div>
</nav>
<br><br><br><br><br>
    <h1 style="text-align: center;"><u>Order List</u></h1>
<br><br>
    <%
    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";

// Get product name to search for
    String name = request.getParameter("productName");

//Note: Forces loading of SQL Server driver
    try { // Load driver class
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
// Create statement
//Statement stmt = con.createStatement();


    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    
     NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);

    try (Connection con = DriverManager.getConnection(url, uid, pw);
        Statement stmt = con.createStatement();Statement stmt2 = con.createStatement();Statement stmt3 = con.createStatement();) {
         
        ResultSet rst = stmt.executeQuery("SELECT OS.orderID,OS.orderDate,OS.totalAmount,C.customerId,CONCAT(C.firstName,' ', C.lastName) as CustName FROM ordersummary OS, customer C where OS.customerId = C.customerId");
        out.println("<table style = 'width: 100%' class='table table-striped'>");
        out.println("<tr><th><b>Order Id</b></th><th style = 'text-align: center;'><b>Order Date</b></th><th><b>Customer Id</b><th><b>Customer Name</b></th><th><b>Total Amount</b></th></tr>");
        while (rst.next()) {
            String OID = rst.getString(1);
            out.println("<tr><td>" + rst.getString(1) + "</td>" + "<td>" + rst.getString(2) + "</td>" + "<td>" + rst.getString(4) +  "</td><td>" + rst.getString(5) + "</td>" + "<td>" + currFormat.format(rst.getDouble(3)) +  "</td></tr>");
            ResultSet rst2 = stmt2.executeQuery("Select P.productId, OP.quantity, OP.price from product P, orderproduct OP where P.productId = OP.productId and orderId = "+OID+"");
            out.println("<tr><td colspan=5><table style ='float: right'><tr><td><b>Product Id</b><td><b>Quantity</b></td><td><b>Price</b></td></tr>");
            while (rst2.next()) {
                
                out.println("<tr style = 'right'><td>" + rst2.getString(1) + "</td>" + "<td>" + rst2.getString(2) + "</td>" + "<td>" + currFormat.format(rst2.getDouble(3)) +  "</td></tr>");
            }
            ResultSet rst3 = stmt3.executeQuery("Select sum(quantity) from orderproduct where orderId = "+OID+" group by orderId");
            rst3.next();
            String totalQuantity = rst3.getString(1);
            out.println("<tr><td><span>Total:</span></td><td>"+totalQuantity+"</td><td>"+ currFormat.format(rst.getDouble(3))+"</td></tr>");
            out.println("</table></td></tr>");
            
        }
        out.println("</table>");
    } catch (SQLException ex) {
        out.println(ex);
    }
// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection
%>
<script src="assets/js/jquery.min.js"></script>
<script src="assets/bootstrap/js/bootstrap.min.js"></script>
<script src="assets/js/Navbar---Apple.js"></script>

</body>

</html>