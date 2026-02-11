# FloraHeal Client

React frontend for the FloraHeal Plant Disease Identification Platform.

## Tech Stack

- **Framework:** React 18
- **Routing:** React Router v6
- **HTTP Client:** Axios
- **Fonts:** DM Serif Display + DM Sans (Google Fonts)

## Project Structure

```
floraheal-client/
├── public/
│   └── index.html
├── src/
│   ├── components/
│   │   ├── Footer.js
│   │   ├── Loading.js
│   │   ├── Navbar.js
│   │   └── SeverityBadge.js
│   ├── pages/
│   │   ├── DiseaseDetail.js
│   │   ├── Home.js
│   │   └── PlantProfile.js
│   ├── services/
│   │   └── api.js
│   ├── styles/
│   │   └── App.css
│   ├── App.js
│   └── index.js
├── package.json
└── README.md
```

## Setup Instructions

### Prerequisites

- Node.js installed
- FloraHeal API running on http://localhost:5000

### 1. Install Dependencies

```bash
cd floraheal-client
npm install
```

### 2. Start the Development Server

```bash
npm start
```

The app will open at **http://localhost:3000**.

### 3. Make Sure the API is Running

In a separate terminal, the Express API must be running:

```bash
cd floraheal-api
npm run dev
```

## Pages

| Route               | Page           | Description                                  |
|---------------------|----------------|----------------------------------------------|
| `/`                 | Home           | Search bar with fuzzy plant search            |
| `/plants/:id`       | Plant Profile  | Plant info, growing details, disease list     |
| `/diseases/:id`     | Disease Detail | Symptoms, lifecycle, prevention, affected plants |
