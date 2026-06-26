<%@ page import="java.sql.*" %>
<%@ page import="com.cafe.DBConnection" %>
<%@ page import="com.cafe.OrderStatusHelper" %>

<!DOCTYPE html>
<html>
<head>
    <title>Order Status - Mini Cafe</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .status-box {
            width: 90%;
            max-width: 950px;
            margin: 40px auto;
            background: rgba(255, 255, 255, 0.96);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.25);
        }

        .status-box h2 {
            color: #800000;
            text-align: center;
            margin-top: 0;
        }

        .status-form {
            text-align: center;
            margin-bottom: 25px;
        }

        .status-form input {
            width: 260px;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .status-form button,
        .back-btn {
            background: #800000;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
        }

        .status-form button:hover,
        .back-btn:hover {
            background: #5f0000;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: center;
            background: white;
        }

        th {
            background: #800000;
            color: white;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ccc;
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

        .action-form {
            margin: 0;
        }

        .cancel-btn {
            background: #cc0000;
            color: white;
            border: none;
            padding: 8px 14px;
            border-radius: 5px;
            cursor: pointer;
        }

        .cancel-btn:hover {
            background: #990000;
        }

        .info {
            text-align: center;
            color: #800000;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .error-msg {
            color: red;
            text-align: center;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <header>
        <h1 style="color:white;">Mini Cafe</h1>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="order.jsp">Order</a>
            <a href="feedback.jsp">Feedback</a>
        </nav>
    </header>

    <section class="menu">
        <div class="status-box">
            <h2>Your Order Status</h2>

            <form class="status-form" action="orderStatus.jsp" method="get">
                <input type="text" name="name" value="<%= request.getParameter("name") == null ? "" : request.getParameter("name") %>" placeholder="Enter your name" required>
                <button type="submit">Check Status</button>
            </form>

<%
String updatedItem = request.getParameter("item");
String updatedStatus = OrderStatusHelper.normalizeStatus(request.getParameter("status"));

if (updatedItem != null && !updatedItem.trim().equals("")) {
    String updateMessage = updatedItem + " order is being prepared";
    if (OrderStatusHelper.READY.equals(updatedStatus)) {
        updateMessage = updatedItem + " order is confirmed. Deliver your food soon";
    } else if (OrderStatusHelper.REJECTED.equals(updatedStatus)) {
        updateMessage = updatedItem + " order is rejected. Sorry I cant reach. Try again";
    }
%>
            <p class="info"><%= updateMessage %></p>
<%
}
%>

<%
String searchName = request.getParameter("name");

if (searchName != null && !searchName.trim().equals("")) {
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.getConnection();

        if (con == null) {
%>
            <p class="error-msg">Database connection failed</p>
<%
        } else {
            OrderStatusHelper.ensureStatusColumn(con);
            ps = con.prepareStatement("SELECT * FROM orders WHERE name = ? ORDER BY id DESC");
            ps.setString(1, searchName.trim());
            rs = ps.executeQuery();

            boolean hasData = false;
%>
            <p class="info">Showing orders for <%= searchName %></p>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Message</th>
                    <th>Action</th>
                </tr>
<%
            while (rs.next()) {
                hasData = true;
                String status = OrderStatusHelper.normalizeStatus(rs.getString("status"));
                String statusClass = status.toLowerCase();
                String message = OrderStatusHelper.getCustomerMessage(status);
%>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("item") %></td>
                    <td><%= rs.getInt("quantity") %></td>
                    <td>RS : <%= rs.getInt("total") %></td>
                    <td class="status <%= statusClass %>"><%= status %></td>
                    <td><%= message %></td>
                    <td>
<%
                if (!OrderStatusHelper.REJECTED.equals(status)) {
%>
                        <form class="action-form" action="UpdateOrderStatusServlet" method="post">
                            <input type="hidden" name="source" value="orderStatus">
                            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                            <input type="hidden" name="name" value="<%= searchName %>">
                            <input type="hidden" name="item" value="<%= rs.getString("item") %>">
                            <button type="submit" name="status" value="Rejected" class="cancel-btn">Cancel Order</button>
                        </form>
<%
                } else {
%>
                        No Action
<%
                }
%>
                    </td>
                </tr>
<%
            }

            if (!hasData) {
%>
                <tr>
                    <td colspan="7">No orders found for this user</td>
                </tr>
<%
            }
%>
            </table>
<%
        }
    } catch (Exception e) {
%>
            <p class="error-msg">Error: <%= e.getMessage() %></p>
<%
    } finally {
        try { if (rs != null) rs.close(); } catch(Exception e) {}
        try { if (ps != null) ps.close(); } catch(Exception e) {}
        try { if (con != null) con.close(); } catch(Exception e) {}
    }
}
%>

            <div style="text-align:center; margin-top:20px;">
                <a href="order.jsp" class="back-btn">Back To Order Page</a>
            </div>
        </div>
    </section>

    <footer>
        <p>Copyright 2026 Mini Cafe</p>
    </footer>

</body>
</html>
