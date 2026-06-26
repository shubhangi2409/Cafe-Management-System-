package com.cafe;

public class OrderBill {

    private final int id;
    private final String customerName;
    private final String itemName;
    private final int quantity;
    private final int unitPrice;
    private final int totalPrice;
    private final String status;

    public OrderBill(int id, String customerName, String itemName, int quantity,
            int unitPrice, int totalPrice, String status) {
        this.id = id;
        this.customerName = customerName;
        this.itemName = itemName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public String getCustomerName() {
        return customerName;
    }

    public String getItemName() {
        return itemName;
    }

    public int getQuantity() {
        return quantity;
    }

    public int getUnitPrice() {
        return unitPrice;
    }

    public int getTotalPrice() {
        return totalPrice;
    }

    public String getStatus() {
        return status;
    }
}
