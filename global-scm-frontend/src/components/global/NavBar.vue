<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()
const menuOpen = ref(false)

const navLinks = [
  { to: '/', label: '首页' },
  { to: '/products', label: '产品功能' },
  { to: '/solutions', label: '解决方案' },
  { to: '/why-us', label: '为什么选我们' },
  { to: '/intel', label: '供应链新闻台' }
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
        >{{ link.label }}</a>
      </nav>
      <div class="nav-right">
        <button class="lang-toggle" id="lang-toggle" aria-label="切换语言 / Switch language">
          <span>
            <svg class="icon-svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10"/>
              <line x1="2" y1="12" x2="22" y2="12"/>
              <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>
            </svg>
          </span>
          <span id="lang-current">EN</span>
        </button>
        <a class="nav-cta" href="/contact" @click.prevent="router.push('/contact')">申请加入</a>
      </div>
      <button class="nav-toggle" :class="{ open: menuOpen }" aria-label="菜单" @click="toggleMenu">
        <span></span><span></span><span></span>
      </button>
    </div>
  </header>
</template>
