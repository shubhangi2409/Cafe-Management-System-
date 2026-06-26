<!DOCTYPE html>
<html>
<head>
    <title>Add Item</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .sidebar a {
            color: white;
            display: block;
            margin: 10px 0;
            text-decoration: none;
            padding: 8px 10px;
            border-radius: 5px;
        }

        .sidebar a:hover {
            background: #800000;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar" style="width:200px; height:100vh; background:#333; color:white; float:left; padding:20px;">
    <h2>Admin</h2>
    <a href="admin.jsp">View Orders</a>
    <a href="cook.jsp">Cook / Shape Page</a>
    <a href="addItem.jsp">Add Item</a>
    <a href="manageItems.jsp">Manage Items</a>
    <a href="viewFeedback.jsp">View Feedback</a>
    <a href="#" onclick="logout()">Logout</a>
</div>

<!-- Top Bar -->
<div style="margin-left:200px; padding:15px; background:#555; color:white; text-align:right;">
    Admin 
</div>

<!-- Centered Form -->
<div style="margin-left:200px; display:flex; justify-content:center; align-items:center; height:80vh;">

    <form action="AddItemServlet" method="post" enctype="multipart/form-data"
          style="background:white; color:black; padding:30px; border-radius:10px;">

        <h2>Add New Item</h2>

        <label>Item Name:</label><br>
        <input type="text" name="itemName" required><br><br>

        <label>Price:</label><br>
        <input type="number" name="price" required><br><br>

        <label>Upload Image:</label><br>
        <input type="file" name="image" required><br><br>

        <button type="submit">Add Item</button>

    </form>

</div>

<script>
function logout() {
    if(confirm("Are you sure you want to logout?")) {
        window.location.href = "index.jsp";
    }
}
</script>

</body>
</html>
