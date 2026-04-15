#!/usr/bin/env node

const express = require("express");
const fs = require("fs");
const path = require("path");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 4000;

const dataDir = path.join(process.cwd(), "data");
const servicesFile = path.join(dataDir, "services.json");

app.use(cors());
app.use(express.json());

function readServices() {
  if (!fs.existsSync(servicesFile)) return [];
  const raw = fs.readFileSync(servicesFile, "utf-8");
  try {
    return JSON.parse(raw);
  } catch (e) {
    console.error("Ошибка чтения services.json:", e);
    return [];
  }
}

function writeServices(services) {
  fs.writeFileSync(servicesFile, JSON.stringify(services, null, 2), "utf-8");
}

app.get("/api/services", (req, res) => {
  const services = readServices();
  res.json(services);
});

app.post("/api/services", (req, res) => {
  const services = req.body;
  if (!Array.isArray(services)) {
    return res.status(400).json({ error: "Expected array of services" });
  }
  writeServices(services);
  res.json({ ok: true });
});

app.listen(PORT, () => {
  console.log(`Admin API listening on http://localhost:${PORT}`);
});