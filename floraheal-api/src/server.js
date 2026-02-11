// ============================================================
// FloraHeal API - Server Entry Point
// ============================================================
require("dotenv").config();

const express = require("express");
const cors = require("cors");

// Routes
const plantsRoutes = require("./routes/plants");
const diseasesRoutes = require("./routes/diseases");

// Middleware
const { notFound, errorHandler } = require("./middleware/errorHandler");

// Initialize Express
const app = express();
const PORT = process.env.PORT || 5000;

// ── Global Middleware ──
app.use(cors());
app.use(express.json());

// ── API Routes ──
app.use("/api/plants", plantsRoutes);
app.use("/api/diseases", diseasesRoutes);

// ── Health Check ──
app.get("/api/health", (req, res) => {
  res.json({
    status: "ok",
    service: "FloraHeal API",
    version: "1.0.0",
    timestamp: new Date().toISOString(),
  });
});

// ── Error Handling ──
app.use(notFound);
app.use(errorHandler);

// ── Start Server ──
app.listen(PORT, () => {
  console.log(`
  🌿 FloraHeal API is running!
  ───────────────────────────────
  Local:   http://localhost:${PORT}
  Health:  http://localhost:${PORT}/api/health
  ───────────────────────────────
  Endpoints:
    GET /api/plants?search={query}
    GET /api/plants/:id
    GET /api/plants/:id/diseases
    GET /api/diseases/:id
  ───────────────────────────────
  `);
});
