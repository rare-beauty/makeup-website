const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const bodyParser = require("body-parser");

// ✅ Models
const Contact = require("./models/Contact");
const Blog = require("./models/Blog");

const app = express();
app.use(cors());
app.use(bodyParser.json());

// ✅ MongoDB Connection
mongoose.connect("mongodb://contact-blog-db:27017/contactBlogDB", {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log("✅ Connected to Contact-Blog DB"))
.catch((err) => console.error("❌ MongoDB Connection Error:", err));

// ✅ Contact Form POST
app.post("/contact", async (req, res) => {
  try {
    const { name, email, message } = req.body;
    const contact = new Contact({ name, email, message });
    await contact.save();
    res.status(201).json({ message: "Contact saved successfully!" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Something went wrong" });
  }
});

// ✅ Get All Contacts
app.get("/contact", async (req, res) => {
  const allContacts = await Contact.find().sort({ createdAt: -1 });
  res.json(allContacts);
});

// ✅ Blog Endpoints
app.get("/blogs", async (req, res) => {
  const blogs = await Blog.find().sort({ date: -1 });
  res.json(blogs);
});

app.post("/blogs", async (req, res) => {
  const newBlog = new Blog(req.body);
  await newBlog.save();
  res.status(201).send("Blog added");
});

const PORT = 4001;
app.listen(PORT, () => console.log(`🚀 Contact-Blog Service running on ${PORT}`));
