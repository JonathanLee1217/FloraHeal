// ============================================================
// Error Handling Middleware
// ============================================================

// Handle 404 - Route not found
const notFound = (req, res, next) => {
  res.status(404).json({
    error: "Not Found",
    message: `Route ${req.method} ${req.originalUrl} does not exist`,
  });
};

// Handle all other errors
const errorHandler = (err, req, res, next) => {
  console.error("Unhandled error:", err.message);

  res.status(err.status || 500).json({
    error: err.message || "Internal Server Error",
  });
};

module.exports = { notFound, errorHandler };
