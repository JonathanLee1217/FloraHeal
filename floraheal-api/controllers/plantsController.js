// ============================================================
// Plants Controller
// ============================================================
const pool = require("../db/pool");

// GET /api/plants?search={query}
// Fuzzy search plants by common or scientific name using pg_trgm
const searchPlants = async (req, res) => {
  try {
    const { search } = req.query;

    // If no search query, return all plants
    if (!search || search.trim() === "") {
      const result = await pool.query(
        `SELECT id, common_name, scientific_name, family, plant_type, growing_season, description
         FROM plants
         ORDER BY common_name`
      );
      return res.json(result.rows);
    }

    // Fuzzy search using trigram similarity
    const result = await pool.query(
      `SELECT id, common_name, scientific_name, family, plant_type, growing_season, description,
              GREATEST(
                similarity(common_name, $1),
                similarity(scientific_name, $1)
              ) AS score
       FROM plants
       WHERE common_name % $1
          OR scientific_name % $1
       ORDER BY score DESC`,
      [search]
    );

    res.json(result.rows);
  } catch (err) {
    console.error("Error searching plants:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
};

// GET /api/plants/:id
// Get full plant profile including extended info
const getPlantById = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `SELECT p.id, p.common_name, p.scientific_name, p.family,
              p.plant_type, p.growing_season, p.description, p.created_at,
              pi.soil_type, pi.sunlight, pi.watering,
              pi.hardiness_zone, pi.companion_plants, pi.common_pests
       FROM plants p
       LEFT JOIN plant_info pi ON p.id = pi.plant_id
       WHERE p.id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Plant not found" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error("Error fetching plant:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
};

// GET /api/plants/:id/diseases
// Get all diseases associated with a specific plant
const getPlantDiseases = async (req, res) => {
  try {
    const { id } = req.params;

    // First verify the plant exists
    const plantCheck = await pool.query(
      "SELECT id, common_name FROM plants WHERE id = $1",
      [id]
    );

    if (plantCheck.rows.length === 0) {
      return res.status(404).json({ error: "Plant not found" });
    }

    // Get diseases for this plant
    const result = await pool.query(
      `SELECT d.id, d.name, d.causal_agent, d.disease_type,
              d.description, d.severity, pd.notes AS plant_specific_notes
       FROM diseases d
       JOIN plant_diseases pd ON d.id = pd.disease_id
       WHERE pd.plant_id = $1
       ORDER BY
         CASE d.severity
           WHEN 'critical' THEN 1
           WHEN 'high'     THEN 2
           WHEN 'moderate' THEN 3
           WHEN 'low'      THEN 4
           ELSE 5
         END,
         d.name`,
      [id]
    );

    res.json({
      plant: plantCheck.rows[0],
      diseases: result.rows,
    });
  } catch (err) {
    console.error("Error fetching plant diseases:", err.message);
    res.status(500).json({ error: "Internal server error" });
  }
};

module.exports = {
  searchPlants,
  getPlantById,
  getPlantDiseases,
};
