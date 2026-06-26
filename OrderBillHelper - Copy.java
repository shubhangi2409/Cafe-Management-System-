package com.cafe;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public final class OrderBillHelper {

    private OrderBillHelper() {
    }

    public static void ensureUnitPriceColumn(Connection con) throws SQLException {
        if (con == null) {
            return;
        }

        boolean unitPriceExists = false;
        DatabaseMetaData metaData = con.getMetaData();

        try (ResultSet rs = metaData.getColumns(con.getCatalog(), null, "orders", "unit_price")) {
            unitPriceExists = rs.next();
        }

        if (!unitPriceExists) {
            try (Statement st = con.createStatement()) {
                st.executeUpdate("ALTER TABLE orders ADD COLUMN unit_price INT NOT NULL DEFAULT 0");
            }
        }

        try (Statement st = con.createStatement()) {
            st.executeUpdate(
                    "UPDATE orders SET unit_price = CASE WHEN quantity > 0 THEN total / quantity ELSE 0 END "
                            + "WHERE unit_price IS NULL OR unit_price = 0");
        }
    }

    public static int resolveItemPrice(Connection con, String itemName) throws SQLException {
        if (con != null) {
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT price FROM items WHERE item_name = ? ORDER BY id DESC LIMIT 1")) {
                ps.setString(1, itemName);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("price");
                    }
                }
            } catch (SQLException e) {
                return getFallbackPrice(itemName);
            }
        }

        return getFallbackPrice(itemName);
    }

    public static OrderBill getOrderBill(Connection con, int orderId) throws SQLException {
        ensureUnitPriceColumn(con);
        OrderStatusHelper.ensureStatusColumn(con);

        try (PreparedStatement ps = con.prepareStatement(
                "SELECT id, name, item, quantity, unit_price, total, status FROM orders WHERE id = ?")) {
            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                return new OrderBill(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("item"),
                        rs.getInt("quantity"),
                        rs.getInt("unit_price"),
                        rs.getInt("total"),
                        OrderStatusHelper.normalizeStatus(rs.getString("status")));
            }
        }
    }

    public static int getFallbackPrice(String itemName) {
        if ("Coffee".equalsIgnoreCase(itemName)) {
            return 50;
        }
        if ("Pizza".equalsIgnoreCase(itemName)) {
            return 150;
        }
        if ("Burger".equalsIgnoreCase(itemName)) {
            return 100;
        }
        return 0;
    }
}
