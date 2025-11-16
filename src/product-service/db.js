const mongoose = require("mongoose");
const fs = require("fs");

// Get the file path from environment (set by DevOps)
const filePath = process.env.MONGO_URI_FILE;

let mongoUri;

try {
  // Read MongoDB connection string from the CSI-mounted file
  mongoUri = fs.readFileSync(filePath, "utf8").trim();
  console.log("📄 Loaded MongoDB URI from file:", filePath);
} catch (err) {
  console.error("❌ Failed to read Mongo URI file:", err.message);
}

// Connect to Cosmos MongoDB
mongoose
  .connect(mongoUri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("✅ Connected to Cosmos MongoDB"))
  .catch((err) => console.error("❌ MongoDB connection error:", err.message));

// ---------------- SCHEMA ----------------
const productSchema = new mongoose.Schema({
  sku: String,
  name: String,
  price: Number,
  categories: [String],
  instock: Number,
  description: String,
  imageUrl: String,
});

const Product = mongoose.model("Product", productSchema);

module.exports = Product;
