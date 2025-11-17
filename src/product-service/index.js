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

// ===============================
// STATIC FILES
// ===============================
const uploadDir = path.join(__dirname, "uploads");
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir);

// expose uploads directory
app.use("/api/products/uploads", express.static(uploadDir));

// ===============================
// MULTER STORAGE
// ===============================
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, uploadDir),
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `${Date.now()}-${Math.random().toString(36).slice(2, 11)}${ext}`);
  },
});
const upload = multer({ storage });

// ===============================
// HEALTH ENDPOINTS
// ===============================
app.get("/healthz", (_req, res) => res.status(200).send("ok"));
app.get("/", (_req, res) => res.status(200).send("ok"));

// ===============================
// PRICE SANITIZER
// ===============================
function cleanPrice(raw) {
  if (!raw) return null;
  let p = String(raw).replace("$", "").trim(); // remove $ sign
  const num = Number(p);
  return isNaN(num) ? null : num;
}

// ===============================
// CREATE PRODUCT
// ===============================
app.post("/api/products", upload.single("image"), async (req, res) => {
  try {
    console.log("Uploaded:", req.file);
    console.log("Fields:", req.body);

    let { sku, name, price, categories, instock, description } = req.body;

    // -------- Clean & Validate Price --------
    const cleanedPrice = cleanPrice(price);
    if (cleanedPrice === null) {
      return res.status(400).json({ error: "Price must be a valid number" });
    }

    // -------- Handle categories --------
    const categoryList = categories
      ? categories.split(",").map((c) => c.trim())
      : [];

    // -------- Image path (relative, NOT hardcoded) --------
    const imageUrl = req.file
      ? `/api/products/uploads/${req.file.filename}`
      : null;

    const product = new Product({
      sku,
      name,
      price: cleanedPrice,
      description,
      instock: Number(instock) || 0,
      categories: categoryList,
      imageUrl,
    });

    await product.save();
    res.status(201).json(product);

  } catch (err) {
    console.error("❌ Error saving product:", err);
    res.status(500).json({ error: "Failed to create product" });
  }
});

// ===============================
// GET ALL PRODUCTS
// ===============================
app.get("/api/products", async (_req, res) => {
  try {
    const products = await Product.find();
    res.json(products);
  } catch (err) {
    console.error("Fetch error:", err);
    res.status(500).json({ error: "Failed to fetch products" });
  }
});

// ===============================
// DELETE PRODUCT
// ===============================
app.delete("/api/products/:id", async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ error: "Product not found" });

    // delete image from disk if exists
    if (product.imageUrl) {
      const filename = product.imageUrl.split("/uploads/")[1];
      const filePath = path.join(uploadDir, filename);
      if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
    }

    await Product.findByIdAndDelete(req.params.id);
    res.sendStatus(204);

  } catch (err) {
    console.error("Delete failed:", err);
    res.status(500).json({ error: "Failed to delete" });
  }
});

// ===============================
// START SERVER
// ===============================
const PORT = Number(process.env.PORT) || 80;
app.listen(PORT, () => {
  console.log(`🚀 Product Service listening on port ${PORT}`);
});
