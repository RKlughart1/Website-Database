<!DOCTYPE html>
<html>

<head>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,700">
    <link rel="stylesheet" href="assets/fonts/font-awesome.min.css">
    <link rel="stylesheet" href="assets/fonts/line-awesome.min.css">
    <title>Ray's Grocery CheckOut Line</title>
    <style>
        html {
            font-family: Segoe, "Segoe UI", "DejaVu Sans", "Trebuchet MS", Verdana, "sans-serif";
            text-align: center;
            margin: auto;
            width: 50%;
            padding: 10px;
            margin-top: 5%;
        }
    </style>
</head>

<body>

    <h1>Enter your customer id and password to complete the transaction:</h1>
<br>
    <form method="get" action="order.jsp">
        <label>ID:</label><br><input type="text" name="userId" size="30">

        <br><br>
        <label>Password:</label><br><input type="password" name="password" size="30">
        <br><br><br>
        <input type="submit" class="btn btn-dark" value="Submit">&nbsp;&nbsp;&nbsp;<input type="reset" class="btn btn-dark" value="Reset">
    </form>
<script src="assets/js/jquery.min.js"></script>
<script src="assets/bootstrap/js/bootstrap.min.js"></script>
</body>

</html>