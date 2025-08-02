const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const Review = require("./db");

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.get("/reviews", async (req, res) => {
  const reviews = await Review.find();
  res.json(reviews);
});

app.post("/reviews", async (req, res) => {
  const review = new Review(req.body);
  await review.save();
  res.status(201).send("Review added");
});

const PORT = 4005;
app.listen(PORT, () => console.log(`🚀 Review Service running on ${PORT}`));
