package com.cafe;

import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AddItemServlet")
@MultipartConfig
public class AddItemServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemName = request.getParameter("itemName");
        int price = Integer.parseInt(request.getParameter("price"));

        // Get image file
        Part filePart = request.getPart("image");
        String fileName = filePart.getSubmittedFileName();

        // Save image in images folder
        String uploadPath = getServletContext().getRealPath("") + "images";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        filePart.write(uploadPath + File.separator + fileName);

        try {
            Connection con = DBConnection.getConnection();

            String query = "INSERT INTO items(item_name, price, image) VALUES (?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);

            ps.setString(1, itemName);
            ps.setInt(2, price);
            ps.setString(3, fileName);

            ps.executeUpdate();

        } catch(Exception e) {
            e.printStackTrace();
        }

        // Redirect to admin dashboard
        response.sendRedirect("admin.jsp?success=1");
    }
}