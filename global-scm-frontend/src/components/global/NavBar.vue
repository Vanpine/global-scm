<script setup>
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useI18n } from 'vue-i18n'

const { t, locale } = useI18n()
const router = useRouter()
const route = useRoute()
const menuOpen = ref(false)

const navLinks = [
  { to: '/', key: 'nav.home' },
  { to: '/products', key: 'nav.products' },
  { to: '/solutions', key: 'nav.solutions' },
  { to: '/why-us', key: 'nav.whyUs' },
  { to: '/intel', key: 'nav.intel' }
]

function isActive(path) {
  if (path === '/') return route.path === '/'
  return route.path.startsWith(path)
}

function toggleMenu() {
  menuOpen.value = !menuOpen.value
}

function closeMenu() {
  menuOpen.value = false
}

function navigate(link) {
  closeMenu()
  router.push(link.to)
}

function toggleLang() {
  locale.value = locale.value === 'zh-CN' ? 'en-US' : 'zh-CN'
  localStorage.setItem('lang', locale.value)
}

const currentLangLabel = computed(() => locale.value === 'zh-CN' ? '中' : 'EN')
</script>

<template>
  <header class="navbar">
    <div class="navbar-inner">
      <a class="nav-logo" href="/">
        <img class="logo-img" src="/logo.png" alt="Global Supply Chain">
      </a>
      <nav class="nav-links" :class="{ open: menuOpen }">
        <a
          v-for="link in navLinks"
          :key="link.to"
          :href="link.to"
          :class="{ active: isActive(link.to) }"
          @click.prevent="navigate(link)"
        >{{ t(link.key) }}</a>
      </nav>
      <div class="nav-right">
        <button class="lang-toggle" id="lang-toggle" :aria-label="t('nav.langToggle')" @click="toggleLang">
          <span>
            <svg class="icon-svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10"/>
              <line x1="2" y1="12" x2="22" y2="12"/>
              <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>
            </svg>
          </span>
          <span id="lang-current">{{ currentLangLabel }}</span>
        </button>
        <a class="nav-cta" href="/contact" @click.prevent="router.push('/contact')">{{ t('nav.join') }}</a>
      </div>
      <button class="nav-toggle" :class="{ open: menuOpen }" aria-label="菜单" @click="toggleMenu">
        <span></span><span></span><span></span>
      </button>
    </div>
  </header>
</template>
