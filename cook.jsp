<%@ page import="java.sql.*" %>
<%@ page import="com.cafe.DBConnection" %>
<%@ page import="com.cafe.OrderStatusHelper" %>

<!DOCTYPE html>
<html>
<head>
    <title>Cook / Shape Page</title>

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

        .sidebar a:hover,
        .sidebar a.active {
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

        .actions {
            margin-top: 25px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .actions button {
            background: #800000;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 15px;
        }

        .actions button:hover {
            background: #5f0000;
        }

        .msg {
            color: red;
            font-weight: bold;
        }

        .confirm-form {
            margin: 0;
        }

        .confirm-actions {
            display: flex;
            gap: 8px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .confirm-btn {
            background: #800000;
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: 5px;
            cursor: pointer;
        }

        .confirm-btn:hover {
            background: #5f0000;
        }

        .reject-btn {
            background: #cc0000;
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: 5px;
            cursor: pointer;
        }

        .reject-btn:hover {
            background: #990000;
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
    </style>
</head>

<body>

<div class="sidebar">
    <h2 style="color:white;">Admin</h2>
    <a href="admin.jsp">View Orders</a>
    <a href="cook.jsp" class="active">Cook / Shape Page</a>
    <a href="manageItems.jsp">Manage Items</a>
    <a href="viewFeedback.jsp">View Feedback</a>
    <a href="index.jsp">Logout</a>
</div>

<div class="topbar">
     Admin
</div>

<div class="main">

    <h2>Cook / Shape Orders</h2>

    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Item</th>
            <th>Quantity</th>
            <th>Total</th>
            <th>Status</th>
            <th>Action</th>
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
            <td colspan="7" class="msg">Database connection failed</td>
        </tr>
<%
    } else {
        OrderStatusHelper.ensureStatusColumn(con);
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
            <td><%= rs.getInt("quantity") %></td>
            <td>RS : <%= rs.getInt("total") %></td>
            <td class="status <%= statusClass %>"><%= status %></td>
            <td>
                <form class="confirm-form confirm-actions" action="UpdateOrderStatusServlet" method="post">
                    <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                    <input type="hidden" name="name" value="<%= rs.getString("name") %>">
                    <input type="hidden" name="item" value="<%= rs.getString("item") %>">
                    <button type="submit" name="status" value="Ready" class="confirm-btn">Confirm Order</button>
                    <button type="submit" name="status" value="Rejected" class="reject-btn">Cancel Order</button>
                </form>
            </td>
        </tr>
<%
        }

        if (!hasData) {
%>
        <tr>
            <td colspan="7" style="color:blue;">No orders found</td>
        </tr>
<%
        }
    }
} catch (Exception e) {
%>
        <tr>
            <td colspan="7" class="msg">ERROR: <%= e.getMessage() %></td>
        </tr>
<%
} finally {
    try { if (rs != null) rs.close(); } catch(Exception e) {}
    try { if (st != null) st.close(); } catch(Exception e) {}
    try { if (con != null) con.close(); } catch(Exception e) {}
}
%>

    </table>

    <div class="actions">
        <button type="button" onclick="window.location.href='admin.jsp'">Go To Home</button>
    </div>

</div>

</body>
</html>
