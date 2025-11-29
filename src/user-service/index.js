const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const User = require("./db");

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Health check
app.get("/healthz", (req, res) => {
  res.status(200).send("OK");
});

app.get("/users", async (req, res) => {
  const users = await User.find();
  res.json(users);
});

app.post("/users", async (req, res) => {
  const user = new User(req.body);
  await user.save();
  res.status(201).send("User created");
});

const PORT = 4002;
app.listen(PORT, () => console.log(`User Service running on ${PORT}`));
