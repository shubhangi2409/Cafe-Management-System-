<%@ page import="java.sql.*" %>
<%@ page import="com.cafe.DBConnection" %>

<%
String idStr = request.getParameter("id");
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

if (idStr == null || idStr.trim().equals("")) {
    out.println("<h3 style='color:red; text-align:center; margin-top:50px;'>Invalid request! Item ID is missing.</h3>");
    out.println("<div style='text-align:center; margin-top:20px;'><a href='manageItems.jsp'> Go Back</a></div>");
    return;
}

int id = Integer.parseInt(idStr);
try {
    con = DBConnection.getConnection();
    ps = con.prepareStatement("SELECT * FROM items WHERE id=?");
    ps.setInt(1, id);
    rs = ps.executeQuery();

    if (!rs.next()) {
        out.println("<h3 style='color:red; text-align:center; margin-top:50px;'>Item not found!</h3>");
        out.println("<div style='text-align:center; margin-top:20px;'><a href='manageItems.jsp'>Go Back</a></div>");
        return;
    }
} catch (Exception e) {
    out.println("<h3 style='color:red; text-align:center; margin-top:50px;'>Database error: " + e.getMessage() + "</h3>");
    out.println("<div style='text-align:center; margin-top:20px;'><a href='manageItems.jsp'>Go Back</a></div>");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Item</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: url("images/cafe.jpg") no-repeat center center/cover;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 400px;
            margin: 80px auto;
            background: rgba(255, 255, 255, 0.95);
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 0 10px gray;
            text-align: center;
        }

        h2 {
            color: maroon;
            margin-bottom: 20px;
        }

        input[type="text"],
        input[type="number"],
        input[type="file"] {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        img {
            border-radius: 8px;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        .btn {
            background: maroon;
            color: white;
            border: none;
            padding: 10px 18px;
            margin: 10px 5px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
        }

        .btn:hover {
            background: darkred;
        }

        .back-link {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            color: white;
            background: #333;
            padding: 10px 15px;
            border-radius: 6px;
        }

        .back-link:hover {
            background: black;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Update Item </h2>

    <form action="UpdateItemServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="<%= rs.getInt("id") %>">

        <input type="text" name="itemName" value="<%= rs.getString("item_name") %>" required>

        <input type="number" name="price" value="<%= rs.getInt("price") %>" required>

        <p><b>Current Image:</b></p>
        <img src="images/<%= rs.getString("image") %>" width="120" height="100">

        <input type="file" name="image">

        <br>

        <button type="submit" class="btn">Update </button>
        <button type="reset" class="btn">Clear </button>
    </form>

    <a href="manageItems.jsp" class="back-link"> Go Back</a>
</div>

</body>
</html>
<%
try { if (rs != null) rs.close(); } catch (Exception e) {}
try { if (ps != null) ps.close(); } catch (Exception e) {}
try { if (con != null) con.close(); } catch (Exception e) {}
%>
