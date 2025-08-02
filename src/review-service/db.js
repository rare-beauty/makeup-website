const mongoose = require("mongoose");

mongoose.connect("mongodb://review-db:27017/reviews", {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log("✅ Connected to Review DB");
}).catch(err => {
  console.error("❌ Review DB connection error:", err);
});

const reviewSchema = new mongoose.Schema({
  productId: String,
  userId: String,
  rating: Number,
  comment: String,
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const Review = mongoose.model("Review", reviewSchema);

module.exports = Review;
