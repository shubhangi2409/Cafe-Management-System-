<%@ page import="java.sql.*" %>
<%@ page import="com.cafe.DBConnection" %>
<%@ page import="com.cafe.OrderBillHelper" %>
<%@ page import="com.cafe.OrderStatusHelper" %>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f5f5f5;
        }

        .sidebar {
            width: 220px;
            height: 100vh;
            background: #333;
            color: white;
            float: left;
            padding: 20px;
            box-sizing: border-box;
        }

        .sidebar h2 {
            text-align: center;
            margin-bottom: 30px;
        }

        .sidebar a {
            color: white;
            display: block;
            margin: 12px 0;
            text-decoration: none;
            padding: 10px;
            border-radius: 5px;
        }

        .sidebar a:hover {
            background: #800000;
        }

        .topbar {
            margin-left: 220px;
            padding: 15px 25px;
            background: #555;
            color: white;
            text-align: right;
        }

        .main {
            margin-left: 220px;
            padding: 25px;
        }

        h2 {
            color: #800000;
        }

        table {
            width: 90%;
            border-collapse: collapse;
            text-align: center;
            background: white;
            box-shadow: 0 0 8px #ccc;
        }

        th {
            background-color: #800000;
            color: white;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ccc;
        }

        tr:hover {
            background-color: #f2f2f2;
        }

        .msg {
            color: red;
            font-weight: bold;
        }

        .notice {
            width: 90%;
            margin: 0 0 20px 0;
            padding: 14px 18px;
            background: #fff4d6;
            border-left: 5px solid #800000;
            color: #5a3200;
            box-shadow: 0 0 8px #ddd;
        }

        .status {
            font-weight: bold;
        }

        .status.pending {
            color: #9c6a00;
        }

        .status.ready {
            color: green;
        }

        .status.rejected {
            color: red;
        }

        .bill-link {
            color: #800000;
            font-weight: bold;
            text-decoration: none;
        }

        .bill-link:hover {
            text-decoration: underline;
        }

        .bill-btn {
            display: inline-block;
            background: #1e5aa8;
            color: white;
            padding: 8px 14px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
        }

        .bill-btn:hover {
            background: #15437d;
        }
    </style>
</head>

<body>

<div class="sidebar">
    <h2 style="color:white;">Admin</h2>
    <a href="admin.jsp">View Orders</a>
    <a href="cook.jsp">Cook / Shape Page</a>
    <a href="manageItems.jsp">Manage Items</a>
    <a href="viewFeedback.jsp">View Feedback</a>
    <a href="index.jsp">Logout</a>
</div>

<div class="topbar">
     Admin
</div>

<div class="main">

    <h2>All Orders</h2>

<%
String confirmedName = request.getParameter("confirmedName");
String confirmedItem = request.getParameter("confirmedItem");
String confirmedStatus = OrderStatusHelper.normalizeStatus(request.getParameter("status"));
String billError = request.getParameter("billError");

if (confirmedName != null && confirmedItem != null
        && !confirmedName.trim().equals("") && !confirmedItem.trim().equals("")) {
    String noticeMessage = confirmedItem + " order for " + confirmedName + " is confirmed. Deliver your food soon.";

    if (OrderStatusHelper.REJECTED.equals(confirmedStatus)) {
        noticeMessage = confirmedItem + " order for " + confirmedName + " is rejected. Sorry I cant reach. Try again.";
    }
%>
    <div class="notice">
        <%= noticeMessage %>
    </div>
<%
}

if ("invalid".equals(billError)) {
%>
    <div class="notice">
        Unable to open that bill. Please choose a valid order.
    </div>
<%
} else if ("missing".equals(billError)) {
%>
    <div class="notice">
        That bill was not found in the orders list.
    </div>
<%
}
%>

    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Item</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Total Bill</th>
            <th>Status</th>
            <th>Bill</th>
        </tr>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;

try {
    con = DBConnection.getConnection();

    if (con == null) {
%>
        <tr>
            <td colspan="8" class="msg">Database connection failed</td>
        </tr>
<%
    } else {
        OrderStatusHelper.ensureStatusColumn(con);
        OrderBillHelper.ensureUnitPriceColumn(con);
        st = con.createStatement();
        rs = st.executeQuery("SELECT * FROM orders ORDER BY id DESC");

        boolean hasData = false;

        while (rs.next()) {
            hasData = true;
            String status = OrderStatusHelper.normalizeStatus(rs.getString("status"));
            String statusClass = status.toLowerCase();
%>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("item") %></td>
            <td>RS : <%= rs.getInt("unit_price") %></td>
            <td><%= rs.getInt("quantity") %></td>
            <td>
                <a class="bill-link" href="orderBill.jsp?id=<%= rs.getInt("id") %>">
                    RS : <%= rs.getInt("total") %>
                </a>
            </td>
            <td class="status <%= statusClass %>"><%= status %></td>
            <td>
                <a class="bill-btn" href="orderBill.jsp?id=<%= rs.getInt("id") %>">View Bill</a>
            </td>
        </tr>
<%
        }

        if (!hasData) {
%>
        <tr>
            <td colspan="8" style="color:blue;">No orders found</td>
        </tr>
<%
        }
    }
} catch (Exception e) {
%>
        <tr>
            <td colspan="8" class="msg">ERROR: <%= e.getMessage() %></td>
        </tr>
<%
} finally {
    try { if (rs != null) rs.close(); } catch(Exception e) {}
    try { if (st != null) st.close(); } catch(Exception e) {}
    try { if (con != null) con.close(); } catch(Exception e) {}
}
%>

    </table>

</div>

</body>
</html>
