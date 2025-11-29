// db.js (user-service)
const mongoose = require("mongoose");
const fs = require("fs");

const filePath = process.env.MONGO_URI_FILE;

let mongoUri;

try {
  mongoUri = fs.readFileSync(filePath, "utf8").trim();
  console.log("Loaded MongoDB URI from file:", filePath);
} catch (err) {
  console.error("❌ Failed to read Mongo URI file:", err.message);
  process.exit(1); // important: fail fast like contact service
}

mongoose
  .connect(mongoUri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("✅ Connected to Cosmos MongoDB (User Service)"))
  .catch((err) => {
    console.error("❌ User DB connection error:", err.message);
    process.exit(1);
  });

// 🔹 Point this schema to the SAME collection as Contact
const contactUserSchema = new mongoose.Schema(
  {
    name: String,
    email: String,
    message: String, // optional, but nice to keep
  },
  {
    collection: "contacts", // 👈 this is the key: use the "contacts" collection
  }
);

const ContactUser = mongoose.model("ContactUser", contactUserSchema);

module.exports = ContactUser;
