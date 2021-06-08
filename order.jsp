<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8" %>
<!DOCTYPE html>
<html>

<head>
    <style>
        .checkmark__circle {
            stroke-dasharray: 166;
            stroke-dashoffset: 166;
            stroke-width: 2;
            stroke-miterlimit: 10;
            stroke: #7ac142;
            fill: none;
            animation: stroke 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards;
        }

        .checkmark {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            stroke-width: 2;
            stroke: #fff;
            stroke-miterlimit: 10;
            box-shadow: inset 0px 0px 0px #7ac142;
            animation: fill .4s ease-in-out .4s forwards, scale .3s ease-in-out .9s both;
        }

        .checkmark__check {
            transform-origin: 50% 50%;
            stroke-dasharray: 48;
            stroke-dashoffset: 48;
            animation: stroke 0.3s cubic-bezier(0.65, 0, 0.45, 1) 0.8s forwards;
        }

        @keyframes stroke {
            100% {
                stroke-dashoffset: 0;
            }
        }

        @keyframes scale {

            0%,
            100% {
                transform: none;
            }

            50% {
                transform: scale3d(1.1, 1.1, 1);
            }
        }

        @keyframes fill {
            100% {
                box-shadow: inset 0px 0px 0px 30px #7ac142;
            }
        }

        html {
            font-family: Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, "sans-serif";
            text-align: center;
            margin: auto;
            width: 50%;
            padding: 10px;
        }

        .center {
            margin-left: auto;
            margin-right: auto;
        }

        .slide-in-left {
            -webkit-animation: slide-in-left 0.5s cubic-bezier(0.250, 0.460, 0.450, 0.940) both;
            animation: slide-in-left 0.5s cubic-bezier(0.250, 0.460, 0.450, 0.940) both;
        }

        @-webkit-keyframes slide-in-left {
            0% {
                -webkit-transform: translateX(-1000px);
                transform: translateX(-1000px);
                opacity: 0;
            }

            100% {
                -webkit-transform: translateX(0);
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slide-in-left {
            0% {
                -webkit-transform: translateX(-1000px);
                transform: translateX(-1000px);
                opacity: 0;
            }

            100% {
                -webkit-transform: translateX(0);
                transform: translateX(0);
                opacity: 1;
            }
        }

        .scale-in-center {
            -webkit-animation: scale-in-center 0.5s cubic-bezier(0.250, 0.460, 0.450, 0.940) both;
            animation: scale-in-center 0.5s cubic-bezier(0.250, 0.460, 0.450, 0.940) both;
        }

        @-webkit-keyframes scale-in-center {
            0% {
                -webkit-transform: scale(0);
                transform: scale(0);
                opacity: 1;
            }

            100% {
                -webkit-transform: scale(1);
                transform: scale(1);
                opacity: 1;
            }
        }

        @keyframes scale-in-center {
            0% {
                -webkit-transform: scale(0);
                transform: scale(0);
                opacity: 1;
            }

            100% {
                -webkit-transform: scale(1);
                transform: scale(1);
                opacity: 1;
            }
        }
    </style>

    <title>YOUR NAME Grocery Order Processing</title>
</head>

<body class="slide-in-left">
    <%--<svg class="checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">--%>
    <%--    <circle class="checkmark__circle" cx="26" cy="26" r="25" fill="none"/>--%>
    <%--    <path class="checkmark__check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>--%>
    <%--</svg>--%>
    <%


    // Get customer id
    String userId = request.getParameter("userId");
    String custPw = request.getParameter("password");
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");


    String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
    String uid = "SA";
    String pw = "YourStrong@Passw0rd";
    String customerIdCheck = "";


    try {    // Load driver class
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }
    String custId = null;


    try (Connection con = DriverManager.getConnection(url, uid, pw);
         Statement stmt = con.createStatement();) {


        try (Statement statement = con.createStatement()) {
            String queryLogin = "SELECT customerId FROM customer WHERE userid = '" + userId + "' AND password = '" + custPw + "'";
            //SELECT customerId FROM customer WHERE userid = 'arnold' AND password = 'test'
            ResultSet rst = statement.executeQuery(queryLogin);
            rst.next();
            custId = rst.getString(1);
        } catch (Exception e){
            out.println("<h1>Invalid Login</h1>");
        }
        //Checking for valid customer ID
        if (custId != null && userId !=null) {
            try (Statement statement = con.createStatement()) {

                String query = "Select customerId from customer where customerId = " + custId;
                ResultSet rst = statement.executeQuery(query);
                rst.next();
                customerIdCheck = rst.getString(1);


            } catch (SQLException ex) {

            }
            if (!customerIdCheck.equals(custId)) {
                out.println("Invalid Username and Password. Go back to the previous page and try again.");
            } else {

                if (productList == null) {
                    //Shopping Cart is Empty
                    out.println("<H1>Your shopping cart is empty!</H1>");
                    out.println("<a href='listprod.jsp'><h2>Return to Shopping</h2></a>");

                    productList = new HashMap<String, ArrayList<Object>>();
                } else if (custId!=null){
                    NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);

                    out.println("<h1>Your Order Summary</h1>");
                    out.print("<table class=\"center scale-in-center\"><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
                    out.println("<th>Price</th><th>Subtotal</th></tr>");

                    double total = 0;
                    String ordId = "";

                    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                    //Insert Customer ID into orderSummary to generate new order ID
                    try (Statement statement = con.createStatement()) {

                        String query = "insert into ordersummary(customerId) values (" + custId + ")";
                        statement.executeUpdate(query);
                    } catch (SQLException ex) {
                        out.println(ex);
                    }

                    while (iterator.hasNext()) {
                        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                        if (product.size() < 4) {
                            out.println("Expected product with four entries. Got: " + product);
                            continue;
                        }
                        //Printing table of ordered products

                        out.print("<tr><td>" + product.get(0) + "</td>");
                        out.print("<td>" + product.get(1) + "</td>");
                        Object prodName = product.get(1);
                        //out.println(prodName);

                        out.print("<td align=\"center\">" + product.get(3) + "</td>");
                        Object price = product.get(2);
                        Object itemqty = product.get(3);
                        double pr = 0;
                        int qty = 0;

                        try {
                            pr = Double.parseDouble(price.toString());
                        } catch (Exception e) {
                            out.println("Invalid price for product: " + product.get(0) + " price: " + price);
                        }
                        try {
                            qty = Integer.parseInt(itemqty.toString());
                        } catch (Exception e) {
                            out.println("Invalid quantity for product: " + product.get(0) + " quantity: " + qty);
                        }

                        out.print("<td align=\"right\">" + currFormat.format(pr) + "</td>");
                        out.print("<td align=\"right\">" + currFormat.format(pr * qty) + "</td></tr>");
                        out.println("</tr>");
                        total = total + pr * qty;


                        try (Statement statement = con.createStatement()) {

                            //Retrieving generated order ID and inserting into orderproduct

                            String query = "select orderId from ordersummary where customerId=" + custId + "order by orderId desc";
                            ResultSet rst = statement.executeQuery(query);
                            rst.next();
                            ordId = rst.getString(1);


                            String insert = "insert into orderproduct(orderId,productId,price,quantity) values(" + ordId + "," + product.get(0) + "," + product.get(2) + "," + product.get(3) + ")";
                            statement.executeUpdate(insert);
                        } catch (SQLException ex) {
                            out.println(ex);
                        }

                    }

                    String custName = "";
                    try (Statement statement = con.createStatement()) {

                        //Updating Total Amount and Date and retrieving customer name to ship to

                        String updat = "update ordersummary set totalAmount = " + total + " where orderId = " + ordId;
                        statement.executeUpdate(updat);
                        String update2 = "update ordersummary set totalAmount = " + total + ", orderDate = CURRENT_TIMESTAMP where orderId = " + ordId;
                        statement.executeUpdate(update2);
                        String query = "Select concat(firstName,' ',lastName) from customer where customerId = " + custId;
                        ResultSet rst = statement.executeQuery(query);
                        rst.next();
                        custName = rst.getString(1);

                    } catch (SQLException ex) {
                        out.println(ex);
                    }

                    out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
                            + "<td align=\"right\">" + currFormat.format(total) + "</td></tr>");
                    out.println("</table>");
                    out.println("<div class=\"scale-in-center\"> <svg width=\"54px\" height=\"54px\" class=\"checkmark \" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 52 52\"> <circle class=\"checkmark__circle\" cx=\"26\" cy=\"26\" r=\"25\" fill=\"none\"/> <path class=\"checkmark__check\" fill=\"none\" d=\"M14.1 27.2l7.1 7.2 16.7-16.8\"/> </svg></div>");

                    out.println("<h3>Order Completed. Will be shipped soon</h3>");
                    out.println("<h3>" + "Shipping to Customer: " + custId + " Name: " + custName + "</h3>");
                    //DELETE CART
                    session.setAttribute("productList", null);
                    out.println("<a href='listprod.jsp'><h2>Return to Shopping</h2></a>");


                }
            }
        } else {
            out.println("Invalid Username and Password. Go back to the previous page and try again.");
            out.println("<a href='listprod.jsp'><h2>Return to Shopping</h2></a>");
        }
    } catch (SQLException ex) {
        out.println(ex);
    }

%>

</BODY>

</HTML>