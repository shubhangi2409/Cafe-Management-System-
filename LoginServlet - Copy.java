package com.cafe;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get data from login.jsp
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Simple authentication
        if(username.equals("admin") && password.equals("1234")) {
            
            // If correct → go to home page
        	response.sendRedirect("admin.jsp");
        
        } else {
            
            // If wrong → back to login page with error
            response.sendRedirect("login.jsp?error=1");
        }
    }
}