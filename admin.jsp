<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file = 'auth.jsp'%>
<%@ include file = 'jdbc.jsp'%>

<%
// TODO: Include files auth.jsp and jdbc.jsp
// TODO: Write SQL query that prints out total order amount by day
try{
    if (session.getAttribute("authenticatedUser") == null)
    {
    response.sendRedirect("login.jsp");
    }
    else{
        NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.CANADA);
        getConnection();
        String sql = "Select sum(totalAmount), orderDate from orderSummary group by orderDate";
        String update = "Update orderSummary set orderDate = convert(varchar(10),orderDate,111)";
        Statement stmt = con.createStatement(); 
        stmt.executeUpdate(update);
        ResultSet rs = stmt.executeQuery(sql);
        out.println("<h1>Administrator Sales Report by Day</h1><br><table border=1><th><b>Order Date</b></th><th><b>Total Order Amount</b></th>");
        while(rs.next()){
            Date date = rs.getDate(2);
            out.println("<tr><td>"+date+"</td><td>"+currFormat.format(rs.getDouble(1))+"</td></tr>");
        }
        out.println("</table>");
    
    }
    } 
catch (Exception e){
    out.println("<h1>"+e+"</h1>");
    }
finally{
        try{
            closeConnection();
        }
        catch(Exception e){
            
        }
    }
    

%>
</body>
</html>

