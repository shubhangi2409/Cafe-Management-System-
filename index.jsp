<%@ page import="java.sql.*" %>
<%@ page import="com.cafe.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
    <title>Mini Cafe</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- Header -->
<header>
    <h1> Mini Cafe</h1>
    <nav>
        <a href="index.jsp">Home </a>
        <a href="order.jsp">Order </a>
        <a href="orderStatus.jsp">Track Order </a>
        <a href="feedback.jsp">Feedback </a>
        <a href="login.jsp">Login </a>
    </nav>
</header>

<!-- Hero Section -->
<section class="hero">
    <h2 style="color: white;">Welcome to Mini Cafe </h2>
    <p style="color: white;">Fresh Coffee | Tasty Food  | Best Experience </p>
    <br>
    <a href="order.jsp">
        <button>Order Now </button>
    </a>
</section>

<!-- Menu Section -->
<section class="menu">
    <h2 style="color: white;">Our Popular Items </h2>

    <div class="items">

        <!-- 🔹 STATIC ITEMS -->
        <div class="item">
            <img src="images/coffee.jpg">
            <h3>Coffee </h3>
            <p>RS : 50</p>
        </div>

        <div class="item">
            <img src="images/pizza.jpg">
            <h3>Pizza </h3>
            <p>RS : 150</p>
        </div>

        <div class="item">
            <img src="images/burger.jpg">
            <h3>Burger </h3>
            <p>RS : 100</p>
        </div>

        <!-- 🔹 DYNAMIC ITEMS FROM DATABASE -->
        <%
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            if(con != null){
                st = con.createStatement();
                rs = st.executeQuery("SELECT * FROM items");

                while(rs.next()){
        %>

        <div class="item">
            <img src="images/<%= rs.getString("image") %>">
            <h3><%= rs.getString("item_name") %> </h3>
            <p>RS : <%= rs.getInt("price") %></p>
        </div>

        <%
                }
            } else {
        %>
            <p style="color:red;">Database not connected </p>
        <%
            }

        } catch(Exception e){
        %>
            <p style="color:red;">Error: <%= e.getMessage() %></p>
        <%
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e){}
            try { if(st != null) st.close(); } catch(Exception e){}
            try { if(con != null) con.close(); } catch(Exception e){}
        }
        %>

    </div>
</section>

<!-- Footer -->
<footer>
    <p> Mini Cafe </p>
</footer>

</body>
</html>
