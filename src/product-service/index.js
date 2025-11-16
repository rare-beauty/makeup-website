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

// -------------------------------
// STATIC FOLDER for uploaded images
// -------------------------------
const uploadDir = path.join(__dirname, "uploads");
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir);
app.use("/uploads", express.static(uploadDir));

// -------------------------------
// MULTER — File Upload Handling
// -------------------------------
const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, uploadDir),
  filename: (_req, file, cb) => {
    const ext = path.extname(file.originalname);
    const unique = `${Date.now()}-${Math.random().toString(36).slice(2, 11)}`;
    cb(null, `${unique}${ext}`);
  }
});

const upload = multer({ storage });

// -------------------------------
// HEALTH ENDPOINTS
// -------------------------------
app.get("/healthz", (_req, res) => res.status(200).send("ok"));
app.get("/", (_req, res) => res.status(200).send("ok"));

// -------------------------------
// API ROUTES with /api prefix
// -------------------------------
const router = express.Router();

/**
 * POST /api/products
 * Create new product
 */
router.post("/products", upload.single("image"), async (req, res) => {
  try {
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
    res.status(201).json(product);
  } catch (err) {
    console.error("❌ Error saving product:", err);
    res.status(500).send("Failed to create product");
  }
});

/**
 * GET /api/products
 * Fetch all products
 */
router.get("/products", async (_req, res) => {
  try {
    const products = await Product.find();
    res.json(products);
  } catch (err) {
    console.error("❌ Error fetching products:", err);
    res.status(500).send("Failed to fetch products");
  }
});

/**
 * DELETE /api/products/:id
 */
router.delete("/products/:id", async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).send("Product not found");

    // delete image file if exists
    if (product.imageUrl) {
      const filename = path.basename(product.imageUrl);
      const filePath = path.join(uploadDir, filename);
      if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
    }

    await Product.findByIdAndDelete(req.params.id);
    res.sendStatus(204);
  } catch (err) {
    console.error("❌ Delete failed:", err);
    res.status(500).send("Delete failed");
  }
});

// -------------------------------
// Mount router under /api
// -------------------------------
app.use("/api", router);

// -------------------------------
// Start Server
// -------------------------------
const PORT = Number(process.env.PORT) || 80;
app.listen(PORT, () => {
  console.log(`🚀 Product Service listening on port ${PORT}`);
});
