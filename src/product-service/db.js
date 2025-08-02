const mongoose = require("mongoose");

mongoose.connect("mongodb://product-db:27017/products", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log("✅ Connected to Product DB"))
.catch((err) => console.error("❌ Product DB connection error:", err.message));

const productSchema = new mongoose.Schema({
  sku: String,
  name: String,
  price: Number,
  categories: [String],
  instock: Number,
  description: String,
  imageUrl: String,  // ✅ lowercase "l"

});

const Product = mongoose.model("Product", productSchema);

module.exports = Product;
