<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
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
    <title>Stream Grocery</title>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
        }

        tr,
        th,
        td {
            border: 1px solid grey;
            padding: 10px;
            overflow: hidden;
        }

        table {
            table-layout: fixed;
            width: 100%;
            border-collapse: collapse;
        }
        

        .list {
            margin-top: 3%;
        }

        a {
            text-decoration: none;
            color: lightseagreen;
        }

        a:hover {
            color: royalblue;
        }

        .Beverages {
            color: blue;
        }

        .Condiments {
            color: red;
        }

        .Produce {
            color: green;
        }

        .MP {
            color: orange;
        }

        .Seafood {
            color: lightskyblue;
        }

        .DP {
            color: purple;
        }

        .GC {
            color: brown;
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
    <h1 style="text-align: center;">Browse Products By Category and Search by Product Name:</h1>
    <br><br>
    <form method="get" action="listprod.jsp" style="text-align: center;">
        <select id="category" name="category">
            <option value="All" selected>All</option>
            <option value="Beverages">Beverages</option>
            <option value="Condiments">Condiments</option>
            <option value="Confections">Confections</option>
            <option value="Dairy Products">Dairy Products</option>
            <option value="Grains/Cereals">Grains/Cereals</option>
            <option value="Meat/Poultry">Meat/Poultry</option>
            <option value="Produce">Produce</option>
            <option value="Seafood">Seafood</option>
        </select>
        <input type="text" name="productName" size="50">
        <input type="submit" class="btn btn-dark" value="Submit">
        <input type="reset" class="btn btn-dark" value="Reset">
    
    </form>

    <%


    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";

// Get product name to search for

    String name = request.getParameter("productName");
    String ctg = request.getParameter("category");

//Note: Forces loading of SQL Server driver
    try { // Load driver class
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
// Create statement
//Statement stmt = con.createStatement();

        //out.print("<h1>Database Loaded</h1>");

    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }


    try (Connection con = DriverManager.getConnection(url, uid, pw);
         Statement stmt = con.createStatement();) {
        ResultSet rst = null;

        String query = "SELECT productName, productPrice,category.categoryName,productId FROM product JOIN category on product.categoryId = category.categoryId";
        String conditionName = " WHERE productName LIKE '%" + name + "%' ";
        String conditionCategory = " AND categoryName LIKE '" + ctg + "'";
        String compiledQuery = query;
        if (name != null) {
            compiledQuery += conditionName;
        }
        if (ctg != null) {
            if (ctg.contains("All")) {
            } else {
                compiledQuery += conditionCategory;
            }
        }
        out.println("<h2 id='title' class='list'>All Products</h2>");

        String namePrint = " ";
        try {
            if (!name.isEmpty()) {
                namePrint = " Contains '" + name + "'";
            }
        }catch(Exception e){
            
        }

        if (ctg != null) {
            if (ctg.contains("All")) {
                out.println("<script> "
                        + "var input = document.getElementById(\"title\").innerHTML = \"" + "All Products" + namePrint + "\";"
                        + "</script>");
            } else {
                out.println("<script> "
                        + "var input = document.getElementById(\"title\").innerHTML = \"" + ctg + namePrint + "\";"
                        + "</script>");
            }
        }

        rst = stmt.executeQuery(compiledQuery);
        //Currency
        NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);

        out.println("<table class='table table-striped'><tr><th style='width: 10%;font-weight: bold;'>  </th><th style='width: 55%;font-weight: bold;text-align: left;'>Product Name</th><th style='width: 20%;font-weight: bold;text-align: left;'>Category</th><th style = 'font-weight: bold;text-align: left;'>Price</th></tr>");
        //out.println(ctg);


        while (rst.next()) {
            //addcart.jsp?id=(productId)&name=(productName)&price=(productPrice)
            String category = rst.getString(3);

            if (category.equals("Meat/Poultry")) {
                category = "MP";
            }
            if (category.equals("Dairy Products")) {
                category = "DP";
            }
            if (category.equals("Grains/Cereals")) {
                category = "GC";
            }

            out.println("<tr class = \"" + category + "\"><td class='link'>" +
                    "<a href='addcart.jsp?id=" + rst.getString(4) + "&name=" + rst.getString(1) + "&price=" + rst.getString(2) + "'>"
                    + "Add to cart</a>  " + "</td>" 
                    + "<td class='name'>" + "<a href='product.jsp?id=" + rst.getString(4) +"'> " + rst.getString(1) + " </a> </td>" 
                    + "<td class='category'>" + rst.getString(3) + "</td>" 
                    + "<td class='price'>" + currFormat.format(rst.getDouble(2)) + "</td> </tr>");
        }
        out.println("</table>");
        //Closing connection
        stmt.close();
        rst.close();
    } catch (SQLException ex) {
        out.println(ex);
    }


// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset. Make sure to use PreparedStatement!

// Make the connection

// Print out the ResultSet

// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice
// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0); // Prints $5.00
%>
<script src="assets/js/jquery.min.js"></script>
<script src="assets/bootstrap/js/bootstrap.min.js"></script>
<script src="assets/js/Navbar---Apple.js"></script>
</body>

</html>