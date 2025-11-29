const mongoose = require("mongoose");
const fs = require("fs");

// Get the file path from environment (set by DevOps / Helm)
const filePath = process.env.MONGO_URI_FILE;

let mongoUri;

try {
  // Read MongoDB connection string from the CSI-mounted file
  mongoUri = fs.readFileSync(filePath, "utf8").trim();
  console.log("Loaded MongoDB URI from file:", filePath);
} catch (err) {
  console.error("❌ Failed to read Mongo URI file:", err.message);
}

// Connect to Cosmos MongoDB
mongoose
  .connect(mongoUri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("✅ Connected to User DB (Cosmos MongoDB)"))
  .catch((err) => console.error("❌ User DB connection error:", err.message));

// ---------------- SCHEMA ----------------
const userSchema = new mongoose.Schema({
  name: String,
  email: String,
  role: String,
});

const User = mongoose.model("User", userSchema);

module.exports = User;
