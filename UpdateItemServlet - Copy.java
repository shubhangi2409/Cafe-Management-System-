package com.cafe;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

@WebServlet("/UpdateItemServlet")
@MultipartConfig
public class UpdateItemServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("itemName");
        int price = Integer.parseInt(request.getParameter("price"));

        Part filePart = request.getPart("image");
        String fileName = filePart.getSubmittedFileName();

        try {
            Connection con = DBConnection.getConnection();

            String query;

            // If new image uploaded
            if(fileName != null && !fileName.equals("")) {

                String uploadPath = getServletContext().getRealPath("/") + "images";
                filePart.write(uploadPath + File.separator + fileName);

                query = "UPDATE items SET item_name=?, price=?, image=? WHERE id=?";
                PreparedStatement ps = con.prepareStatement(query);

                ps.setString(1, name);
                ps.setInt(2, price);
                ps.setString(3, fileName);
                ps.setInt(4, id);

                ps.executeUpdate();

            } else {
                // Update without changing image
                query = "UPDATE items SET item_name=?, price=? WHERE id=?";
                PreparedStatement ps = con.prepareStatement(query);

                ps.setString(1, name);
                ps.setInt(2, price);
                ps.setInt(3, id);

                ps.executeUpdate();
            }

            con.close();

        } catch(Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin.jsp");
    }
}