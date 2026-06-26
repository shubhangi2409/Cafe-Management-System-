<%@ page language="java" contentType="text/html; charset=UTF-8"%>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Register - Mini Cafe</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            .register-container {
                max-width: 500px;
                margin: 50px auto;
                padding: 30px;
                background: #f8f1f1;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            
            .register-container h2 {
                text-align: center;
                color: #800000;
            }
            
            .register-container input {
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box;
            }
            
            .register-container button {
                width: 100%;
                padding: 12px;
                background: #800000;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                margin-top: 10px;
            }
            
            .register-container button:hover {
                background: #600000;
            }
            
            .register-container a {
                text-align: center;
                display: block;
                margin-top: 15px;
                color: #800000;
                text-decoration: none;
            }
            
            .error {
                color: red;
                margin: 10px 0;
            }
            
            .success {
                color: green;
                margin: 10px 0;
            }
        </style>
    </head>

    <body>

        <!-- Header -->
        <header>
            <h1> Mini Cafe</h1>
            <nav>
                <a href="index.html">Home</a>
                <a href="order.jsp">Order</a>
                <a href="login.jsp">Login</a>
            </nav>
        </header>

        <!-- Register Section -->
        <div class="register-container">
            <h2>Create Admin Account</h2>

            <%
            String error = request.getParameter("error");
            String success = request.getParameter("success");
            
            if(error != null) {
                if(error.equals("1")) {
                    out.println("<p class='error'>Username already exists!</p>");
                } else if(error.equals("2")) {
                    out.println("<p class='error'>Passwords don't match!</p>");
                } else if(error.equals("3")) {
                    out.println("<p class='error'>Registration failed! Try again.</p>");
                }
            }
            
            if(success != null && success.equals("1")) {
                out.println("<p class='success'>Registration successful! Please login now.</p>");
            }
        %>

                <form action="RegisterServlet" method="post">
                    <label>Username:</label>
                    <input type="text" name="username" placeholder="Enter username" required><br>

                    <label>Email:</label>
                    <input type="email" name="email" placeholder="Enter email" required><br>

                    <label>Password:</label>
                    <input type="password" name="password" placeholder="Enter password" required><br>

                    <label>Confirm Password:</label>
                    <input type="password" name="confirmPassword" placeholder="Confirm password" required><br>

                    <button type="submit">Register</button>
                </form>

                <a href="login.jsp">Already have an account? Login here</a>
        </div>

        <!-- Footer -->
        <footer>
            <p>© 2026 Mini Cafe</p>
        </footer>

    </body>

    </html>