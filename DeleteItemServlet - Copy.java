package com.cafe;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DeleteItemServlet")
public class DeleteItemServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isAdmin") == null) {
            response.sendRedirect("login.jsp?error=1");
            return;
        }

        int itemId = Integer.parseInt(request.getParameter("id"));

        try {
            Connection con = DBConnection.getConnection();

            String query = "DELETE FROM items WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, itemId);

            int rows = ps.executeUpdate();

            ps.close();
            con.close();

            if (rows > 0) {
                response.sendRedirect("manageItems.jsp?success=1");
            } else {
                response.sendRedirect("manageItems.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageItems.jsp?error=1");
        }
    }
}
