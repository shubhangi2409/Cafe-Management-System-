<%@ page import="java.sql.Connection" %>
<%@ page import="com.cafe.DBConnection" %>
<%@ page import="com.cafe.OrderBill" %>
<%@ page import="com.cafe.OrderBillHelper" %>

<!DOCTYPE html>
<html>
<head>
    <title>Order Bill</title>

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

        .bill-card {
            width: 92%;
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #800000;
            margin-top: 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th {
            background: #800000;
            color: white;
        }

        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }

        .summary {
            margin-top: 20px;
            line-height: 1.9;
            color: #333;
        }

        .summary strong {
            display: inline-block;
            width: 150px;
            color: #800000;
        }

        .actions {
            margin-top: 24px;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn {
            background: #800000;
            color: white;
            border: none;
            padding: 12px 18px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-block;
        }

        .btn.secondary {
            background: #1e5aa8;
        }

        .btn.back {
            background: #555;
        }

        .empty {
            color: red;
            font-weight: bold;
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
    <div class="bill-card">
        <h2>Order Bill</h2>

<%
OrderBill bill = null;
String errorMessage = null;
String orderIdValue = request.getParameter("id");

try {
    int orderId = Integer.parseInt(orderIdValue);

    try (Connection con = DBConnection.getConnection()) {
        bill = OrderBillHelper.getOrderBill(con, orderId);
    }

    if (bill == null) {
        errorMessage = "Order bill not found.";
    }
} catch (Exception e) {
    errorMessage = "Please open a valid order bill.";
}

if (errorMessage != null) {
%>
        <div class="empty"><%= errorMessage %></div>
        <div class="actions">
            <a href="admin.jsp" class="btn back">Back To Admin</a>
        </div>
<%
} else {
%>
        <div class="summary">
            <div><strong>Order ID:</strong> <%= bill.getId() %></div>
            <div><strong>Customer Name:</strong> <%= bill.getCustomerName() %></div>
            <div><strong>Status:</strong> <%= bill.getStatus() %></div>
        </div>

        <table>
            <tr>
                <th>Item Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total Bill</th>
            </tr>
            <tr>
                <td><%= bill.getItemName() %></td>
                <td>RS : <%= bill.getUnitPrice() %></td>
                <td><%= bill.getQuantity() %></td>
                <td>RS : <%= bill.getTotalPrice() %></td>
            </tr>
        </table>

        <div class="actions">
            <a href="OrderBillDownloadServlet?id=<%= bill.getId() %>&format=pdf" class="btn">Download PDF</a>
            <a href="OrderBillDownloadServlet?id=<%= bill.getId() %>&format=excel" class="btn secondary">Download Excel</a>
            <a href="admin.jsp" class="btn back">Back To Admin</a>
        </div>
<%
}
%>
    </div>
</div>

</body>
</html>
