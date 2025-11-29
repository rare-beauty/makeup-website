// index.js (user-service)
const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const ContactUser = require("./db"); // renamed

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.get("/healthz", (req, res) => {
  res.status(200).send("OK");
});

// GET: show all contact submissions on "Users" page
app.get(["/users", "/api/users"], async (req, res) => {
  try {
    const users = await ContactUser.find().sort({ _id: -1 });
    res.json(users);
  } catch (err) {
    console.error("❌ Error fetching users:", err);
    res.status(500).json({ error: "Something went wrong" });
  }
});

// (Optional) POST if you still want to manually add users – or you can remove this
app.post(["/users", "/api/users"], async (req, res) => {
  try {
    const user = new ContactUser(req.body);
    await user.save();
    res.status(201).send("User created");
  } catch (err) {
    console.error("❌ Error creating user:", err);
    res.status(500).json({ error: "Something went wrong" });
  }
});

const PORT = process.env.PORT || 4002;
app.listen(PORT, () => console.log(`User Service running on ${PORT}`));
