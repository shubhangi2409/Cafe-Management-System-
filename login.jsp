<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Mini Cafe</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- Header -->
    <header>
        <h1 style="color:white;"> Mini Cafe</h1>
        <nav>
       <a href="index.jsp">Home</a>
            <a href="login.jsp">Login</a>
            <a href="feedback.jsp">Feedback</a>
        </nav>
    </header>

    <!-- Login Section -->
    <section class="menu">

        <h2 style="color:white;">Admin Login</h2>

        <div style="margin-top:30px;">
          <table>
            <form action="LoginServlet" method="post">

                <label style="color:white;">Username:</label><br>
                <input type="text" name="username" required><br><br>

                <label style="color:white;">Password:</label><br>
                <input type="password" name="password" required><br><br>

                <button type="submit">Login</button>

            </form>
          </table>
            <!-- Error Message -->
            <p style="color:red; margin-top:10px;">
                <%
                    String error = request.getParameter("error");
                    if(error != null){
                        out.println("Invalid Username or Password!");
                    }
                %>
            </p>

        </div>

    </section>

    <!-- Footer -->
    <footer>
        <p>Mini Cafe</p>
    </footer>

</body>
</html>