import React, { useState } from "react";
import axios from "axios";
//import contactImage from "../assets/contact.jpg"; // ✅ Import your banner image

const Contact = () => {
  const [form, setForm] = useState({ name: "", email: "", message: "" });

  const handleChange = (e) =>
    setForm({ ...form, [e.target.name]: e.target.value });

  const handleSubmit = (e) => {
    e.preventDefault();
    axios
      .post("http://localhost:4001/contact", form)
      .then(() => {
        alert("💌 Message sent!");
        setForm({ name: "", email: "", message: "" });
      })
      .catch(() => alert("❌ Failed to send"));
  };

  return (
    <div style={styles.container}>
      {/*<img src={contactImage} alt="Contact" style={styles.banner} />*/}
      <h2 style={styles.title}>📩 Contact Us</h2>
      <form onSubmit={handleSubmit} style={styles.form}>
        <input
          name="name"
          placeholder="Your Name"
          value={form.name}
          onChange={handleChange}
          required
          style={styles.input}
        />
        <input
          name="email"
          placeholder="Your Email"
          value={form.email}
          onChange={handleChange}
          required
          style={styles.input}
        />
        <textarea
          name="message"
          placeholder="Your Message"
          value={form.message}
          onChange={handleChange}
          required
          style={styles.textarea}
        />
        <button type="submit" style={styles.button}>Send Message</button>
      </form>
    </div>
  );
};

const styles = {
  container: {
    padding: 30,
    backgroundColor: "#121212",
    color: "#eee",
    fontFamily: "Arial, sans-serif",
    minHeight: "100vh",
  },
  banner: {
    width: "100%",
    borderRadius: 12,
    maxHeight: 300,
    objectFit: "cover",
    marginBottom: 30,
  },
  title: {
    fontSize: "2rem",
    textAlign: "center",
    color: "#ff66b2",
    marginBottom: 30,
  },
  form: {
    display: "flex",
    flexDirection: "column",
    gap: 15,
    width: "100%",
    maxWidth: 500,
    margin: "0 auto",
  },
  input: {
    padding: 12,
    borderRadius: 8,
    border: "1px solid #ccc",
    fontSize: 16,
    backgroundColor: "#1f1f1f",
    color: "#fff",
  },
  textarea: {
    padding: 12,
    borderRadius: 8,
    border: "1px solid #ccc",
    fontSize: 16,
    minHeight: 120,
    backgroundColor: "#1f1f1f",
    color: "#fff",
  },
  button: {
    backgroundColor: "#ff66b2",
    color: "#fff",
    padding: 12,
    borderRadius: 8,
    fontSize: 16,
    border: "none",
    cursor: "pointer",
  },
};

export default Contact;
