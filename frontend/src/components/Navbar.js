import React from "react";
import { Link } from "react-router-dom";
import "./Navbar.css";
import logo from "../assets/logo.png"; // ✅ Check if this exists

const Navbar = () => (
  <nav className="navbar">
    <Link to="/" className="navbar-logo"> {/* ⬅️ Wrap the logo+name */}
      <img src={logo} alt="Beauty" className="logo-image" />
      <span className="brand-name">Beauty</span>
    </Link>
    <div className="navbar-links">
      <Link to="/">Home</Link>
      <Link to="/blogs">Blog</Link>
      <Link to="/contact">Contact</Link>
      <Link to="/users">Users</Link>
      <Link to="/products">Products</Link>
      <Link to="/orders">Orders</Link>
      <Link to="/reviews">Reviews</Link>
    </div>
  </nav>
);

export default Navbar;
