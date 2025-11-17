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

// ---- static files served through /api/products/uploads ----
const uploadDir = path.join(__dirname, "uploads");
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir);

// IMPORTANT: expose uploads under /api/products/uploads
app.use("/api/products/uploads", express.static(uploadDir));

// ---- multer storage ----
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, uploadDir),
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `${Date.now()}-${Math.random().toString(36).slice(2, 11)}${ext}`);
  },
});
const upload = multer({ storage });

// ---- health endpoints ----
app.get("/healthz", (_req, res) => res.status(200).send("ok"));
app.get("/", (_req, res) => res.status(200).send("ok"));

// ---- ROUTES ----

// POST /api/products (create product)
app.post("/api/products", upload.single("image"), async (req, res) => {
  try {
    console.log("Uploaded:", req.file);
    console.log("Fields:", req.body);

    const { sku, name, price, categories, instock, description } = req.body;

    // store FULL path for frontend → NO HARD CODING NEEDED
    const imageUrl = req.file
      ? `/api/products/uploads/${req.file.filename}`
      : null;

    const product = new Product({
      sku,
      name,
      price,
      description,
      instock,
      categories: categories?.split(",").map((c) => c.trim()) || [],
      imageUrl,
    });

    await product.save();
    res.status(201).json(product);
  } catch (err) {
    console.error("Error saving product:", err);
    res.status(500).send("Failed to create product");
  }
});

// GET /api/products (fetch all)
app.get("/api/products", async (_req, res) => {
  try {
    const products = await Product.find();
    res.json(products);
  } catch (err) {
    console.error("Fetch error:", err);
    res.status(500).send("Failed to fetch products");
  }
});

// DELETE /api/products/:id
app.delete("/api/products/:id", async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).send("Product not found");

    if (product.imageUrl) {
      const filename = product.imageUrl.split("/uploads/")[1];
      const filePath = path.join(uploadDir, filename);
      if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
    }

    await Product.findByIdAndDelete(req.params.id);
    res.sendStatus(204);
  } catch (err) {
    console.error("Delete failed:", err);
    res.status(500).send("Failed to delete");
  }
});

// ---- START APP ----
const PORT = Number(process.env.PORT) || 80;
app.listen(PORT, () =>
  console.log(`🚀 Product Service listening on port ${PORT}`)
);
