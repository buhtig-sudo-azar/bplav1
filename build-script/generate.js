#!/usr/bin/env node

const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

function readJson(filePath) {
  if (!fs.existsSync(filePath)) {
    console.warn(`Файл ${filePath} не найден, возвращаю пустой массив.`);
    return [];
  }
  const raw = fs.readFileSync(filePath, "utf-8");
  try {
    return JSON.parse(raw);
  } catch (e) {
    console.error(`Не удалось распарсить JSON из ${filePath}:`, e);
    process.exit(1);
  }
}

function main() {
  const rootDir = process.cwd();
  const dataDir = path.join(rootDir, "data");
  const siteTemplateDir = path.join(rootDir, "site-template");
  const outputDataFile = path.join(siteTemplateDir, "src", "generated-content.json");

  console.log("Чтение JSON-данных из data/ ...");

  const services = readJson(path.join(dataDir, "services.json"));
  const portfolio = readJson(path.join(dataDir, "portfolio.json"));
  const reviews = readJson(path.join(dataDir, "reviews.json"));

  const content = { services, portfolio, reviews };

  console.log("Запись объединённых данных в site-template/src/generated-content.json ...");
  fs.writeFileSync(outputDataFile, JSON.stringify(content, null, 2), "utf-8");

  console.log("Запуск сборки site-template (npm run build) ...");
  execSync("npm run build", {
    cwd: siteTemplateDir,
    stdio: "inherit"
  });

  console.log("Готово. Итоговый статический сайт лежит в папке dist/ в корне репозитория.");
}

main();
