// ============================================================
// API Service - Communicates with FloraHeal Express Backend
// ============================================================
import axios from "axios";

const API_BASE = "http://localhost:5000/api";

const api = axios.create({
  baseURL: API_BASE,
  timeout: 10000,
});

// Search plants by name (fuzzy)
export const searchPlants = async (query) => {
  const response = await api.get("/plants", {
    params: { search: query },
  });
  return response.data;
};

// Get full plant profile with extended info
export const getPlantById = async (id) => {
  const response = await api.get(`/plants/${id}`);
  return response.data;
};

// Get all diseases for a plant
export const getPlantDiseases = async (id) => {
  const response = await api.get(`/plants/${id}/diseases`);
  return response.data;
};

// Get full disease detail
export const getDiseaseById = async (id) => {
  const response = await api.get(`/diseases/${id}`);
  return response.data;
};
