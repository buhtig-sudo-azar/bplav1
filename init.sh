#!/usr/bin/env bash
set -euo pipefail

echo "=== Инициализация проекта drone-website-generator (сайт-витрина услуг по БПЛА) ==="

if [ -f "package.json" ]; then
  echo "Ошибка: package.json уже существует. Запусти скрипт в ПУСТОМ репозитории."
  exit 1
fi

# Базовые директории
mkdir -p admin-panel/src
mkdir -p site-template/src
mkdir -p build-script
mkdir -p data

################################
# .gitignore
################################
cat > .gitignore << 'EOF'
node_modules
dist
.vite
.DS_Store
.env
*.log
EOF

################################
# package.json (root)
################################
cat > package.json << 'EOF'
{
  "name": "drone-website-generator",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "generate": "node build-script/generate.js",
    "deploy": "gh-pages -d dist"
  },
  "dependencies": {},
  "devDependencies": {
    "gh-pages": "^6.1.1"
  }
}
EOF

################################
# README
################################
cat > README.md << 'EOF'
# Автоматизированный сайт-витрина услуг по БПЛА

Этот репозиторий создаётся скриптом init.sh и содержит:

- `admin-panel/` — админ-панель для редактирования контента (услуги, портфолио, отзывы).
- `site-template/` — публичный сайт-витрина на Vue 3 + Vite.
- `data/` — JSON-файлы с данными.
- `build-script/generate.js` — генератор, который склеивает данные и билдит сайт в `dist/`.

Базовый сценарий:

1. `npm install`
2. `cd site-template && npm install && cd ..`
3. `cd admin-panel && npm install && cd ..`
4. `npm run generate`
5. `npm run deploy` (после настройки GitHub Pages)
EOF

################################
# admin-panel: минимальная заготовка Vue 3 + Vite
################################
cat > admin-panel/package.json << 'EOF'
{
  "name": "admin-panel",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "vue": "^3.4.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.0",
    "vite": "^5.0.0"
  }
}
EOF

cat > admin-panel/vite.config.mts << 'EOF'
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5174
  }
});
EOF

cat > admin-panel/index.html << 'EOF'
<!DOCTYPE html>
<html lang="ru">
  <head>
    <meta charset="UTF-8" />
    <title>Админ-панель: сайт БПЛА</title>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.ts"></script>
  </body>
</html>
EOF

cat > admin-panel/src/main.ts << 'EOF'
import { createApp } from "vue";
import App from "./App.vue";

createApp(App).mount("#app");
EOF

cat > admin-panel/src/App.vue << 'EOF'
<template>
  <div style="max-width: 960px; margin: 0 auto; padding: 24px; font-family: system-ui, sans-serif;">
    <h1>Админ-панель: контент для сайта услуг по БПЛА</h1>
    <p>
      Здесь позже будет полноценный интерфейс для управления услугами, портфолио и отзывами.
      Сейчас JSON-файлы можно редактировать вручную в папке <code>data/</code>.
    </p>

    <h2>Структура данных</h2>
    <ul>
      <li><code>data/services.json</code> — список услуг.</li>
      <li><code>data/portfolio.json</code> — примеры выполненных проектов.</li>
      <li><code>data/reviews.json</code> — отзывы клиентов.</li>
    </ul>

    <p>
      После изменения данных запусти в корне репозитория:
      <code>npm run generate</code> — сайт пересоберётся в папку <code>dist/</code>.
    </p>
  </div>
</template>

<script setup lang="ts">
</script>
EOF

################################
# site-template: Vue 3 + Vite
################################
cat > site-template/package.json << 'EOF'
{
  "name": "site-template",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "vue": "^3.4.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.0",
    "vite": "^5.0.0"
  }
}
EOF

cat > site-template/vite.config.mts << 'EOF'
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
  plugins: [vue()],
  build: {
    outDir: "../dist"
  }
});
EOF

cat > site-template/index.html << 'EOF'
<!DOCTYPE html>
<html lang="ru">
  <head>
    <meta charset="UTF-8" />
    <title>Услуги по БПЛА — Аэросъёмка, Мониторинг, Инспекции</title>
    <meta name="description" content="Профессиональные услуги по аэросъёмке и мониторингу с использованием БПЛА." />
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.ts"></script>
  </body>
</html>
EOF

cat > site-template/src/main.ts << 'EOF'
import { createApp } from "vue";
import App from "./App.vue";

createApp(App).mount("#app");
EOF

cat > site-template/src/App.vue << 'EOF'
<script setup lang="ts">
import content from "./generated-content.json";
</script>

<template>
  <div style="font-family: system-ui, sans-serif; color: #111;">
    <header style="padding: 24px; background: #020617; color: #f9fafb;">
      <h1 style="margin: 0;">Услуги по БПЛА</h1>
      <p style="margin-top: 8px; max-width: 640px;">
        Профессиональная аэросъёмка, мониторинг строек, инспекция линий и объектов с использованием квадрокоптеров.
      </p>
    </header>

    <main style="max-width: 1000px; margin: 0 auto; padding: 24px;">
      <section v-if="content.services?.length">
        <h2>Услуги</h2>
        <div
          v-for="service in content.services"
          :key="service.id"
          style="border: 1px solid #e5e7eb; border-radius: 8px; padding: 16px; margin-bottom: 12px;"
        >
          <h3 style="margin-top: 0;">{{ service.title }}</h3>
          <p>{{ service.description }}</p>
          <p v-if="service.price" style="font-weight: 600; margin-top: 8px;">
            От {{ service.price }}
          </p>
        </div>
      </section>

      <section v-if="content.portfolio?.length" style="margin-top: 32px;">
        <h2>Примеры работ</h2>
        <div
          v-for="item in content.portfolio"
          :key="item.id"
          style="border-radius: 8px; padding: 16px; margin-bottom: 12px; background: #f9fafb;"
        >
          <h3 style="margin-top: 0;">{{ item.title }}</h3>
          <p>{{ item.description }}</p>
          <p v-if="item.location" style="font-size: 14px; color: #6b7280;">
            Локация: {{ item.location }}
          </p>
        </div>
      </section>

      <section v-if="content.reviews?.length" style="margin-top: 32px;">
        <h2>Отзывы клиентов</h2>
        <div
          v-for="review in content.reviews"
          :key="review.id"
          style="border-left: 4px solid #3b82f6; padding: 12px 16px; margin-bottom: 12px; background: #eff6ff;"
        >
          <p style="margin: 0 0 4px 0;"><strong>{{ review.author }}</strong></p>
          <p style="margin: 0 0 4px 0;">{{ review.text }}</p>
          <p v-if="review.rating" style="margin: 0; font-size: 14px; color: #1d4ed8;">
            Оценка: {{ review.rating }} / 5
          </p>
        </div>
      </section>
    </main>

    <footer style="padding: 16px; text-align: center; font-size: 14px; color: #6b7280; border-top: 1px solid #e5e7eb;">
      © {{ new Date().getFullYear() }} Услуги по БПЛА. Все права защищены.
    </footer>
  </div>
</template>
EOF

################################
# build-script/generate.js
################################
cat > build-script/generate.js << 'EOF'
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
EOF

chmod +x build-script/generate.js

################################
# Стартовые данные JSON
################################
cat > data/services.json << 'EOF'
[
  {
    "id": 1,
    "title": "Аэросъёмка объектов и территорий",
    "description": "Высококачественная фото- и видеосъёмка строек, промышленных объектов и городской инфраструктуры с квадрокоптера.",
    "price": "от 10 000 ₽ за вылет"
  },
  {
    "id": 2,
    "title": "Мониторинг строительства",
    "description": "Регулярная съёмка строительных площадок для контроля динамики и подготовки отчётности.",
    "price": "индивидуальный расчёт"
  },
  {
    "id": 3,
    "title": "Инспекция линий и инженерных сооружений",
    "description": "Осмотр линий электропередачи, трубопроводов и фасадов зданий без остановки работы объекта.",
    "price": "по запросу"
  }
]
EOF

cat > data/portfolio.json << 'EOF'
[
  {
    "id": 1,
    "title": "Мониторинг строительства жилого комплекса",
    "description": "Еженедельная аэросъёмка хода строительства, подготовка видеороликов и отчётных фотографий.",
    "location": "Кировская область"
  },
  {
    "id": 2,
    "title": "Инспекция ЛЭП в труднодоступной местности",
    "description": "Облет опор и проводов с фото- и видеофиксацией дефектов.",
    "location": "Северный регион"
  }
]
EOF

cat > data/reviews.json << 'EOF'
[
  {
    "id": 1,
    "author": "Иван Петров",
    "rating": 5,
    "text": "Быстро организовали аэросъёмку стройплощадки, помогли с монтажом ролика для инвесторов."
  },
  {
    "id": 2,
    "author": "Анна Смирнова",
    "rating": 5,
    "text": "Детальная съёмка кровли и фасада, помогла оперативно найти проблемные участки."
  }
]
EOF

echo
echo "=== Готово. Дальнейшие шаги: ==="
echo "1) npm install"
echo "2) cd site-template && npm install && cd .."
echo "3) cd admin-panel && npm install && cd .."
echo "4) npm run generate   # соберёт сайт в dist/"
echo "5) npm run deploy     # после настройки GitHub Pages"
EOF

После перезагрузки:

1. В пустом репо создай файл `init.sh`, вставь туда это содержимое.  
2. Выдай права: `chmod +x init.sh`.  
3. Запусти: `./init.sh`.  

С этого момента структура и контент снова будут на месте, и дальше уже ставишь зависимости и гоняешь `npm run generate`. [cite:8][cite:9]