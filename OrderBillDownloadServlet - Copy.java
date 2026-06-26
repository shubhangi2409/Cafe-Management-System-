package com.cafe;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/OrderBillDownloadServlet")
public class OrderBillDownloadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = parseOrderId(request.getParameter("id"));
        if (orderId <= 0) {
            response.sendRedirect("admin.jsp?billError=invalid");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            OrderBill bill = OrderBillHelper.getOrderBill(con, orderId);
            if (bill == null) {
                response.sendRedirect("admin.jsp?billError=missing");
                return;
            }

            String format = request.getParameter("format");
            if ("excel".equalsIgnoreCase(format)) {
                downloadExcel(response, bill);
                return;
            }

            downloadPdf(response, bill);
        } catch (Exception e) {
            throw new ServletException("Unable to download order bill.", e);
        }
    }

    private int parseOrderId(String orderIdValue) {
        try {
            return Integer.parseInt(orderIdValue);
        } catch (Exception e) {
            return 0;
        }
    }

    private void downloadExcel(HttpServletResponse response, OrderBill bill) throws IOException {
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition",
                "attachment; filename=order-bill-" + bill.getId() + ".xls");

        StringBuilder html = new StringBuilder();
        html.append("<html><head><meta charset=\"UTF-8\"></head><body>");
        html.append("<table border='1'>");
        html.append("<tr><th>Order ID</th><th>Customer Name</th><th>Item Name</th><th>Quantity</th>")
                .append("<th>Price</th><th>Total Bill</th><th>Status</th></tr>");
        html.append("<tr>");
        html.append("<td>").append(bill.getId()).append("</td>");
        html.append("<td>").append(escapeHtml(bill.getCustomerName())).append("</td>");
        html.append("<td>").append(escapeHtml(bill.getItemName())).append("</td>");
        html.append("<td>").append(bill.getQuantity()).append("</td>");
        html.append("<td>").append(bill.getUnitPrice()).append("</td>");
        html.append("<td>").append(bill.getTotalPrice()).append("</td>");
        html.append("<td>").append(escapeHtml(bill.getStatus())).append("</td>");
        html.append("</tr></table></body></html>");

        response.getOutputStream().write(html.toString().getBytes(StandardCharsets.UTF_8));
    }

    private void downloadPdf(HttpServletResponse response, OrderBill bill) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=order-bill-" + bill.getId() + ".pdf");

        String[] lines = {
                "Cafe Order Bill",
                "Order ID: " + bill.getId(),
                "Customer Name: " + bill.getCustomerName(),
                "Item Name: " + bill.getItemName(),
                "Quantity: " + bill.getQuantity(),
                "Price: Rs. " + bill.getUnitPrice(),
                "Total Bill: Rs. " + bill.getTotalPrice(),
                "Status: " + bill.getStatus()
        };

        byte[] pdfBytes = buildPdf(lines);
        response.setContentLength(pdfBytes.length);

        try (OutputStream output = response.getOutputStream()) {
            output.write(pdfBytes);
        }
    }

    private byte[] buildPdf(String[] lines) throws IOException {
        StringBuilder streamBuilder = new StringBuilder();
        streamBuilder.append("BT\n");
        streamBuilder.append("/F1 18 Tf\n");
        streamBuilder.append("50 780 Td\n");
        streamBuilder.append("(").append(escapePdf(lines[0])).append(") Tj\n");
        streamBuilder.append("/F1 12 Tf\n");

        for (int i = 1; i < lines.length; i++) {
            streamBuilder.append("0 -24 Td\n");
            streamBuilder.append("(").append(escapePdf(lines[i])).append(") Tj\n");
        }

        streamBuilder.append("ET");

        byte[] streamBytes = streamBuilder.toString().getBytes(StandardCharsets.US_ASCII);

        ByteArrayOutputStream output = new ByteArrayOutputStream();
        writeAscii(output, "%PDF-1.4\n");

        int[] offsets = new int[6];

        offsets[1] = output.size();
        writeAscii(output, "1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n");

        offsets[2] = output.size();
        writeAscii(output, "2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n");

        offsets[3] = output.size();
        writeAscii(output,
                "3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Contents 4 0 R "
                        + "/Resources << /Font << /F1 5 0 R >> >> >>\nendobj\n");

        offsets[4] = output.size();
        writeAscii(output, "4 0 obj\n<< /Length " + streamBytes.length + " >>\nstream\n");
        output.write(streamBytes);
        writeAscii(output, "\nendstream\nendobj\n");

        offsets[5] = output.size();
        writeAscii(output, "5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n");

        int xrefStart = output.size();
        writeAscii(output, "xref\n0 6\n");
        writeAscii(output, "0000000000 65535 f \n");

        for (int i = 1; i < offsets.length; i++) {
            writeAscii(output, String.format("%010d 00000 n \n", offsets[i]));
        }

        writeAscii(output, "trailer\n<< /Size 6 /Root 1 0 R >>\nstartxref\n");
        writeAscii(output, String.valueOf(xrefStart));
        writeAscii(output, "\n%%EOF");

        return output.toByteArray();
    }

    private void writeAscii(ByteArrayOutputStream output, String value) throws IOException {
        output.write(value.getBytes(StandardCharsets.US_ASCII));
    }

    private String escapePdf(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)");
    }

    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
