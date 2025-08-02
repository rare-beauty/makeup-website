// order-service/db.js
const mongoose = require("mongoose");

mongoose.connect("mongodb://order-db:27017/orders", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => {
  console.log("✅ Connected to Order DB");
}).catch(err => {
  console.error("❌ Order DB connection error:", err);
});

const orderSchema = new mongoose.Schema({
  items: [
    {
      name: String,
      price: Number,
      imageUrl: String,
      productId: String,
      quantity: { type: Number, default: 1 }
    }
  ],
  total: Number,
  status: {
    type: String,
    default: "pending"
  },
  productName: String,
  productImageUrl: String,
  userId: String,
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const Order = mongoose.model("Order", orderSchema);
module.exports = Order;
