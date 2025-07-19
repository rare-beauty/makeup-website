const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: String,
  price: Number,
  imageUrl: String,  // ✅ add this
  description: String
});

module.exports = mongoose.model('Product', productSchema);
