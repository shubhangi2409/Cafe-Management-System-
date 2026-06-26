<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Order - Mini Cafe</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <header>
        <h1 style="color:white;">Mini Cafe</h1>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="login.jsp">Login</a>
            <a href="feedback.jsp">Feedback</a>
        </nav>
    </header>

    <section class="menu">
        <h2 style="color:white;">Place Your Order</h2>

        <div class="items">

            <div class="item">
                <img src="images/coffee.jpg">
                <h3>Coffee</h3>
                <p>RS : 50</p>
            </div>

            <div class="item">
                <img src="images/pizza.jpg">
                <h3>Pizza</h3>
                <p>RS : 150</p>
            </div>

            <div class="item">
                <img src="images/burger.jpg">
                <h3>Burger</h3>
                <p>RS : 100</p>
            </div>

        </div>

        <div style="margin-top:30px;">

            <form action="OrderServlet" method="post">

                <label style="color:white;">Your Name:</label><br>
                <input type="text" name="name" required><br><br>

                <label style="color:white;">Select Item:</label><br>
                <select name="item" required>
                    <option value="">--Select--</option>
                    <option value="Coffee">Coffee (RS : 50)</option>
                    <option value="Pizza">Pizza (RS : 150)</option>
                    <option value="Burger">Burger (RS : 100)</option>
                </select><br><br>

                <label style="color:white;">Quantity:</label><br>
                <input type="number" name="quantity" min="1" required><br><br>

                <button type="submit">Place Order</button>

            </form>

        </div>

        <div style="margin-top:40px;">
            <h2 style="color:white;">Check Your Order Status</h2>

            <form action="orderStatus.jsp" method="get">
                <label style="color:white;">Enter Your Name:</label><br>
                <input type="text" name="name" required><br><br>
                <button type="submit">Check Status</button>
            </form>
        </div>

    </section>

    <footer>
        <p>Copyright 2026 Mini Cafe</p>
    </footer>

</body>
</html>
