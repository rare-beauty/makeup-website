const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");

// ✅ DB + Models (this file handles Mongo connection using MONGO_URI_FILE)
const { Contact, Blog } = require("./db");

const app = express();
app.use(cors());
app.use(bodyParser.json());

/**
 * Simple health endpoint for probes
 */
app.get("/healthz", (req, res) => {
  res.status(200).send("OK");
});


// ------------- CONTACT ENDPOINTS -------------

// Reusable handler for creating a contact
const createContactHandler = async (req, res) => {
  try {
    const { name, email, message } = req.body;
    const contact = new Contact({ name, email, message });
    await contact.save();
    res.status(201).json({ message: "Contact saved successfully!" });
  } catch (err) {
    console.error("❌ Error saving contact:", err);
    res.status(500).json({ error: "Something went wrong" });
  }
};

// Reusable handler for fetching all contacts
const getContactsHandler = async (req, res) => {
  try {
   // const allContacts = await Contact.find().sort({ createdAt: -1 });
    const allContacts = await Contact.find().sort({ _id: -1 });
    res.json(allContacts);
  } catch (err) {
    console.error("Error fetching contacts:", err);
    res.status(500).json({ error: "Something went wrong" });
  }
};

// ✅ API paths used by Ingress/probes
app.post("/api/contact", createContactHandler);
app.get("/api/contact", getContactsHandler);

//  Legacy / shorter paths (optional, keep for compatibility)
app.post("/contact", createContactHandler);
app.get("/contact", getContactsHandler);


// ------------- BLOG ENDPOINTS -------------

app.get("/api/blogs", async (req, res) => {
  try {
    const blogs = await Blog.find().sort({ date: -1 });
    res.json(blogs);
  } catch (err) {
    console.error("❌ Error fetching blogs:", err);
    res.status(500).json({ error: "Something went wrong" });
  }
});

app.post("/api/blogs", async (req, res) => {
  try {
    const newBlog = new Blog(req.body);
    await newBlog.save();
    res.status(201).send("Blog added");
  } catch (err) {
    console.error("❌ Error saving blog:", err);
    res.status(500).json({ error: "Something went wrong" });
  }
});

// Optional legacy paths
app.get("/blogs", async (req, res) => {
  try {
    const blogs = await Blog.find().sort({ date: -1 });
    res.json(blogs);
  } catch (err) {
    console.error("❌ Error fetching blogs:", err);
    res.status(500).json({ error: "Something went wrong" });
  }
});

app.post("/blogs", async (req, res) => {
  try {
    const newBlog = new Blog(req.body);
    await newBlog.save();
    res.status(201).send("Blog added");
  } catch (err) {
    console.error("❌ Error saving blog:", err);
    res.status(500).json({ error: "Something went wrong" });
  }
});


const PORT = process.env.PORT || 4001;
app.listen(PORT, () => console.log(`🚀 Contact-Blog Service running on ${PORT}`));
