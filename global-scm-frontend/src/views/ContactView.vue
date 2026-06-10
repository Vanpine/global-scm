<script setup>
import { ref, reactive, onMounted, nextTick } from 'vue'
import { getPageSections } from '@/api/page'
import { submitContact } from '@/api/contact'
import { useScrollReveal } from '@/composables/useScrollReveal'
import { useI18n } from 'vue-i18n'
import ContactForm from '@/components/contact/ContactForm.vue'

const { t } = useI18n()

const sections = ref([])
const heroSection = ref(null)
const officesSection = ref(null)

const form = reactive({
  name: '',
  company: '',
  email: '',
  phone: '',
  role: '',
  message: ''
})

const submitting = ref(false)
const toastVisible = ref(false)
const toastMsg = ref('')
let toastTimer = null

onMounted(async () => {
  const data = await getPageSections('contact')
  sections.value = data || []
  heroSection.value = sections.value.find(s => s.section === 'hero')
  officesSection.value = sections.value.find(s => s.section === 'offices')
  await nextTick()
  refreshReveal()
})

const { refresh: refreshReveal } = useScrollReveal()

async function handleSubmit() {
  submitting.value = true
  try {
    await submitContact({ ...form })
    // 清空表单
    form.name = ''
    form.company = ''
    form.email = ''
    form.phone = ''
    form.role = ''
    form.message = ''
    // 显示全局 toast
    toastMsg.value = t('contact.toastSuccess')
    toastVisible.value = true
    clearTimeout(toastTimer)
    toastTimer = setTimeout(() => { toastVisible.value = false }, 3000)
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <!-- ===== 页面标题 (page-hero) ===== -->
  <section class="page-hero">
    <div class="container">
      <div class="eyebrow">{{ t('contact.pageEyebrow') }}</div>
      <h1>{{ t('contact.pageTitle') }}<span class="gradient-text">{{ t('contact.pageTitleHighlight') }}</span></h1>
      <p>{{ t('contact.pageDesc') }}</p>
    </div>
  </section>

  <!-- ===== 表单 + 联系信息 ===== -->
  <section class="section-sm">
    <div class="container">
      <div class="contact-grid">
        <!-- 左侧表单 -->
        <ContactForm
          :form="form"
          :submitting="submitting"
          @submit="handleSubmit"
          style="height:100%;"
        />

        <!-- 右侧联系信息 -->
        <aside class="reveal" style="height:100%;">
          <div class="contact-info-card">
            <p style="font-size:14px;color:var(--text-secondary);margin-bottom:16px;">{{ t('contact.brandInfo') }}</p>

            <h3>
              <svg class="icon-svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-4px;margin-right:6px;color:#0071e3"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
              {{ t('contact.globalHQ') }}
            </h3>

            <div class="office">
              <span class="flag">🇬🇧</span>
              <div>
                <div class="city">{{ t('contact.officeUk.city') }}</div>
                <div class="role">{{ t('contact.officeUk.role') }}</div>
                <div class="addr">{{ t('contact.officeUk.addr') }}</div>
              </div>
            </div>

            <div class="office">
              <span class="flag">🇸🇬</span>
              <div>
                <div class="city">{{ t('contact.officeSg.city') }}</div>
                <div class="role">{{ t('contact.officeSg.role') }}</div>
                <div class="addr">{{ t('contact.officeSg.addr') }}</div>
              </div>
            </div>

            <div class="office">
              <span class="flag">🇭🇰</span>
              <div>
                <div class="city">{{ t('contact.officeHk.city') }}</div>
                <div class="role">{{ t('contact.officeHk.role') }}</div>
                <div class="addr">{{ t('contact.officeHk.addr') }}</div>
              </div>
            </div>

            <div class="office">
              <span class="flag">🇲🇾</span>
              <div>
                <div class="city">{{ t('contact.officeMy.city') }}</div>
                <div class="role">{{ t('contact.officeMy.role') }}</div>
                <div class="addr">{{ t('contact.officeMy.addr') }}</div>
              </div>
            </div>

            <div class="contact-meta">
              <div>
                <svg class="icon-svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-2px;margin-right:5px"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="M22 4l-10 8L2 4"/></svg>
                {{ t('contact.contactViaForm') }}
              </div>
              <div>
                <svg class="icon-svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-2px;margin-right:5px"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                {{ t('contact.workHours') }}
              </div>
            </div>
          </div>
        </aside>
      </div>
    </div>
  </section>

  <!-- ===== 信任背书 ===== -->
  <section class="section-sm bg-gray">
    <div class="container">
      <div class="stats-grid">
        <div class="stat-item reveal">
          <div class="stat-num">24h</div>
          <div class="stat-label">{{ t('contact.responseTime') }}</div>
        </div>
        <div class="stat-item reveal">
          <div class="stat-num">4</div>
          <div class="stat-label">{{ t('contact.globalOffices') }}</div>
        </div>
        <div class="stat-item reveal">
          <div class="stat-num">10</div>
          <div class="stat-label">{{ t('contact.modules') }}</div>
        </div>
        <div class="stat-item reveal">
          <div class="stat-num">90%+</div>
          <div class="stat-label">{{ t('contact.accuracy') }}</div>
        </div>
      </div>
    </div>
  </section>

  <!-- 全局 Toast -->
  <Teleport to="body">
    <Transition name="toast-fade">
      <div v-if="toastVisible" class="global-toast">
        <span class="toast-icon">✓</span>
        {{ toastMsg }}
      </div>
    </Transition>
  </Teleport>
</template>
