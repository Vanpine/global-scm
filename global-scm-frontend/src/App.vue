<script setup>
import NavBar from '@/components/global/NavBar.vue'
import FooterSection from '@/components/global/FooterSection.vue'
</script>

<template>
  <NavBar />
  <main>
    <router-view />
  </main>
  <FooterSection />
</template>
