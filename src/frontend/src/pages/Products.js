import React, { useEffect, useState, useRef } from "react";
import axios from "axios";

const Products = () => {
  const [products, setProducts] = useState([]);
  const [form, setForm] = useState({
    sku: "",
    name: "",
    price: "",
    description: "",
    categories: "",
    instock: "",
    image: null,
  });
  const [preview, setPreview] = useState(null);
  const dropRef = useRef(null);

  useEffect(() => {
    axios
      .get("/api/products")
      .then((res) => setProducts(res.data))
      .catch((err) => console.error("❌ Fetch error:", err));
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setForm((prev) => ({ ...prev, image: file }));
      setPreview(URL.createObjectURL(file));
    }
  };

  const handleDrop = (e) => {
    e.preventDefault();
    const file = e.dataTransfer.files[0];
    if (file) {
      setForm((prev) => ({ ...prev, image: file }));
      setPreview(URL.createObjectURL(file));
    }
  };

  const handleDragOver = (e) => e.preventDefault();

  const handleSubmit = async (e) => {
    e.preventDefault();

    const data = new FormData();
    data.append("sku", form.sku);
    data.append("name", form.name);
    data.append("price", form.price);
    data.append("description", form.description);
    data.append("categories", form.categories);
    data.append("instock", form.instock);

    if (form.image) {
      data.append("image", form.image); // ✅ this must match Multer field name
    }

    try {
      const res = await axios.post("/api/products", data);
      if (res.status === 201) {
        alert("✅ Product uploaded!");
        window.location.reload();
      }
    } catch (err) {
      console.error("❌ Upload failed:", err.response?.data || err.message);
      alert(`❌ Upload failed: ${err.response?.data?.error || err.message}`);
    }
  };


  const handleAddToCart = async (product) => {
    try {
      await axios.post("/api/orders", {
        productId: product._id,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl,
      });
      alert("🛒 Added to cart!");
    } catch (err) {
      console.error("❌ Add to cart failed:", err);
      alert("❌ Failed to add to cart.");
    }
  };

  const handleDelete = async (productId) => {
    if (!window.confirm("Are you sure you want to delete this product?")) return;
    try {
      await axios.delete(`/api/products/${productId}`);
      alert("🗑️ Product deleted");
      setProducts((prev) => prev.filter((p) => p._id !== productId));
    } catch (err) {
      console.error("❌ Delete failed:", err);
      alert("❌ Failed to delete");
    }
  };

  return (
    <div style={{ padding: 20 }}>
      <h2>Add Product</h2>
      <form onSubmit={handleSubmit} style={formStyle}>
        <input name="sku" placeholder="SKU" onChange={handleChange} required />
        <input name="name" placeholder="Name" onChange={handleChange} required />
        <input name="price" placeholder="Price" onChange={handleChange} required />
        <input name="description" placeholder="Description" onChange={handleChange} required />
        <input name="categories" placeholder="Categories (comma-separated)" onChange={handleChange} />
        <input name="instock" placeholder="Stock" onChange={handleChange} required />

        <div
          ref={dropRef}
          onDrop={handleDrop}
          onDragOver={handleDragOver}
          style={dropZone}
        >
          {preview ? (
            <img src={preview} alt="Preview" style={previewStyle} />
          ) : (
            "Drag & Drop Image Here or Click Below"
          )}
        </div>

        <input type="file" accept="image/*" name="image" onChange={handleImageChange} />
        <button type="submit" style={uploadBtn}>📤 Upload</button>
      </form>

      <h2>Products</h2>
      <div style={grid}>
        {products.map((p, i) => (
          <div key={i} style={{ ...card, animation: "fadeIn 0.6s ease" }}>
            <h3>{p.name}</h3>
            {p.imageUrl ? (
              <img
                src={`/api/products${p.imageUrl}`}
                alt={p.name}
                style={{
                  width: "100%",
                  height: 200,
                  objectFit: "contain",
                  background: "#f9f9f9",
                  borderRadius: 5,
                }}
              />
            ) : (
              <div style={{ height: 200, background: "#eee", display: "flex", alignItems: "center", justifyContent: "center" }}>
                No image
              </div>
            )}

            <p>{p.description}</p>
            <p><b>Price:</b> ${p.price}</p>
            <div style={{ display: "flex", gap: "10px", marginTop: 10 }}>
              <button onClick={() => handleAddToCart(p)} style={addToCartBtn}>🛒 Add to Cart</button>
              <button onClick={() => handleDelete(p._id)} style={deleteBtn}>🗑️ Delete</button>
            </div>
          </div>
        ))}
      </div>

      <style>
        {`@keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }`}
      </style>
    </div>
  );
};

const grid = {
  display: "grid",
  gridTemplateColumns: "repeat(auto-fill, minmax(300px, 1fr))",
  gap: 20,
};

const formStyle = {
  display: "grid",
  gridTemplateColumns: "1fr 1fr",
  gap: 10,
  marginBottom: 30,
};

const card = {
  border: "1px solid #ccc",
  padding: 15,
  borderRadius: 8,
  background: "#fff",
  boxShadow: "0 2px 8px rgba(0,0,0,0.1)",
};

const addToCartBtn = {
  backgroundColor: "#007BFF",
  color: "#fff",
  border: "none",
  padding: "10px 14px",
  borderRadius: 6,
  fontWeight: "bold",
  boxShadow: "0 3px 5px rgba(0, 0, 0, 0.1)",
  cursor: "pointer",
};

const deleteBtn = {
  backgroundColor: "#DC3545",
  color: "#fff",
  border: "none",
  padding: "10px 14px",
  borderRadius: 6,
  fontWeight: "bold",
  cursor: "pointer",
  boxShadow: "0 3px 5px rgba(0, 0, 0, 0.1)",
};

const uploadBtn = {
  gridColumn: "span 2",
  backgroundColor: "#28a745",
  color: "#fff",
  border: "none",
  padding: "10px 16px",
  borderRadius: 6,
  fontWeight: "bold",
  cursor: "pointer",
  boxShadow: "0 3px 6px rgba(0, 0, 0, 0.1)",
};

const dropZone = {
  gridColumn: "span 2",
  border: "2px dashed #aaa",
  padding: 20,
  textAlign: "center",
  borderRadius: 6,
  backgroundColor: "#f0f0f0",
  cursor: "pointer",
};

const previewStyle = {
  maxWidth: "100%",
  maxHeight: 200,
  borderRadius: 6,
};

export default Products;
