<script setup>
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()
const router = useRouter()
</script>

<template>
  <footer class="footer">
    <div class="container">
      <div class="footer-top">
        <div class="footer-brand">
          <div class="brand-name">
            <img class="logo-img" src="/logo.png" alt="Global Supply Chain">
          </div>
          <div class="footer-tagline">{{ t('footer.tagline') }}</div>
          <p class="brand-desc">{{ t('footer.desc') }}</p>
          <div class="footer-social">
            <a href="#" aria-label="LinkedIn">in</a>
            <a href="#" aria-label="X">𝕏</a>
            <a href="mailto:hello@globalscm.com" aria-label="Email">
              <svg class="icon-svg" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="2" y="4" width="20" height="16" rx="2"/><path d="M22 4l-10 8L2 4"/>
              </svg>
            </a>
            <a href="#" aria-label="Website">
              <svg class="icon-svg" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>
              </svg>
            </a>
          </div>
        </div>
        <div>
          <h5>{{ t('footer.solutions') }}</h5>
          <ul>
            <li><a href="/solutions#procure" @click.prevent="router.push('/solutions')">{{ t('footer.sol1') }}</a></li>
            <li><a href="/solutions#overseas" @click.prevent="router.push('/solutions')">{{ t('footer.sol2') }}</a></li>
            <li><a href="/solutions#dropship" @click.prevent="router.push('/solutions')">{{ t('footer.sol3') }}</a></li>
            <li><a href="/solutions#distribution" @click.prevent="router.push('/solutions')">{{ t('footer.sol4') }}</a></li>
          </ul>
        </div>
        <div>
          <h5>{{ t('footer.products') }}</h5>
          <ul>
            <li><a href="/products#supplier" @click.prevent="router.push('/products')">{{ t('footer.prod1') }}</a></li>
            <li><a href="/products#procurement" @click.prevent="router.push('/products')">{{ t('footer.prod2') }}</a></li>
            <li><a href="/products#wms" @click.prevent="router.push('/products')">{{ t('footer.prod3') }}</a></li>
            <li><a href="/products#tms" @click.prevent="router.push('/products')">{{ t('footer.prod4') }}</a></li>
            <li><a href="/products#customs" @click.prevent="router.push('/products')">{{ t('footer.prod5') }}</a></li>
          </ul>
        </div>
        <div>
          <h5>{{ t('footer.about') }}</h5>
          <ul>
            <li><a href="/why-us" @click.prevent="router.push('/why-us')">{{ t('footer.about1') }}</a></li>
            <li><a href="/pain-points" @click.prevent="router.push('/pain-points')">{{ t('footer.about2') }}</a></li>
            <li><a href="/intel" @click.prevent="router.push('/intel')">{{ t('footer.about3') }}</a></li>
            <li><a href="/contact" @click.prevent="router.push('/contact')">{{ t('footer.about4') }}</a></li>
          </ul>
        </div>
      </div>
      <div class="footer-bottom">
        <span>{{ t('footer.copyright') }} <a href="http://www.beian.gov.cn/portal/registerSystemInfo?recordcode=44010602010128" target="_blank" rel="noreferrer">粤公网安备44010602010128号</a> | <a href="https://beian.miit.gov.cn/" target="_blank" rel="noreferrer">粤ICP备17142036号-7</a></span>
        <span class="foot-policy"><a href="#">{{ t('footer.policy') }}</a><a href="#">{{ t('footer.terms') }}</a><a href="#">{{ t('footer.conduct') }}</a></span>
      </div>
    </div>
  </footer>
</template>
