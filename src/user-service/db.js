const mongoose = require("mongoose");

mongoose.connect("mongodb://user-db:27017/users", {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log("✅ Connected to User DB");
}).catch(err => {
  console.error("❌ User DB connection error:", err);
});

const userSchema = new mongoose.Schema({
  name: String,
  email: String,
  role: String
});

const User = mongoose.model("User", userSchema);

module.exports = User;
