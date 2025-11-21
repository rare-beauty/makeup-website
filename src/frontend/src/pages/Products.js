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

  // ---- FETCH PRODUCTS ----
  const fetchProducts = async () => {
    try {
      const res = await axios.get("/api/products");
      setProducts(res.data);
    } catch (err) {
      console.error("❌ Fetch error:", err);
    }
  };

  useEffect(() => {
    fetchProducts();
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
    Object.keys(form).forEach((key) => {
      if (key !== "image") data.append(key, form[key]);
    });

    if (form.image) data.append("image", form.image);

    try {
      const res = await axios.post("/api/products", data);
      if (res.status === 201) {
        alert("Product uploaded!");
        // 🔁 instead of full page reload, just refresh products in state
        await fetchProducts();
      }
    } catch (err) {
      console.error("❌ Upload failed:", err);
      alert("❌ Failed to upload product.");
    }
  };

  const handleDelete = async (productId) => {
    if (!window.confirm("Delete this product?")) return;
    try {
      await axios.delete(`/api/products/${productId}`);
      setProducts((prev) => prev.filter((p) => p._id !== productId));
    } catch (err) {
      console.error("❌ Delete failed:", err);
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
        <button type="submit" style={uploadBtn}>Upload</button>
      </form>

      <h2>Products</h2>
      <div style={grid}>
        {products.map((p, i) => (
          <div key={i} style={card}>
            <h3>{p.name}</h3>

            {p.imageUrl ? (
              <img
                src={p.imageUrl}   // FULL correct backend path
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
              <div style={{ height: 200, background: "#eee" }}>No image</div>
            )}

            <p>{p.description}</p>
            <p><b>Price:</b> ${p.price}</p>

            <button onClick={() => handleDelete(p._id)} style={deleteBtn}>
              Delete
            </button>
          </div>
        ))}
      </div>
    </div>
  );
};

const grid = { display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(300px, 1fr))", gap: 20 };
const formStyle = { display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10, marginBottom: 30 };
const card = { border: "1px solid #ccc", padding: 15, borderRadius: 8, background: "#fff" };
const uploadBtn = { gridColumn: "span 2", padding: 10, background: "#28a745", color: "#fff", border: "none", borderRadius: 6 };
const deleteBtn = { backgroundColor: "#dc3545", color: "#fff", border: "none", padding: 10, borderRadius: 6 };
const dropZone = { gridColumn: "span 2", border: "2px dashed #aaa", padding: 20, textAlign: "center", borderRadius: 6 };
const previewStyle = { maxWidth: "100%", maxHeight: 200, borderRadius: 6 };

export default Products;
