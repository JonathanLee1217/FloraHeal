import React, { useState, useEffect } from "react";
import { useParams, useNavigate, Link } from "react-router-dom";
import { getPlantById, getPlantDiseases } from "../services/api";
import Loading from "../components/Loading";
import SeverityBadge from "../components/SeverityBadge";

function PlantProfile() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [plant, setPlant] = useState(null);
  const [diseases, setDiseases] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      setError(null);
      try {
        const [plantData, diseaseData] = await Promise.all([
          getPlantById(id),
          getPlantDiseases(id),
        ]);
        setPlant(plantData);
        setDiseases(diseaseData.diseases || []);
      } catch (err) {
        setError("Failed to load plant data. Please try again.");
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id]);

  if (loading) return <div className="container"><Loading message="Loading plant profile..." /></div>;
  if (error) return <div className="container"><div className="error-state"><p>{error}</p></div></div>;
  if (!plant) return null;

  // Build info cards from available data
  const infoItems = [
    { label: "Family", value: plant.family },
    { label: "Type", value: plant.plant_type },
    { label: "Growing Season", value: plant.growing_season },
    { label: "Soil Type", value: plant.soil_type },
    { label: "Sunlight", value: plant.sunlight },
    { label: "Watering", value: plant.watering },
    { label: "Hardiness Zone", value: plant.hardiness_zone ? `Zone ${plant.hardiness_zone}` : null },
    { label: "Companion Plants", value: plant.companion_plants },
    { label: "Common Pests", value: plant.common_pests },
  ].filter((item) => item.value);

  return (
    <div className="plant-profile">
      <div className="container">
        {/* Breadcrumb */}
        <div className="breadcrumb">
          <Link to="/">Home</Link>
          <span>›</span>
          {plant.common_name}
        </div>

        {/* Back Button */}
        <button className="back-button" onClick={() => navigate(-1)}>
          ← Back to results
        </button>

        {/* Plant Header */}
        <div className="plant-header">
          {plant.plant_type && (
            <span className="plant-type-badge">{plant.plant_type}</span>
          )}
          <h1>{plant.common_name}</h1>
          <p className="scientific">{plant.scientific_name}</p>
          {plant.description && (
            <p className="description">{plant.description}</p>
          )}
        </div>

        {/* Plant Info Grid */}
        {infoItems.length > 0 && (
          <div className="info-grid">
            {infoItems.map((item, index) => (
              <div key={index} className="info-card">
                <div className="info-label">{item.label}</div>
                <div className="info-value">{item.value}</div>
              </div>
            ))}
          </div>
        )}

        {/* Disease List */}
        <div className="diseases-section">
          <h2>
            Associated Diseases ({diseases.length})
          </h2>

          {diseases.length === 0 ? (
            <div className="empty-state">
              <div className="empty-icon">✅</div>
              <h3>No diseases recorded</h3>
              <p>This plant has no known diseases in our database yet.</p>
            </div>
          ) : (
            diseases.map((disease) => (
              <div
                key={disease.id}
                className="disease-card"
                onClick={() => navigate(`/diseases/${disease.id}`)}
              >
                <div className="disease-card-content">
                  <h3>{disease.name}</h3>
                  <p className="causal-agent">
                    {disease.causal_agent} • {disease.disease_type}
                  </p>
                  <p className="disease-desc">{disease.description}</p>
                  {disease.plant_specific_notes && (
                    <p className="plant-note">
                      📝 {disease.plant_specific_notes}
                    </p>
                  )}
                </div>
                <SeverityBadge severity={disease.severity} />
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}

export default PlantProfile;
