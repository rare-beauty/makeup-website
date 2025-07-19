import React from "react";
import homeBanner from "../assets/home-banner.jpg";
import DealsSlider from "../components/DealsSlider";
import { useNavigate } from "react-router-dom";

const Home = () => {
  const navigate = useNavigate(); // ✅ Navigation hook

  return (
    <div style={styles.container}>
      {/* Banner Image */}
      <img src={homeBanner} alt="Home Banner" style={styles.banner} />

      {/* Introduction Section */}
      <section style={introSection}>
        <h1 style={introHeading}>Welcome to Glamify Beauty 💄</h1>
        <p style={introText}>
          Glamify Beauty is your ultimate destination for all things glamorous and glowing. Whether you're seeking bold eyeshadow palettes, nourishing skincare essentials, or trend-setting lip colors, we bring the magic of beauty to your fingertips. Our carefully curated products are designed to celebrate individuality and confidence in every shade, texture, and glow.
        </p>
        <p style={introText}>
          Explore top-rated collections, connect with fellow beauty lovers, read engaging blogs, and shop with ease. At Glamify Beauty, we believe beauty is power—and you deserve to shine your brightest, every day. 💋
        </p>
      </section>

      {/* Deals Slider */}
      <DealsSlider />

      {/* Call to Action */}
      <section style={styles.ctaGlow}>
        <h2 style={styles.ctaTitle}>💖 Reveal Your Inner Glow</h2>
        <p style={styles.ctaText}>
          Discover handpicked makeup products that enhance your natural beauty. Shop the latest trends with confidence and style.
        </p>
        <button
          style={styles.ctaButton}
          onClick={() => navigate("/products")} // ✅ Navigate to products page
        >
          Shop Now
        </button>
      </section>

      {/* Testimonials */}
      <section style={styles.testimonialSection}>
        <h2 style={styles.testimonialTitle}>💬 What Our Customers Say</h2>
        <div style={styles.testimonialGrid}>
          {[
            { name: "Simran", message: "Super fast delivery and quality products!" },
            { name: "Alisha", message: "Absolutely in love with the lipstick shades. Glam and classy!" },
            { name: "Meera", message: "Quick delivery and the packaging was gorgeous!" }
          ].map((t, i) => (
            <div key={i} style={styles.testimonialCard}>
              <p style={{ fontStyle: "italic", color: "#ddd" }}>"{t.message}"</p>
              <p style={{ fontWeight: "bold", marginTop: 10, color: "#fbbebe" }}>– {t.name}</p>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
};

// === Inline Styles ===
const styles = {
  container: {
    padding: 30,
    fontFamily: "Arial, sans-serif",
    backgroundColor: "#121212",
    color: "#eee",
  },
  banner: {
    width: "100%",
    borderRadius: 10,
    marginBottom: 30,
  },
  ctaGlow: {
    backgroundColor: "#1f1f1f",
    padding: 50,
    textAlign: "center",
    borderRadius: 10,
    margin: "60px auto 40px",
    boxShadow: "0 4px 20px rgba(255, 105, 180, 0.1)",
  },
  ctaTitle: {
    color: "#ff66b2",
    fontSize: "2rem",
    marginBottom: 15,
  },
  ctaText: {
    fontSize: "1.1rem",
    color: "#ccc",
    marginBottom: 20,
  },
  ctaButton: {
    backgroundColor: "#ff66b2",
    color: "#fff",
    border: "none",
    borderRadius: "30px",
    padding: "12px 28px",
    fontSize: "1rem",
    cursor: "pointer",
    transition: "background 0.3s ease",
  },
  testimonialSection: {
    padding: "40px 20px",
    marginTop: 40,
    backgroundColor: "#1a1a1a",
    borderRadius: 10,
  },
  testimonialTitle: {
    color: "#ffa726",
    fontSize: "1.8rem",
    marginBottom: 30,
    textAlign: "center",
  },
  testimonialGrid: {
    display: "flex",
    flexWrap: "wrap",
    gap: "20px",
    justifyContent: "center",
  },
  testimonialCard: {
    backgroundColor: "#2c2c2c",
    padding: 25,
    borderRadius: 12,
    boxShadow: "0 4px 10px rgba(0,0,0,0.3)",
    maxWidth: 300,
    transition: "transform 0.3s",
  },
};

const introSection = {
  marginTop: 20,
  padding: 30,
  backgroundColor: "#1f1f1f",
  borderRadius: 10,
  color: "#f5f5f5",
  boxShadow: "0 4px 12px rgba(0,0,0,0.5)",
  textAlign: "center",
};

const introHeading = {
  fontSize: "2.5rem",
  marginBottom: 20,
  color: "#ff66b2",
  fontWeight: "bold",
};

const introText = {
  fontSize: "1.2rem",
  lineHeight: "1.8",
  marginBottom: "20px",
};

export default Home;
