const mongoose = require("mongoose");

// Read connection string from environment
const connectionString = process.env.USER_DB_CONNECTION;

if (!connectionString) {
  console.error("❌ USER_DB_CONNECTION environment variable is not set");
  process.exit(1); // Exit so the pod fails fast instead of running broken
}

mongoose
  .connect(connectionString, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    console.log("✅ Connected to User DB (Cosmos MongoDB)");
  })
  .catch((err) => {
    console.error("❌ User DB connection error:", err);
    process.exit(1);
  });

const userSchema = new mongoose.Schema({
  name: String,
  email: String,
  role: String,
});

const User = mongoose.model("User", userSchema);

module.exports = User;
