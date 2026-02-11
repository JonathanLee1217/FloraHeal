import React from "react";

function SeverityBadge({ severity }) {
  const level = (severity || "unknown").toLowerCase();

  return (
    <span className={`severity-badge severity-${level}`}>
      {level}
    </span>
  );
}

export default SeverityBadge;
