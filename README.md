# FloraHeal — Interactive Plant Care and Disease Management Portal

FloraHeal is a web application that allows users to search for plants and discover the diseases they may be susceptible to, including symptoms, causes, severity levels, and prevention tips.

---

## What You Will Need

Before starting, you need to download and install **3 free programs**. If you already have any of them, skip that step.

### 1. Node.js (JavaScript Runtime)

This runs the backend server and the frontend app.

1. Go to **https://nodejs.org**
2. Run the installer and click **Next** through all the steps (keep all defaults)
3. To verify it worked, open **PowerShell** and type:
   ```
   node --version
   ```

### 2. PostgreSQL (Database)

This stores all the plant and disease data.

1. Go to **https://www.postgresql.org/download/windows/**
2. Download the latest version for Windows
3. Run the installer:
   - **IMPORTANT:** When it asks you to set a password, choose something you will remember (e.g., `postgres123`). **You will need it later.**
   - Keep the default port as **5432** or anyone that is not working
   - Uncheck "Launch Stack Builder" at the end — you don't need it

---

## Project Files

Your project folder should look like this:

```
FloraHeal/
├── floraheal-api/            ← Backend server
│   └── (API files)
├── floraheal-client/         ← Frontend website
│   └── (React files)
└── floraheal_schema.sql      ← Database setup file
```

---

## Step-by-Step Setup

### Step 1: Create the Database

1. Open **pgAdmin 4**
2. It will ask for your master password
3. In the left sidebar, click the arrow next to **Servers** to expand it
4. Click the arrow next to **PostgreSQL** to expand it
5. Right-click on **Databases** → click **Create** → click **Database...**
6. In the **Database** field, type: `FloraHeal`
7. Click **Save**

### Step 2: Run the Database Schema

1. In the left sidebar of pgAdmin, click on the new **FloraHeal** database to select it
2. Right-click on **FloraHeal** → click **Query Tool**
3. In the Query Tool toolbar, click the **folder icon** and open **`floraheal_schema.sql`**
4. Click the **play button** to run it
5. You should see `"Query returned successfully"` at the bottom
6. To verify: In the left sidebar, expand **floraheal** → **Schemas** → **public** → **Tables** — you should see 4 tables: `diseases`, `plant_diseases`, `plant_info`, `plants`

### Step 3: Set Up the Backend API

1. Open **PowerShell** and navigate to the API folder (replace the path with your actual folder location):
   ```
   cd "C:\YourFolder\FloraHeal\floraheal-api"
   ```

2. Install the required packages:
   ```
   npm install
   ```

3. Create and name the new file `.env`, and paste the following into the a new file, **replacing `your_password_here` with your actual PostgreSQL password**:
   ```
   PORT=5000
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=floraheal
   DB_USER=postgres
   DB_PASSWORD=your_password_here
   ```

   **Don't forget to save the file.**

4. Go back to PowerShell and start the server:
   ```
   npm start
   ```
   You should see:
   ```
   ✅ Connected to PostgreSQL
   🌿 FloraHeal API is running!
      Local: http://localhost:5000
   ```

   **Keep this PowerShell window open. The server needs to stay running.**

### Step 4: Set Up the Frontend

1. Open a **NEW PowerShell window** and navigate to the client folder:
   ```
   cd "C:\YourFolder\FloraHeal\floraheal-client"
   ```

2. Install the required packages:
   ```
   npm install
   ```
   This may take a few minutes.

3. Start the frontend:
   ```
   npm start
   ```

4. Your default browser should automatically open to **http://localhost:3000**

---

## How to Use FloraHeal

1. **Search for a plant** — Type a plant name in the search bar (e.g., "Tomato", "Rose", "Basil") and click **Search**
2. **View plant profile** — Click on any plant card to see its full details including growing info, soil type, sunlight needs, and a list of diseases
3. **View disease details** — Click on any disease to see its symptoms, causes, lifecycle, prevention tips, and which other plants are affected

**Tip:** The search is fuzzy, so even misspellings work! Try typing "tomatoe" or "roze" and it will still find the right plant.

### Available Plants in the Database

| Plant       | # of Diseases |
|-------------|---------------|
| Tomato      | 6             |
| Rose        | 2             |
| Potato      | 3             |
| Cucumber    | 4             |
| Apple       | 2             |
| Basil       | 2             |
| Strawberry  | 3             |
| Corn        | 2             |
| Grape       | 3             |
| Pepper      | 4             |

---

## Starting the App (After First-Time Setup)

Once everything is set up, here's what you do each time you want to use the app:

### Terminal 1 — Start the API:
```
cd "C:\YourFolder\FloraHeal\floraheal-api"
npm start
```

### Terminal 2 — Start the Frontend:
```
cd "C:\YourFolder\FloraHeal\floraheal-client"
npm start
```

Then open **http://localhost:3000** in your browser.

---

## Troubleshooting

### "node" or "npm" is not recognized
→ Node.js is not installed or PowerShell needs to be restarted. Close PowerShell, restart it, and try again. If it still doesn't work, reinstall Node.js from https://nodejs.org.

### Database connection failed: password authentication failed
→ The password in your `.env` file doesn't match your PostgreSQL password. Open the `.env` file in VS Code and fix the `DB_PASSWORD` line.

### Error: listen EADDRINUSE: address already in use :::5000
→ The API server is already running in another window. Either close that window or find and kill the process:
```
netstat -ano | findstr :5000
taskkill /PID <number_from_above> /F
```

### "react-scripts" is not recognized
→ You forgot to run `npm install` in the client folder. Navigate to the `floraheal-client` folder and run `npm install` first.

### The search returns no results
→ Make sure you ran the `floraheal_schema.sql` file in pgAdmin (Step 2). This loads all the plant and disease data.

### The frontend loads but shows errors
→ Make sure the API is running in a separate PowerShell window (Step 3). The frontend needs the API to fetch data.

---

## Tech Stack

| Layer     | Technology                              |
|-----------|-----------------------------------------|
| Frontend  | React 18, React Router, Axios           |
| Backend   | Node.js, Express                        |
| Database  | PostgreSQL with pg_trgm (fuzzy search)  |

---
