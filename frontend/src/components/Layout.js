import React from "react";
import Navbar from "./Navbar";
import "./Layout.css";

const Layout = ({ children }) => (
  <>
    <Navbar />
    <div className="page-body">{children}</div>

    <footer className="main-footer">
      <div className="footer-content">
        <div className="footer-left">
          <h3>Glamify Beauty</h3>
          <p>Your glow, our mission. Discover, shop, and shine.</p>
        </div>

        <div className="footer-links">
          <a href="/">Home</a>
          <a href="/contact">Contact</a>
          <a href="/blogs">Blog</a>
          <a href="/products">Products</a>
        </div>

        <div className="footer-social">
          <a href="#"><i className="fab fa-facebook-f"></i></a>
          <a href="#"><i className="fab fa-instagram"></i></a>
          <a href="#"><i className="fab fa-twitter"></i></a>
        </div>
      </div>
      <p className="copyright">
        &copy; {new Date().getFullYear()} Glamify Beauty. All rights reserved.
      </p>
    </footer>
  </>
);

export default Layout;
