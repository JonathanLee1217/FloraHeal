// ============================================================
// Plants Routes
// ============================================================
const express = require("express");
const router = express.Router();
const {
  searchPlants,
  getPlantById,
  getPlantDiseases,
} = require("../controllers/plantsController");

// GET /api/plants?search={query}  →  Fuzzy search plants
router.get("/", searchPlants);

// GET /api/plants/:id             →  Get plant profile
router.get("/:id", getPlantById);

// GET /api/plants/:id/diseases    →  Get diseases for a plant
router.get("/:id/diseases", getPlantDiseases);

module.exports = router;
