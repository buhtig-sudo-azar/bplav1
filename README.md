# Автоматизированный сайт-витрина услуг по БПЛА
https://buhtig-sudo-azar.github.io/bplav1/
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
