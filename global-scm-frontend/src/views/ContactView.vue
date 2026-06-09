<script setup>
import { ref, reactive, onMounted, nextTick } from 'vue'
import { getPageSections } from '@/api/page'
import { submitContact } from '@/api/contact'
import { useScrollReveal } from '@/composables/useScrollReveal'
import ContactForm from '@/components/contact/ContactForm.vue'

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
  heroSection = sections.value.find(s => s.section === 'hero')
  officesSection = sections.value.find(s => s.section === 'offices')
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
    toastMsg.value = '提交成功！我们将在 24 小时内回复您'
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
      <div class="eyebrow">CONTACT US</div>
      <h1>和我们聊聊<span class="gradient-text">您的供应链</span></h1>
      <p>填写右侧表单或邮件联系，我们将在 24 小时内回复，并结合您的真实场景给出建议。</p>
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
            <p style="font-size:14px;color:var(--text-secondary);margin-bottom:16px;">Global SCM（全球供应链大平台）是 Clement &amp; Associates（陈玮伦合伙人事务所）旗下品牌。</p>

            <h3>
              <svg class="icon-svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-4px;margin-right:6px;color:#0071e3"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
              C&A 全球总公司
            </h3>

            <div class="office">
              <span class="flag">🇬🇧</span>
              <div>
                <div class="city">英国 · 牛津 / 伦敦</div>
                <div class="role">全球营运总公司 · 牛津大学全球智库中心</div>
                <div class="addr">Clement &amp; Associates International Limited — 128 City Rd, London EC1V 2NX / 60 Banbury Rd, University of Oxford OX2 6PN, UK</div>
              </div>
            </div>

            <div class="office">
              <span class="flag">🇸🇬</span>
              <div>
                <div class="city">新加坡</div>
                <div class="role">全球管理总公司 · 全球合伙人大联盟发展中心</div>
                <div class="addr">Clement &amp; Associates Management Pte. Ltd — 175A Bencoolen Street, #08-06/07 Burlington Square 189650, Singapore</div>
              </div>
            </div>

            <div class="office">
              <span class="flag">🇭🇰</span>
              <div>
                <div class="city">中国 · 香港</div>
                <div class="role">全球市场总公司 · 国际项目和业务开发规划中心</div>
                <div class="addr">Clement &amp; Associates Marketing Limited — 3F Parkview Commercial Building, 9-11 Shelter Street, Causeway Bay, Hong Kong</div>
              </div>
            </div>

            <div class="office">
              <span class="flag">🇲🇾</span>
              <div>
                <div class="city">马来西亚</div>
                <div class="role">全球行政总公司 · 办事处、联号事务所统筹中心</div>
                <div class="addr">Clement &amp; Associates Sdn Bhd — Level 9 &amp; 11, PFCC Tower 4, Jln Puteri 1/2, Bandar Puteri, Puchong, Selangor, Malaysia</div>
              </div>
            </div>

            <div class="contact-meta">
              <div>
                <svg class="icon-svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-2px;margin-right:5px"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="M22 4l-10 8L2 4"/></svg>
                请通过左侧表单与我们联系
              </div>
              <div>
                <svg class="icon-svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align:-2px;margin-right:5px"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                工作日 9:00–18:00
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
          <div class="stat-label">承诺响应时间</div>
        </div>
        <div class="stat-item reveal">
          <div class="stat-num">4</div>
          <div class="stat-label">全球总公司</div>
        </div>
        <div class="stat-item reveal">
          <div class="stat-num">10</div>
          <div class="stat-label">业务模块</div>
        </div>
        <div class="stat-item reveal">
          <div class="stat-num">90%+</div>
          <div class="stat-label">需求预测准确率（目标）</div>
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
