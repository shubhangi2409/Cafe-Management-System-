package com.cafe;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public final class OrderStatusHelper {

    public static final String PENDING = "Pending";
    public static final String READY = "Ready";
    public static final String REJECTED = "Rejected";

    private OrderStatusHelper() {
    }

    public static void ensureStatusColumn(Connection con) throws SQLException {
        if (con == null) {
            return;
        }

        boolean statusExists = false;
        DatabaseMetaData metaData = con.getMetaData();

        try (ResultSet rs = metaData.getColumns(con.getCatalog(), null, "orders", "status")) {
            statusExists = rs.next();
        }

        if (!statusExists) {
            try (Statement st = con.createStatement()) {
                st.executeUpdate("ALTER TABLE orders ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'Pending'");
            }
        }
    }

    public static String normalizeStatus(String status) {
        if (READY.equalsIgnoreCase(status)) {
            return READY;
        }
        if (REJECTED.equalsIgnoreCase(status)) {
            return REJECTED;
        }
        return PENDING;
    }

    public static String getCustomerMessage(String status) {
        String normalizedStatus = normalizeStatus(status);

        if (READY.equals(normalizedStatus)) {
            return "Order confirmed. Deliver your food soon";
        }
        if (REJECTED.equals(normalizedStatus)) {
            return "Sorry I cant reach. Try again";
        }
        return "Order is being prepared";
    }
}
