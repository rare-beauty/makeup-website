const mongoose = require("mongoose");

mongoose.connect("mongodb://contact-blog-db:27017/contactblog", {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log("✅ Connected to Contact-Blog DB");
}).catch(err => {
  console.error("❌ DB connection error:", err);
});

const contactSchema = new mongoose.Schema({
  name: String,
  email: String,
  message: String
});

const blogSchema = new mongoose.Schema({
  title: String,
  content: String,
  date: { type: Date, default: Date.now }
});

const Contact = mongoose.model("Contact", contactSchema);
const Blog = mongoose.model("Blog", blogSchema);

module.exports = { Contact, Blog };
