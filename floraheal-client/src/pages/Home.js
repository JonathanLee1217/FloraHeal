import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { searchPlants } from "../services/api";
import Loading from "../components/Loading";

function Home() {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState([]);
  const [hasSearched, setHasSearched] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  const handleSearch = async (e) => {
    e.preventDefault();
    if (!query.trim()) return;

    setLoading(true);
    setError(null);
    setHasSearched(true);

    try {
      const data = await searchPlants(query.trim());
      setResults(data);
    } catch (err) {
      setError("Failed to search plants. Make sure the API server is running.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      {/* Hero Section */}
      <section className="hero">
        <div className="container">
          <p className="hero-tagline">Plant Disease Identification</p>
          <h1>
            Identify & Understand <span>Plant Diseases</span>
          </h1>
          <p>
            Search for any plant to discover the diseases it may face,
            understand their symptoms, and learn how to protect your garden.
          </p>

          {/* Search Bar */}
          <div className="search-container">
            <form className="search-bar" onSubmit={handleSearch}>
              <span className="search-icon">🔍</span>
              <input
                type="text"
                placeholder="Search by plant name (e.g., Tomato, Rose, Basil...)"
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                autoFocus
              />
              <button type="submit">Search</button>
            </form>
          </div>
        </div>
      </section>

      {/* Results Section */}
      {hasSearched && (
        <section className="results-section">
          <div className="container">
            {loading && <Loading message="Searching plants..." />}

            {error && (
              <div className="error-state">
                <p>{error}</p>
              </div>
            )}

            {!loading && !error && results.length > 0 && (
              <>
                <div className="results-header">
                  <h2>Search Results</h2>
                  <p>
                    Found {results.length} plant{results.length !== 1 ? "s" : ""}{" "}
                    matching "{query}"
                  </p>
                </div>
                <div className="results-grid">
                  {results.map((plant) => (
                    <div
                      key={plant.id}
                      className="plant-card"
                      onClick={() => navigate(`/plants/${plant.id}`)}
                    >
                      {plant.plant_type && (
                        <span className="plant-card-type">{plant.plant_type}</span>
                      )}
                      <h3>{plant.common_name}</h3>
                      <p className="scientific-name">{plant.scientific_name}</p>
                      {plant.family && (
                        <p className="family-tag">
                          <strong>Family:</strong> {plant.family}
                        </p>
                      )}
                    </div>
                  ))}
                </div>
              </>
            )}

            {!loading && !error && results.length === 0 && (
              <div className="empty-state">
                <div className="empty-icon">🌱</div>
                <h3>No plants found</h3>
                <p>Try a different search term or check the spelling.</p>
              </div>
            )}
          </div>
        </section>
      )}
    </>
  );
}

export default Home;
