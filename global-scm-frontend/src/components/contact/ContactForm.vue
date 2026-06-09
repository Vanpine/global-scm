<script setup>
defineProps({
  form: Object,
  submitting: Boolean
})

defineEmits(['submit'])
</script>

<template>
  <div>
    <form class="contact-form-card reveal" style="height:100%;display:flex;flex-direction:column;" @submit.prevent="$emit('submit')">
      <h3 class="form-title">填写需求，我们 24 小时内联系您</h3>

      <div class="form-row">
        <div class="form-field">
          <label>姓名 *</label>
          <input v-model="form.name" type="text" required placeholder="请输入您的姓名">
        </div>
        <div class="form-field">
          <label>公司名称 *</label>
          <input v-model="form.company" type="text" required placeholder="请输入公司名称">
        </div>
      </div>

      <div class="form-row">
        <div class="form-field">
          <label>工作邮箱 *</label>
          <input v-model="form.email" type="email" required placeholder="name@company.com">
        </div>
        <div class="form-field">
          <label>联系电话</label>
          <input v-model="form.phone" type="tel" placeholder="+86 138-xxxx-xxxx">
        </div>
      </div>

      <div class="form-field">
        <label>您的角色</label>
        <select v-model="form.role">
          <option value="" disabled>请选择您的角色</option>
          <option>CEO / 创始人</option>
          <option>供应链 VP / 总监</option>
          <option>采购负责人</option>
          <option>仓储 / 物流负责人</option>
          <option>其他</option>
        </select>
      </div>

      <div class="form-field">
        <label>您当前最大的供应链挑战是什么？</label>
        <textarea v-model="form.message" placeholder="例如：单一供应商依赖、库存积压、异常响应慢、跨境合规复杂……"></textarea>
      </div>

      <button type="submit" class="btn btn-primary btn-lg" :disabled="submitting" style="width:100%;justify-content:center;">
        {{ submitting ? '提交中...' : '提交咨询 →' }}
      </button>
      <p style="font-size:13px;color:var(--text-tertiary);margin-top:14px;text-align:center;">提交即表示您同意我们的隐私政策。我们绝不会向第三方分享您的信息。</p>
    </form>
  </div>
</template>
