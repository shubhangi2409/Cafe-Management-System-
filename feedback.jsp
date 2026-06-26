<!DOCTYPE html>
<html>
<head>
    <title>Feedback</title>

    <style>
        body {
            font-family: Arial, sans-serif;

            /* ✅ Background Image */
            background: url("images/cafe.jpg") no-repeat center center/cover;

            height: 100vh;
            margin: 0;

            /* Center content */
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Dark overlay for better visibility */
        .overlay {
            background: rgba(0, 0, 0, 0.6);
            padding: 30px;
            border-radius: 10px;
        }

        .container {
            background: white;
            width: 350px;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 10px black;
            text-align: center;
        }

        h2 {
            color: #800000;
        }

        input, textarea {
            width: 90%;
            padding: 10px;
            margin: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        .btn {
            background-color: #800000;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            margin: 10px;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #a00000;
        }

        .home-btn {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            color: white;
            background: #333;
            padding: 10px 20px;
            border-radius: 5px;
        }

        .home-btn:hover {
            background: black;
        }
    </style>
</head>

<body>

<div class="overlay">
    <div class="container">

        <h2>Give Feedback </h2>

        <form action="FeedbackServlet" method="post">

            <input type="text" name="name" placeholder="Enter your name" required>

            <textarea name="message" rows="4" placeholder="Write your feedback..." required></textarea>

            <br>

            <button type="submit" class="btn">Submit </button>
            <button type="reset" class="btn">Clear </button>

        </form>

        <!-- Go Home -->
        <a href="index.jsp" class="home-btn"> Go Home</a>

    </div>
</div>

</body>
</html>