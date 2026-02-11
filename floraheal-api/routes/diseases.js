// ============================================================
// Diseases Routes
// ============================================================
const express = require("express");
const router = express.Router();
const { getDiseaseById } = require("../controllers/diseasesController");

// GET /api/diseases/:id  →  Get full disease detail
router.get("/:id", getDiseaseById);

module.exports = router;
