// ============================================================
// Diseases Controller
// ============================================================
const pool = require("../db/pool");

// GET /api/diseases/:id
// Get full disease detail including symptoms, lifecycle, and prevention
const getDiseaseById = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `SELECT id, name, causal_agent, disease_type, description,
              symptoms, favorable_conditions, lifecycle,
              prevention, severity, created_at
       FROM diseases
       WHERE id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Disease not found" });
    }

    // Also get which plants are affected by this disease
    const plantsResult = await pool.query(
      `SELECT p.id, p.common_name, p.scientific_name, pd.notes
       FROM plants p
       JOIN plant_diseases pd ON p.id = pd.plant_id
       WHERE pd.disease_id = $1
       ORDER BY p.common_name`,
      [id]
    );

    res.json({
      ...result.rows[0],
      affected_plants: plantsResult.rows,
    });
  } catch (err) {
    console.error("Error fetching disease:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
};

module.exports = {
  getDiseaseById,
};
