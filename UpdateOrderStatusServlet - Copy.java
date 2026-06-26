package com.cafe;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateOrderStatusServlet")
public class UpdateOrderStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idValue = request.getParameter("id");
        String customerName = request.getParameter("name");
        String itemName = request.getParameter("item");
        String status = OrderStatusHelper.normalizeStatus(request.getParameter("status"));
        String source = request.getParameter("source");

        try (Connection con = DBConnection.getConnection()) {
            if (con != null && idValue != null && !idValue.trim().equals("")) {
                OrderStatusHelper.ensureStatusColumn(con);

                PreparedStatement ps = con.prepareStatement("UPDATE orders SET status=? WHERE id=?");
                ps.setString(1, status);
                ps.setInt(2, Integer.parseInt(idValue));
                ps.executeUpdate();
                ps.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String encodedName = URLEncoder.encode(customerName == null ? "" : customerName, StandardCharsets.UTF_8.toString());
        String encodedItem = URLEncoder.encode(itemName == null ? "" : itemName, StandardCharsets.UTF_8.toString());
        String encodedStatus = URLEncoder.encode(status, StandardCharsets.UTF_8.toString());

        String redirectUrl;
        if ("orderStatus".equals(source)) {
            redirectUrl = "orderStatus.jsp?name=" + encodedName
                    + "&item=" + encodedItem
                    + "&status=" + encodedStatus;
        } else {
            redirectUrl = "admin.jsp?confirmedName=" + encodedName
                    + "&confirmedItem=" + encodedItem
                    + "&status=" + encodedStatus;
        }

        response.sendRedirect(redirectUrl);
    }
}
