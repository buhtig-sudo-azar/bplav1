<script setup lang="ts">
import { ref, onMounted } from "vue";

type Service = {
  id: number;
  title: string;
  description: string;
  price?: string;
};

const apiBase = "http://localhost:4000";

const services = ref<Service[]>([]);
const isLoading = ref(false);
const isSaving = ref(false);
const error = ref<string | null>(null);

const editingService = ref<Service | null>(null);
const formTitle = ref("");
const formDescription = ref("");
const formPrice = ref("");

function resetForm() {
  editingService.value = null;
  formTitle.value = "";
  formDescription.value = "";
  formPrice.value = "";
}

async function loadServices() {
  try {
    isLoading.value = true;
    error.value = null;
    const res = await fetch(`${apiBase}/api/services`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = (await res.json()) as Service[];
    services.value = data;
  } catch (e: any) {
    console.error(e);
    error.value = "Не удалось загрузить услуги.";
  } finally {
    isLoading.value = false;
  }
}

function startAdd() {
  editingService.value = null;
  formTitle.value = "";
  formDescription.value = "";
  formPrice.value = "";
}

function startEdit(service: Service) {
  editingService.value = { ...service };
  formTitle.value = service.title;
  formDescription.value = service.description;
  formPrice.value = service.price || "";
}

function deleteService(service: Service) {
  if (!confirm(`Удалить услугу "${service.title}"?`)) return;
  services.value = services.value.filter((s) => s.id !== service.id);
}

async function saveService() {
  if (!formTitle.value.trim() || !formDescription.value.trim()) {
    alert("Заполните название и описание.");
    return;
  }

  let updated = [...services.value];
  if (editingService.value) {
    updated = updated.map((s) =>
      s.id === editingService.value!.id
        ? { ...s, title: formTitle.value, description: formDescription.value, price: formPrice.value || undefined }
        : s
    );
  } else {
    const maxId = updated.reduce((max, s) => (s.id > max ? s.id : max), 0);
    updated.push({
      id: maxId + 1,
      title: formTitle.value,
      description: formDescription.value,
      price: formPrice.value || undefined
    });
  }

  try {
    isSaving.value = true;
    error.value = null;
    const res = await fetch(`${apiBase}/api/services`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(updated)
    });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    services.value = updated;
    resetForm();
  } catch (e: any) {
    console.error(e);
    error.value = "Не удалось сохранить услуги.";
  } finally {
    isSaving.value = false;
  }
}

onMounted(() => {
  loadServices();
});
</script>

<template>
  <div style="max-width: 960px; margin: 0 auto; padding: 24px; font-family: system-ui, sans-serif;">
    <h1>Услуги по БПЛА — админка</h1>
    <p style="max-width: 640px; font-size: 14px; color: #4b5563;">
      Здесь можно управлять списком услуг. Данные читаются и сохраняются в <code>data/services.json</code> через
      локальный API <code>http://localhost:4000/api/services</code>.
      После изменений не забудь в корне выполнить <code>npm run generate</code> и <code>npm run deploy</code>,
      чтобы обновить публичный сайт.
    </p>

    <div v-if="error" style="margin-bottom: 12px; padding: 8px 10px; background: #fee2e2; color: #b91c1c;">
      {{ error }}
    </div>

    <section style="margin-top: 16px;">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
        <h2 style="margin: 0; font-size: 18px;">Список услуг</h2>
        <button
          type="button"
          @click="startAdd"
          style="padding: 6px 10px; border-radius: 6px; border: none; cursor: pointer; background: #22c55e; color: #fff;"
        >
          + Добавить услугу
        </button>
      </div>

      <div v-if="isLoading" style="font-size: 14px; color: #6b7280;">Загрузка...</div>

      <div v-else>
        <div
          v-for="service in services"
          :key="service.id"
          style="border: 1px solid #e5e7eb; border-radius: 8px; padding: 10px 12px; margin-bottom: 8px;"
        >
          <div style="display: flex; justify-content: space-between; gap: 12px;">
            <div>
              <div style="font-weight: 600;">{{ service.title }}</div>
              <div style="font-size: 14px; color: #4b5563;">{{ service.description }}</div>
              <div v-if="service.price" style="font-size: 13px; color: #16a34a; margin-top: 4px;">
                {{ service.price }}
              </div>
            </div>
            <div style="display: flex; flex-direction: column; gap: 4px; min-width: 120px; text-align: right;">
              <button
                type="button"
                @click="startEdit(service)"
                style="padding: 4px 6px; border-radius: 6px; border: 1px solid #d1d5db; background: #f9fafb; cursor: pointer;"
              >
                Редактировать
              </button>
              <button
                type="button"
                @click="deleteService(service)"
                style="padding: 4px 6px; border-radius: 6px; border: 1px solid #fecaca; background: #fee2e2; cursor: pointer;"
              >
                Удалить
              </button>
            </div>
          </div>
        </div>

        <div v-if="!services.length && !isLoading" style="font-size: 14px; color: #6b7280; margin-top: 8px;">
          Пока услуг нет. Добавьте первую услугу.
        </div>
      </div>
    </section>

    <section style="margin-top: 24px;">
      <h2 style="margin-bottom: 8px; font-size: 18px;">
        {{ editingService ? "Редактирование услуги" : "Новая услуга" }}
      </h2>

      <div style="max-width: 520px;">
        <div style="margin-bottom: 8px;">
          <label style="display: block; font-size: 13px; margin-bottom: 4px;">Название</label>
          <input
            v-model="formTitle"
            type="text"
            style="width: 100%; padding: 6px 8px; border-radius: 6px; border: 1px solid #d1d5db;"
          />
        </div>
        <div style="margin-bottom: 8px;">
          <label style="display: block; font-size: 13px; margin-bottom: 4px;">Описание</label>
          <textarea
            v-model="formDescription"
            rows="3"
            style="
              width: 100%;
              padding: 6px 8px;
              border-radius: 6px;
              border: 1px solid #d1d5db;
              resize: vertical;
            "
          ></textarea>
        </div>
        <div style="margin-bottom: 12px;">
          <label style="display: block; font-size: 13px; margin-bottom: 4px;">Цена (необязательно)</label>
          <input
            v-model="formPrice"
            type="text"
            style="width: 100%; padding: 6px 8px; border-radius: 6px; border: 1px solid #d1d5db;"
          />
        </div>

        <div style="display: flex; gap: 8px;">
          <button
            type="button"
            @click="saveService"
            :disabled="isSaving"
            style="
              padding: 6px 10px;
              border-radius: 6px;
              border: none;
              cursor: pointer;
              background: #2563eb;
              color: #fff;
              font-weight: 500;
            "
          >
            {{ isSaving ? "Сохранение..." : "Сохранить" }}
          </button>
          <button
            type="button"
            @click="resetForm"
            style="
              padding: 6px 10px;
              border-radius: 6px;
              border: 1px solid #d1d5db;
              cursor: pointer;
              background: #f9fafb;
            "
          >
            Очистить форму
          </button>
        </div>
      </div>
    </section>
  </div>
</template>