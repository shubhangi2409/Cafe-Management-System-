package com.cafe;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String name = request.getParameter("name");
        String item = request.getParameter("item");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        int price = 0;
        int total = 0;
        boolean isInserted = false;
        int orderId = 0;

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                throw new Exception("Connection is NULL");
            }

            OrderStatusHelper.ensureStatusColumn(con);
            OrderBillHelper.ensureUnitPriceColumn(con);
            price = OrderBillHelper.resolveItemPrice(con, item);
            total = price * quantity;

            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO orders(name, item, quantity, unit_price, total, status) VALUES (?, ?, ?, ?, ?, ?)",
                    PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, name);
            ps.setString(2, item);
            ps.setInt(3, quantity);
            ps.setInt(4, price);
            ps.setInt(5, total);
            ps.setString(6, OrderStatusHelper.PENDING);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                isInserted = true;
                try (java.sql.ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        orderId = generatedKeys.getInt(1);
                    }
                }
            }

            ps.close();
        } catch (Exception e) {
            out.println("<h3 style='color:red;'>ERROR: " + e.getMessage() + "</h3>");
            e.printStackTrace();
        }

        out.println("<html>");
        out.println("<head>");
        out.println("<title>Order Status</title>");
        out.println("<style>");
        out.println("body { background-color: #f8f1f1; font-family: Arial, sans-serif; text-align: center; padding-top: 100px; }");
        out.println("h2 { font-size: 32px; }");
        out.println(".success { color: green; }");
        out.println(".error { color: red; }");
        out.println(".amount { font-size: 22px; margin: 20px; }");
        out.println(".message { color: #800000; font-size: 20px; margin-top: 20px; }");
        out.println(".btn { background-color: #800000; color: white; padding: 12px 25px; text-decoration: none; border-radius: 6px; display: inline-block; margin-top: 20px; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");

        if (isInserted) {
            out.println("<h2 class='success'>Order Saved Successfully!</h2>");
            out.println("<div class='message'>Current status: Pending</div>");
            out.println("<div class='amount'>Item Price: Rs. " + price + "</div>");
        } else {
            out.println("<h2 class='error'>Order Failed! Check Database</h2>");
        }

        out.println("<div class='amount'>Total Amount: Rs. " + total + "</div>");
        out.println("<div class='message'>Thank you for ordering! We are providing our best service.</div>");

        if (isInserted) {
            String encodedName = URLEncoder.encode(name, StandardCharsets.UTF_8.toString());
            out.println("<a href='orderStatus.jsp?name=" + encodedName + "' class='btn'>Check Order Status</a><br>");
            if (orderId > 0) {
                out.println("<a href='orderBill.jsp?id=" + orderId + "' class='btn'>View Bill</a><br>");
            }
        }

        out.println("<a href='index.jsp' class='btn'>Go Home</a>");
        out.println("</body>");
        out.println("</html>");
    }
}
