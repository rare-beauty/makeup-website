// order-service/index.js
const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const Order = require("./db");

const app = express();
app.use(cors());
app.use(bodyParser.json());

// ✅ Get all orders
app.get("/orders", async (req, res) => {
  try {
    const orders = await Order.find();
    res.json(orders);
  } catch (err) {
    console.error("❌ Error fetching orders:", err);
    res.status(500).send("Failed to fetch orders");
  }
});

// ✅ Create a new order
app.post("/orders", async (req, res) => {
  const { productId, name, price, imageUrl } = req.body;

  const order = new Order({
    items: [{
      productId,
      name,
      price,
      imageUrl
    }],
    total: price,
    status: "pending",
    userId: "guest",
    productName: name,
    productImageUrl: imageUrl
  });

  try {
    await order.save();
    res.status(201).send("Order created");
  } catch (err) {
    console.error("❌ Error creating order:", err.message);
    res.status(500).send("Failed to create order");
  }
});

// ✅ Delete orders by product ID
app.delete("/orders/product/:productId", async (req, res) => {
  const { productId } = req.params;
  try {
    const result = await Order.deleteMany({ "items.productId": productId });
    res.send(`🗑️ Deleted ${result.deletedCount} order(s) for product ID ${productId}`);
  } catch (err) {
    console.error("❌ Error deleting orders:", err);
    res.status(500).send("Failed to delete related orders");
  }
});

// ✅ Delete specific order by ID
app.delete("/orders/:id", async (req, res) => {
  const { id } = req.params;
  try {
    await Order.findByIdAndDelete(id);
    res.send("✅ Order deleted");
  } catch (err) {
    console.error("❌ Failed to delete order:", err);
    res.status(500).send("Error deleting order");
  }
});

// ✅ Update order status
app.put("/orders/:id/status", async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  if (!status) {
    return res.status(400).send("Status is required");
  }

  try {
    const updated = await Order.findByIdAndUpdate(id, { status }, { new: true });
    if (!updated) {
      return res.status(404).send("Order not found");
    }
    res.send("✅ Order status updated");
  } catch (err) {
    console.error("❌ Failed to update order status:", err.message);
    res.status(500).send("Failed to update status");
  }
});

const PORT = 4004;
app.listen(PORT, () => console.log(`🚀 Order Service running on ${PORT}`));
