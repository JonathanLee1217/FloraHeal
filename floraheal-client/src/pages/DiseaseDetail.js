import React, { useState, useEffect } from "react";
import { useParams, useNavigate, Link } from "react-router-dom";
import { getDiseaseById } from "../services/api";
import Loading from "../components/Loading";
import SeverityBadge from "../components/SeverityBadge";

function DiseaseDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [disease, setDisease] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      setError(null);
      try {
        const data = await getDiseaseById(id);
        setDisease(data);
      } catch (err) {
        setError("Failed to load disease details. Please try again.");
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id]);

  if (loading) return <div className="container"><Loading message="Loading disease details..." /></div>;
  if (error) return <div className="container"><div className="error-state"><p>{error}</p></div></div>;
  if (!disease) return null;

  // Detail sections to display
  const sections = [
    { title: "🔬 Symptoms", content: disease.symptoms, icon: "" },
    { title: "🌡️ Favorable Conditions", content: disease.favorable_conditions },
    { title: "🔄 Disease Lifecycle", content: disease.lifecycle },
    { title: "🛡️ Prevention & Treatment", content: disease.prevention },
  ].filter((s) => s.content);

  return (
    <div className="disease-detail">
      <div className="container">
        {/* Breadcrumb */}
        <div className="breadcrumb">
          <Link to="/">Home</Link>
          <span>›</span>
          Disease Detail
        </div>

        {/* Back Button */}
        <button className="back-button" onClick={() => navigate(-1)}>
          ← Back
        </button>

        {/* Disease Header */}
        <div className="disease-header">
          <div style={{ display: "flex", alignItems: "center", gap: "12px", marginBottom: "12px" }}>
            {disease.disease_type && (
              <span className="disease-type-badge">{disease.disease_type}</span>
            )}
            <SeverityBadge severity={disease.severity} />
          </div>
          <h1>{disease.name}</h1>
          <p className="agent">
            Caused by: {disease.causal_agent || "Unknown"}
          </p>
          {disease.description && (
            <p className="overview">{disease.description}</p>
          )}
        </div>

        {/* Detail Sections */}
        {sections.map((section, index) => (
          <div key={index} className="detail-section">
            <h2>{section.title}</h2>
            <p>{section.content}</p>
          </div>
        ))}

        {/* Affected Plants */}
        {disease.affected_plants && disease.affected_plants.length > 0 && (
          <div className="affected-plants">
            <h2>
              Affected Plants ({disease.affected_plants.length})
            </h2>
            {disease.affected_plants.map((plant) => (
              <div
                key={plant.id}
                className="affected-plant-item"
                onClick={() => navigate(`/plants/${plant.id}`)}
              >
                <div>
                  <span className="plant-name">{plant.common_name}</span>
                  <span className="plant-scientific">{plant.scientific_name}</span>
                </div>
                <span className="arrow">→</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

export default DiseaseDetail;
