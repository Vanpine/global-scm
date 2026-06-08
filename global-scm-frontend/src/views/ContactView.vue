<script setup>
import { ref, reactive, onMounted } from 'vue'
import { getPageSections } from '@/api/page'
import { submitContact } from '@/api/contact'
import ContactForm from '@/components/contact/ContactForm.vue'

const sections = ref([])
const heroSection = ref(null)
const officesSection = ref(null)

const form = reactive({
  name: '',
  company: '',
  email: '',
  phone: '',
  message: ''
})

const submitting = ref(false)
const submitted = ref(false)

onMounted(async () => {
  const data = await getPageSections('contact')
  sections.value = data || []
  heroSection.value = sections.value.find(s => s.section === 'hero')
  officesSection.value = sections.value.find(s => s.section === 'offices')
})

async function handleSubmit() {
  submitting.value = true
  try {
    await submitContact({ ...form })
    submitted.value = true
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <!-- Hero -->
  <section class="hero" style="min-height:60vh; height:60vh;" v-if="heroSection">
    <img
      class="hero-video"
      src="https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=1920&q=85"
      alt=""
      style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none"
    >
    <div class="hero-overlay"></div>
    <div class="hero-content">
      <h1>{{ heroSection.title }}</h1>
      <p class="lead" style="max-width:640px;margin:0 auto 32px;">{{ heroSection.subtitle }}</p>
    </div>
  </section>

  <!-- 联系表单 + 办公室 -->
  <section class="section">
    <div class="container">
      <div class="grid grid-2" style="align-items:start;gap:48px;">
        <ContactForm
          :form="form"
          :submitting="submitting"
          :submitted="submitted"
          @submit="handleSubmit"
        />
        <!-- 全球办公室 -->
        <div v-if="officesSection">
          <h3 style="font-size:1.25rem;margin-bottom:24px;">全球办公室</h3>
          <div v-for="(office, i) in JSON.parse(officesSection.itemsJson || '[]')" :key="i"
               style="padding:20px 0;border-bottom:1px solid var(--border);">
            <div style="font-weight:600;">{{ office.city }} — <span style="color:var(--primary);font-weight:500;">{{ office.role }}</span></div>
            <div style="font-size:13px;color:var(--muted);margin-top:4px;">{{ office.address }} · {{ office.desc }}</div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
