# FloraHeal API

Backend API for the FloraHeal Plant Disease Identification Platform.

## Tech Stack

- **Runtime:** Node.js
- **Framework:** Express
- **Database:** PostgreSQL (with pg_trgm for fuzzy search)

## Project Structure

```
floraheal-api/
├── src/
│   ├── controllers/
│   │   ├── plantsController.js    # Plant search, profile, diseases
│   │   └── diseasesController.js  # Disease detail
│   ├── db/
│   │   └── pool.js                # PostgreSQL connection pool
│   ├── middleware/
│   │   └── errorHandler.js        # 404 and error handling
│   ├── routes/
│   │   ├── plants.js              # /api/plants routes
│   │   └── diseases.js            # /api/diseases routes
│   └── server.js                  # App entry point
├── .env.example                   # Environment config template
├── .gitignore
├── package.json
└── README.md
```

## Setup Instructions

### 1. Install Dependencies

```bash
cd floraheal-api
npm install
```

### 2. Configure Environment

```bash
cp .env.example .env
```

Create `.env` file and update `DB_PASSWORD` with your PostgreSQL password:

```
PORT=5000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=floraheal
DB_USER=postgres
DB_PASSWORD=your_actual_password
```

### 3. Run the Database Schema

Make sure you have already created the `floraheal` database and run the
`floraheal_schema.sql` file (see the Product Design Document for instructions).

### 4. Start the Server

Development mode (auto-restarts on file changes):
```bash
npm run dev
```

Production mode:
```bash
npm start
```

You should see:
```
✅ Connected to PostgreSQL
🌿 FloraHeal API is running!
   Local: http://localhost:5000
```

## API Endpoints

### Plants

| Method | Endpoint                   | Description                          |
|--------|----------------------------|--------------------------------------|
| GET    | `/api/plants?search=tomato`| Fuzzy search plants by name          |
| GET    | `/api/plants/1`            | Get plant profile with extended info |
| GET    | `/api/plants/1/diseases`   | Get all diseases for a plant         |

### Diseases

| Method | Endpoint            | Description                                    |
|--------|---------------------|------------------------------------------------|
| GET    | `/api/diseases/1`   | Get full disease detail + affected plants list |

### Health

| Method | Endpoint        | Description          |
|--------|-----------------|----------------------|
| GET    | `/api/health`   | API health check     |

## Testing the API

Once the server is running, test with your browser or curl:

```bash
# Health check
curl http://localhost:5000/api/health

# Search for a plant (fuzzy)
curl http://localhost:5000/api/plants?search=tomato

# Try a misspelling
curl http://localhost:5000/api/plants?search=tomatoe

# Get plant profile
curl http://localhost:5000/api/plants/1

# Get diseases for a plant
curl http://localhost:5000/api/plants/1/diseases

# Get disease detail
curl http://localhost:5000/api/diseases/1
```
