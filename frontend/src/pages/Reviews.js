import React, { useEffect, useState } from "react";
import axios from "axios";
import reviewsImage from "../assets/reviews.png"; // Your banner image


const Reviews = () => {
  const reviews = [
    {
      productId: "Lip Gloss Set",
      userId: "Sophie",
      rating: 5,
      comment: "Absolutely loved the shine and texture! Will definitely buy again."
    },
    {
      productId: "Matte Foundation",
      userId: "Ava",
      rating: 4,
      comment: "Gives full coverage and lasts long. Just wish it had more shades."
    },
    {
      productId: "Blush Palette",
      userId: "Emma",
      rating: 5,
      comment: "Pigmented and blends perfectly! A must-have in your kit 💕"
    },
    {
      productId: "Waterproof Mascara",
      userId: "Mia",
      rating: 5,
      comment: "Lasts all day and doesn’t smudge. Makes lashes pop!"
    },
    {
      productId: "Highlighter Stick",
      userId: "Olivia",
      rating: 4,
      comment: "Gives a soft glow. Easy to apply and travel-friendly."
    },
    {
      productId: "Nude Lipstick Kit",
      userId: "Isabella",
      rating: 5,
      comment: "Perfect nudes for every skin tone. Feels luxurious!"
    },
  ];

  return (
    <div style={styles.container}>
      <img
        src={reviewsImage}
        alt="Reviews"
        style={styles.banner}
      />
      <h2 style={styles.title}>🌟 Customer Reviews</h2>
      <div style={styles.grid}>
        {reviews.map((r, i) => (
          <div key={i} style={styles.card}>
            <p style={styles.product}><b>🛍️ Product:</b> {r.productId}</p>
            <p style={styles.user}><b>👤 User:</b> {r.userId}</p>
            <p style={styles.rating}><b>⭐ Rating:</b> {r.rating}/5</p>
            <p style={styles.comment}>💬 {r.comment}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

const styles = {
  container: {
    padding: "40px 25px",
    backgroundColor: "#111",
    color: "#f3f3f3",
    minHeight: "100vh",
    fontFamily: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif",
  },
  banner: {
    width: "100%",
    borderRadius: 12,
    marginBottom: 30,
    maxHeight: 300,
    objectFit: "cover",
  },
  title: {
    textAlign: "center",
    fontSize: "2.5rem",
    color: "#ffcc70",
    marginBottom: 40,
    letterSpacing: 1,
    textShadow: "1px 1px 5px rgba(255, 204, 112, 0.5)",
  },
  grid: {
    display: "flex",
    flexWrap: "wrap",
    gap: 25,
    justifyContent: "center",
  },
  card: {
    background: "#1c1c1c",
    padding: 20,
    borderRadius: 12,
    width: 300,
    boxShadow: "0 4px 12px rgba(255, 204, 112, 0.1)",
    border: "1px solid #2c2c2c",
    transition: "transform 0.2s ease",
  },
  product: {
    fontSize: "16px",
    color: "#ffcce0",
    marginBottom: 5,
  },
  user: {
    fontSize: "14px",
    color: "#bbb",
    marginBottom: 5,
  },
  rating: {
    fontSize: "14px",
    color: "#ffe680",
    marginBottom: 5,
  },
  comment: {
    fontSize: "15px",
    color: "#e9c8ff",
    fontStyle: "italic",
  },
};

export default Reviews;
