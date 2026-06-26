<%@ page import="java.sql.*" %>
<%@ page import="com.cafe.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<title>Feedback</title>

<style>
body {
    font-family: Arial, sans-serif;
    margin: 0;
    background: #f5f5f5;
}

h2 {
    color: #800000;
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
    color: white;
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
    text-align: center;
}

table {
    width: 80%;
    margin: auto;
    border-collapse: collapse;
    background: white;
    box-shadow: 0 0 8px #ccc;
}

th, td {
    padding: 10px;
    border: 1px solid #ccc;
}

th {
    background: maroon;
    color: white;
}

tr:hover {
    background: #f2f2f2;
}

.btn {
    display: inline-block;
    margin-top: 20px;
    padding: 12px 20px;
    background: maroon;
    color: white;
    text-decoration: none;
    border-radius: 6px;
}

.btn:hover {
    background: darkred;
}
</style>

</head>
<body>

<div class="sidebar">
    <h2>Admin</h2>
    <a href="admin.jsp">View Orders</a>
    <a href="cook.jsp">Cook / Shape Page</a>
    <a href="addItem.jsp">Add Item</a>
    <a href="manageItems.jsp">Manage Items</a>
    <a href="viewFeedback.jsp">View Feedback</a>
    <a href="index.jsp">Logout</a>
</div>

<div class="topbar">
    Admin
</div>

<div class="main">
<h2>Customer Feedback </h2>

<table>
<tr>
    <th>ID</th>
    <th>Name</th>
    <th>Message</th>
</tr>

<%
Connection con = null;
Statement st = null;
ResultSet rs = null;

try {
    con = DBConnection.getConnection();

    if (con != null) {
        st = con.createStatement();
        rs = st.executeQuery("SELECT * FROM feedback");

        boolean hasData = false;  

        while(rs.next()){
            hasData = true;
%>

<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getString("name") %></td>
    <td><%= rs.getString("message") %></td>
</tr>

<%
        }

        if(!hasData){
%>
<tr>
    <td colspan="3" style="color:blue;">No feedback available</td>
</tr>
<%
        }
    } else {
%>
<tr>
    <td colspan="3" style="color:red;">Database connection failed</td>
</tr>
<%
    }
} catch(Exception e){
%>
<tr>
    <td colspan="3" style="color:red;">Error: <%= e.getMessage() %></td>
</tr>
<%
} finally {
    try { if(rs != null) rs.close(); } catch(Exception e) {}
    try { if(st != null) st.close(); } catch(Exception e) {}
    try { if(con != null) con.close(); } catch(Exception e) {}
}
%>

</table>


<a href="admin.jsp" class="btn">Go To Dashboard </a>
</div>

</body>
</html>
