<script setup lang="ts">
import { ref, computed } from "vue";
import content from "./generated-content.json";

type Service = {
  id: number;
  title: string;
  description: string;
  price?: string;
};

type PortfolioItem = {
  id: number;
  title: string;
  description: string;
  location?: string;
};

type Review = {
  id: number;
  author: string;
  text: string;
  rating?: number;
};

const services = ref<Service[]>(content.services || []);
const portfolio = ref<PortfolioItem[]>(content.portfolio || []);
const reviews = ref<Review[]>(content.reviews || []);

const expandedPortfolioIds = ref<number[]>([]);

const isModalOpen = ref(false);
const selectedService = ref<Service | null>(null);
const formName = ref("");
const formPhone = ref("");
const formComment = ref("");
const formSubmitted = ref(false);

function scrollToAnchor(id: string) {
  const el = document.getElementById(id);
  if (el) {
    el.scrollIntoView({ behavior: "smooth", block: "start" });
  }
}

function togglePortfolioItem(id: number) {
  if (expandedPortfolioIds.value.includes(id)) {
    expandedPortfolioIds.value = expandedPortfolioIds.value.filter((x) => x !== id);
  } else {
    expandedPortfolioIds.value.push(id);
  }
}

function openOrderModal(service: Service) {
  selectedService.value = service;
  isModalOpen.value = true;
  formSubmitted.value = false;
  formName.value = "";
  formPhone.value = "";
  formComment.value = "";
}

function closeOrderModal() {
  isModalOpen.value = false;
}

function submitOrder() {
  if (!formName.value.trim() || !formPhone.value.trim()) {
    alert("Заполните имя и телефон.");
    return;
  }

  // Здесь пока просто имитация отправки
  console.log("Заявка:", {
    service: selectedService.value,
    name: formName.value,
    phone: formPhone.value,
    comment: formComment.value
  });

  formSubmitted.value = true;
}

const currentYear = computed(() => new Date().getFullYear());
</script>

<template>
  <div style="font-family: system-ui, -apple-system, BlinkMacSystemFont, sans-serif; color: #0f172a; background: #0b1120;">
    <!-- Шапка -->
    <header
      style="
        padding: 24px;
        background: radial-gradient(circle at top left, #0ea5e9, #020617 60%);
        color: #f9fafb;
        position: sticky;
        top: 0;
        z-index: 10;
        backdrop-filter: blur(10px);
      "
    >
      <div style="max-width: 1120px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center;">
        <div>
          <h1 style="margin: 0; font-size: 24px;">Услуги по БПЛА</h1>
          <p style="margin-top: 6px; max-width: 520px; font-size: 14px; color: #e2e8f0;">
            Аэросъёмка, мониторинг строительства, инспекции объектов. Профессиональный парк дронов и сертифицированные пилоты.
          </p>
        </div>
        <nav style="display: flex; gap: 12px; font-size: 14px;">
          <button
            type="button"
            @click="scrollToAnchor('services')"
            style="background: transparent; border: none; color: #e2e8f0; cursor: pointer;"
          >
            Услуги
          </button>
          <button
            type="button"
            @click="scrollToAnchor('portfolio')"
            style="background: transparent; border: none; color: #e2e8f0; cursor: pointer;"
          >
            Примеры работ
          </button>
          <button
            type="button"
            @click="scrollToAnchor('reviews')"
            style="background: transparent; border: none; color: #e2e8f0; cursor: pointer;"
          >
            Отзывы
          </button>
        </nav>
      </div>
    </header>

    <!-- Контент -->
    <main style="max-width: 1120px; margin: 0 auto; padding: 24px; color: #e5e7eb;">
      <!-- Услуги -->
      <section v-if="services.length" :id="'services'" style="margin-bottom: 40px;">
        <h2 style="font-size: 22px; margin-bottom: 16px;">Услуги</h2>
        <div
          v-for="service in services"
          :key="service.id"
          style="
            border-radius: 12px;
            padding: 16px 18px;
            margin-bottom: 12px;
            background: linear-gradient(135deg, #0f172a, #020617);
            border: 1px solid #1e293b;
            box-shadow: 0 10px 25px rgba(15, 23, 42, 0.7);
          "
        >
          <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 16px;">
            <div>
              <h3 style="margin: 0 0 6px 0; font-size: 18px; color: #e5e7eb;">{{ service.title }}</h3>
              <p style="margin: 0 0 8px 0; font-size: 14px; color: #cbd5f5;">
                {{ service.description }}
              </p>
              <p v-if="service.price" style="margin: 0; font-size: 14px; color: #38bdf8; font-weight: 500;">
                {{ service.price }}
              </p>
            </div>
            <div style="min-width: 150px; text-align: right;">
              <button
                type="button"
                @click="openOrderModal(service)"
                style="
                  padding: 8px 14px;
                  border-radius: 999px;
                  border: none;
                  cursor: pointer;
                  background: linear-gradient(135deg, #22c55e, #16a34a);
                  color: #022c22;
                  font-weight: 600;
                  font-size: 14px;
                  box-shadow: 0 6px 16px rgba(34, 197, 94, 0.4);
                "
              >
                Оставить заявку
              </button>
            </div>
          </div>
        </div>
      </section>

      <!-- Портфолио -->
      <section v-if="portfolio.length" :id="'portfolio'" style="margin-bottom: 40px;">
        <h2 style="font-size: 22px; margin-bottom: 16px;">Примеры работ</h2>
        <div
          v-for="item in portfolio"
          :key="item.id"
          style="
            border-radius: 12px;
            padding: 14px 16px;
            margin-bottom: 10px;
            background: #0b1120;
            border: 1px solid #1e293b;
            cursor: pointer;
          "
          @click="togglePortfolioItem(item.id)"
        >
          <div style="display: flex; justify-content: space-between; align-items: center;">
            <h3 style="margin: 0; font-size: 16px; color: #e5e7eb;">
              {{ item.title }}
            </h3>
            <span style="font-size: 18px; color: #64748b;">
              {{ expandedPortfolioIds.includes(item.id) ? "−" : "+" }}
            </span>
          </div>
          <div v-if="expandedPortfolioIds.includes(item.id)" style="margin-top: 8px;">
            <p style="margin: 0 0 4px 0; font-size: 14px; color: #cbd5f5;">
              {{ item.description }}
            </p>
            <p v-if="item.location" style="margin: 0; font-size: 13px; color: #94a3b8;">
              Локация: {{ item.location }}
            </p>
          </div>
        </div>
      </section>

      <!-- Отзывы -->
      <section v-if="reviews.length" :id="'reviews'" style="margin-bottom: 40px;">
        <h2 style="font-size: 22px; margin-bottom: 16px;">Отзывы клиентов</h2>
        <div
          v-for="review in reviews"
          :key="review.id"
          style="
            border-radius: 12px;
            padding: 12px 16px;
            margin-bottom: 10px;
            border-left: 4px solid #38bdf8;
            background: linear-gradient(135deg, #020617, #0f172a);
          "
        >
          <p style="margin: 0 0 4px 0; font-weight: 600; color: #e5e7eb;">
            {{ review.author }}
          </p>
          <p style="margin: 0 0 4px 0; font-size: 14px; color: #e2e8f0;">
            {{ review.text }}
          </p>
          <p v-if="review.rating" style="margin: 0; font-size: 13px; color: #38bdf8;">
            Оценка: {{ review.rating }} / 5
          </p>
        </div>
      </section>
    </main>

    <!-- Подвал -->
    <footer
      style="
        padding: 16px;
        text-align: center;
        font-size: 13px;
        color: #94a3b8;
        border-top: 1px solid #1e293b;
        background: #020617;
      "
    >
      © {{ currentYear }} Услуги по БПЛА. Все права защищены.
    </footer>

    <!-- Модалка заявки -->
    <div
      v-if="isModalOpen"
      style="
        position: fixed;
        inset: 0;
        background: rgba(15, 23, 42, 0.8);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 50;
      "
      @click.self="closeOrderModal"
    >
      <div
        style="
          width: 100%;
          max-width: 420px;
          background: #020617;
          border-radius: 16px;
          padding: 20px 22px;
          box-shadow: 0 24px 60px rgba(15, 23, 42, 0.9);
          border: 1px solid #1e293b;
          color: #e5e7eb;
        "
      >
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
          <h3 style="margin: 0; font-size: 18px;">Заявка на услугу</h3>
          <button
            type="button"
            @click="closeOrderModal"
            style="background: transparent; border: none; color: #64748b; cursor: pointer; font-size: 18px;"
          >
                        ✕
          </button>
        </div>

        <p v-if="selectedService" style="margin: 0 0 10px 0; font-size: 14px; color: #cbd5f5;">
          Услуга: <strong>{{ selectedService.title }}</strong>
        </p>

        <div v-if="!formSubmitted">
          <div style="margin-bottom: 10px;">
            <label style="display: block; font-size: 13px; margin-bottom: 4px;">Имя</label>
            <input
              v-model="formName"
              type="text"
              style="
                width: 100%;
                padding: 8px 10px;
                border-radius: 8px;
                border: 1px solid #1e293b;
                background: #020617;
                color: #e5e7eb;
                font-size: 14px;
              "
            />
          </div>
          <div style="margin-bottom: 10px;">
            <label style="display: block; font-size: 13px; margin-bottom: 4px;">Телефон</label>
            <input
              v-model="formPhone"
              type="text"
              style="
                width: 100%;
                padding: 8px 10px;
                border-radius: 8px;
                border: 1px solid #1e293b;
                background: #020617;
                color: #e5e7eb;
                font-size: 14px;
              "
            />
          </div>
          <div style="margin-bottom: 12px;">
            <label style="display: block; font-size: 13px; margin-bottom: 4px;">Комментарий (необязательно)</label>
            <textarea
              v-model="formComment"
              rows="3"
              style="
                width: 100%;
                padding: 8px 10px;
                border-radius: 8px;
                border: 1px solid #1e293b;
                background: #020617;
                color: #e5e7eb;
                font-size: 14px;
                resize: vertical;
              "
            ></textarea>
          </div>

          <button
            type="button"
            @click="submitOrder"
            style="
              width: 100%;
              padding: 9px 12px;
              border-radius: 999px;
              border: none;
              cursor: pointer;
              background: linear-gradient(135deg, #22c55e, #16a34a);
              color: #022c22;
              font-weight: 600;
              font-size: 14px;
              box-shadow: 0 10px 25px rgba(34, 197, 94, 0.5);
            "
          >
            Отправить заявку (демо)
          </button>
        </div>

        <div v-else style="text-align: center; padding: 14px 0; font-size: 14px; color: #bbf7d0;">
          Заявка отправлена (демо). В реальном проекте здесь будет отправка на почту/в Telegram.
        </div>
      </div>
    </div>
  </div>
</template>