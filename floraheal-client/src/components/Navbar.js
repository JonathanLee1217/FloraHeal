import React from "react";
import { Link } from "react-router-dom";

function Navbar() {
  return (
    <nav className="navbar">
      <div className="container">
        <Link to="/" className="navbar-brand">
          <span className="leaf-icon">🌿</span>
          FloraHeal
        </Link>
        <div className="navbar-links">
          <Link to="/">Home</Link>
        </div>
      </div>
    </nav>
  );
}

export default Navbar;
