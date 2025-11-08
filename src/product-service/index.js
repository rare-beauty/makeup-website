const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const Product = require("./db");

const app = express();
app.use(cors());
app.use(bodyParser.json());

// ---- static files for uploaded images ----
const uploadDir = path.join(__dirname, "uploads");
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir);
app.use("/uploads", express.static(uploadDir));

// ---- multer setup ----
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, uploadDir),
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `${Date.now()}-${Math.random().toString(36).slice(2, 11)}${ext}`);
  },
});
const upload = multer({ storage });

// ---- health endpoints (must return 200 fast) ----
app.get("/healthz", (_req, res) => res.status(200).send("ok"));
app.get("/", (_req, res) => res.status(200).send("ok"));

// ---- routes ----

// POST /products - create product
app.post("/products", upload.single("image"), async (req, res) => {
  try {
    console.log("🖼️ Uploaded file:", req.file);
    console.log("📦 Form fields:", req.body);

    const { sku, name, price, categories, instock, description } = req.body;
    const imageUrl = req.file ? `/uploads/${req.file.filename}` : null;

    const product = new Product({
      sku,
      name,
      price,
      categories: categories?.split(",").map((c) => c.trim()) || [],
      instock,
      description,
      imageUrl,
    });

    await product.save();
    console.log("✅ Product saved:", product);
    res.status(201).json(product);
  } catch (err) {
    console.error("❌ Error saving product:", err.message);
    res.status(500).send("Failed to create product");
  }
});

// GET /products - fetch all
app.get("/products", async (_req, res) => {
  try {
    const products = await Product.find();
    res.json(products);
  } catch (err) {
    console.error("❌ Error fetching products:", err.message);
    res.status(500).send("Failed to fetch products");
  }
});

// DELETE /products/:id
app.delete("/products/:id", async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).send("Product not found");

    if (product.imageUrl) {
      const filename = path.basename(product.imageUrl);
      const imagePath = path.join(uploadDir, filename);
      if (fs.existsSync(imagePath)) fs.unlinkSync(imagePath);
    }

    await Product.findByIdAndDelete(req.params.id);
    res.sendStatus(204);
  } catch (err) {
    console.error("❌ Delete failed:", err.message);
    res.status(500).send("Delete failed");
  }
});

// ---- start server on env PORT (default 80) ----
const PORT = Number(process.env.PORT) || 80;
app.listen(PORT, () => {
  console.log(`🚀 Product Service listening on port ${PORT}`);
});
