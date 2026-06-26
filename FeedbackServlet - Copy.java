package com.cafe;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String message = request.getParameter("message");

        try {
            Connection con = DBConnection.getConnection();

            String query = "INSERT INTO feedback(name, message) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, name);
            ps.setString(2, message);

            ps.executeUpdate();

            ps.close();
            con.close();

        } catch(Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("feedback.jsp?success=1");
    }
}