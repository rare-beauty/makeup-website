import React, { useEffect, useState } from "react";
import axios from "axios";
import blogImage from "../assets/blog.png"; // Your blog header image

const Blog = () => {
  const [blogs, setBlogs] = useState([]);

  useEffect(() => {
    // Dummy blog posts for beauty website
    const dummyBlogs = [
      {
        title: "Top 5 Lipsticks Every Girl Needs 💄",
        content:
          "From matte nudes to glossy reds, discover the must-have lipsticks that suit every occasion and skin tone.",
        date: new Date("2023-11-10"),
      },
      {
        title: "Skincare Routine for Glowing Skin ✨",
        content:
          "A perfect skincare routine starts with cleansing, toning, and moisturizing. Learn what products to use and when.",
        date: new Date("2024-01-15"),
      },
      {
        title: "How to Choose Your Foundation Shade 🧴",
        content:
          "Finding your perfect match can be tricky. Here’s a quick guide on undertones and swatches to get the right one.",
        date: new Date("2024-02-22"),
      },
      {
        title: "5-Minute Daily Makeup Look ⏱️",
        content:
          "Short on time? Master a quick natural look that includes BB cream, mascara, and a pop of blush.",
        date: new Date("2024-03-30"),
      },
      {
        title: "Makeup Hacks from Professionals 💡",
        content:
          "Discover top makeup artist tips that will make your makeup last longer and look flawless all day.",
        date: new Date("2024-04-18"),
      },
      {
        title: "Trending 2024 Eye Shadow Palettes 🎨",
        content:
          "Explore this year’s hottest palettes with bold pigments and buttery textures from top brands.",
        date: new Date("2024-06-05"),
      },
    ];

    setBlogs(dummyBlogs);
  }, []);

  return (
    <div style={styles.container}>
      <img src={blogImage} alt="Blog Banner" style={styles.banner} />
      <h2 style={styles.title}>📝 Beauty & Glam Blog</h2>

      <div style={styles.grid}>
        {blogs.map((b, i) => (
          <div key={i} style={styles.card}>
            <h3 style={styles.cardTitle}>{b.title}</h3>
            <p style={styles.cardContent}>
              {b.content.length > 200
                ? b.content.substring(0, 200) + "..."
                : b.content}
            </p>
            <small style={styles.date}>
              {new Date(b.date).toLocaleDateString()}
            </small>
            <button style={styles.readMore}>Read More</button>
          </div>
        ))}
      </div>
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
    borderRadius: 10,
    marginBottom: 30,
    maxHeight: 300,
    objectFit: "cover",
  },
  title: {
    fontSize: "2.5rem",
    marginBottom: 30,
    textAlign: "center",
    color: "#ff66b2",
  },
  grid: {
    display: "flex",
    flexWrap: "wrap",
    gap: "25px",
    justifyContent: "center",
  },
  card: {
    backgroundColor: "#1f1f1f",
    padding: 25,
    borderRadius: 12,
    width: "300px",
    boxShadow: "0 4px 12px rgba(255, 105, 180, 0.1)",
    display: "flex",
    flexDirection: "column",
    justifyContent: "space-between",
  },
  cardTitle: {
    fontSize: "20px",
    color: "#fbbebe",
    marginBottom: 10,
  },
  cardContent: {
    fontSize: "14px",
    color: "#ccc",
    marginBottom: 15,
  },
  date: {
    fontSize: "12px",
    color: "#888",
    marginBottom: 10,
  },
  readMore: {
    padding: "8px 16px",
    borderRadius: 20,
    border: "none",
    backgroundColor: "#ff66b2",
    color: "#fff",
    fontWeight: "bold",
    cursor: "pointer",
    alignSelf: "flex-start",
  },
};

export default Blog;

