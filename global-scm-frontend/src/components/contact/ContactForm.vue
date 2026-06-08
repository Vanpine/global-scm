<script setup>
defineProps({
  form: Object,
  submitting: Boolean,
  submitted: Boolean
})

defineEmits(['submit'])
</script>

<template>
  <div>
    <h3 style="font-size:1.25rem;margin-bottom:24px;">和我们聊聊您的供应链</h3>
    <form v-if="!submitted" class="contact-form" @submit.prevent="$emit('submit')" style="display:flex;flex-direction:column;gap:16px;">
      <div class="form-row" style="display:flex;gap:12px;">
        <input v-model="form.name" type="text" placeholder="姓名 / Name" style="flex:1;padding:12px;border:1px solid var(--border);border-radius:8px;background:var(--bg);color:var(--text);font-size:14px;">
        <input v-model="form.company" type="text" placeholder="公司 / Company" style="flex:1;padding:12px;border:1px solid var(--border);border-radius:8px;background:var(--bg);color:var(--text);font-size:14px;">
      </div>
      <div class="form-row" style="display:flex;gap:12px;">
        <input v-model="form.email" type="email" placeholder="邮箱 / Email" style="flex:1;padding:12px;border:1px solid var(--border);border-radius:8px;background:var(--bg);color:var(--text);font-size:14px;">
        <input v-model="form.phone" type="tel" placeholder="电话 / Phone" style="flex:1;padding:12px;border:1px solid var(--border);border-radius:8px;background:var(--bg);color:var(--text);font-size:14px;">
      </div>
      <textarea v-model="form.message" rows="5" placeholder="告诉我们您的业务场景与需求 / Tell us about your business and needs" style="padding:12px;border:1px solid var(--border);border-radius:8px;background:var(--bg);color:var(--text);font-size:14px;resize:vertical;"></textarea>
      <button type="submit" class="btn btn-primary btn-lg" :disabled="submitting" style="align-self:flex-start;">
        {{ submitting ? '提交中...' : '提交申请 →' }}
      </button>
    </form>
    <div v-else class="submit-success" style="background:rgba(52,199,89,0.08);border:1px solid var(--success,#34c759);border-radius:12px;padding:32px;text-align:center;">
      <div style="font-size:48px;margin-bottom:12px;">✅</div>
      <h4 style="margin-bottom:8px;">提交成功！</h4>
      <p style="color:var(--muted);">我们将在 24 小时内回复您，感谢您的信任。</p>
    </div>
  </div>
</template>
