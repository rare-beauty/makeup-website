const mongoose = require("mongoose");
const fs = require("fs");

// Get the file path from environment (set by DevOps / Helm values)
const filePath = process.env.MONGO_URI_FILE;

let mongoUri;

try {
  // Read MongoDB connection string from the CSI-mounted file
  mongoUri = fs.readFileSync(filePath, "utf8").trim();
  console.log("📄 Loaded MongoDB URI from file:", filePath);
} catch (err) {
  console.error("❌ Failed to read Mongo URI file:", err.message);
  process.exit(1); // DO NOT fall back to contact-blog-db
}

// Connect to Cosmos MongoDB
mongoose
  .connect(mongoUri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("✅ Connected to Cosmos MongoDB (Contact-Blog-Service)"))
  .catch((err) => {
    console.error("❌ MongoDB connection error:", err.message);
    process.exit(1);
  });


// ---------------- SCHEMAS ----------------

const contactSchema = new mongoose.Schema({
  name: String,
  email: String,
  message: String,
});

const blogSchema = new mongoose.Schema({
  title: String,
  content: String,
  date: { type: Date, default: Date.now },
});

const Contact = mongoose.model("Contact", contactSchema);
const Blog = mongoose.model("Blog", blogSchema);

module.exports = { Contact, Blog };
