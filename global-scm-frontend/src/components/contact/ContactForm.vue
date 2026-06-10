<script setup>
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

defineProps({
  form: Object,
  submitting: Boolean
})

defineEmits(['submit'])
</script>

<template>
  <div>
    <form class="contact-form-card reveal" style="height:100%;display:flex;flex-direction:column;" @submit.prevent="$emit('submit')">
      <h3 class="form-title">{{ t('form.title') }}</h3>

      <div class="form-row">
        <div class="form-field">
          <label>{{ t('form.name') }}</label>
          <input v-model="form.name" type="text" required :placeholder="t('form.namePlaceholder')">
        </div>
        <div class="form-field">
          <label>{{ t('form.company') }}</label>
          <input v-model="form.company" type="text" required :placeholder="t('form.companyPlaceholder')">
        </div>
      </div>

      <div class="form-row">
        <div class="form-field">
          <label>{{ t('form.email') }}</label>
          <input v-model="form.email" type="email" required :placeholder="t('form.emailPlaceholder')">
        </div>
        <div class="form-field">
          <label>{{ t('form.phone') }}</label>
          <input v-model="form.phone" type="tel" :placeholder="t('form.phonePlaceholder')">
        </div>
      </div>

      <div class="form-field">
        <label>{{ t('form.role') }}</label>
        <select v-model="form.role">
          <option value="" disabled>{{ t('form.rolePlaceholder') }}</option>
          <option value="ceo">{{ t('form.roleCeo') }}</option>
          <option value="vp">{{ t('form.roleSupplyChain') }}</option>
          <option value="procurement">{{ t('form.roleProcurement') }}</option>
          <option value="logistics">{{ t('form.roleLogistics') }}</option>
          <option value="other">{{ t('form.roleOther') }}</option>
        </select>
      </div>

      <div class="form-field">
        <label>{{ t('form.challenge') }}</label>
        <textarea v-model="form.message" :placeholder="t('form.challengePlaceholder')"></textarea>
      </div>

      <button type="submit" class="btn btn-primary btn-lg" :disabled="submitting" style="width:100%;justify-content:center;">
        {{ submitting ? t('form.submitting') : t('form.submit') }}
      </button>
      <p style="font-size:13px;color:var(--text-tertiary);margin-top:14px;text-align:center;">{{ t('form.privacy') }}</p>
    </form>
  </div>
</template>
