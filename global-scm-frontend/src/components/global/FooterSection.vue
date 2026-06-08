<script setup>
import { useRouter } from 'vue-router'

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
          <div class="footer-tagline">让全球供应链，没有断链之忧</div>
          <p class="brand-desc">从采购寻源到末端配送，从关税波动到航线中断——帮企业把供应链的不确定性，变成可量化、可管理、可优化的日常运营。</p>
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
          <h5>解决方案</h5>
          <ul>
            <li><a href="/solutions#procure" @click.prevent="router.push('/solutions')">跨境采购</a></li>
            <li><a href="/solutions#overseas" @click.prevent="router.push('/solutions')">海外仓运营</a></li>
            <li><a href="/solutions#dropship" @click.prevent="router.push('/solutions')">一件代发 / 直邮</a></li>
            <li><a href="/solutions#distribution" @click.prevent="router.push('/solutions')">分销供销网络</a></li>
          </ul>
        </div>
        <div>
          <h5>产品模块</h5>
          <ul>
            <li><a href="/products#supplier" @click.prevent="router.push('/products')">供应商管理</a></li>
            <li><a href="/products#procurement" @click.prevent="router.push('/products')">智能采购</a></li>
            <li><a href="/products#wms" @click.prevent="router.push('/products')">WMS / OMS</a></li>
            <li><a href="/products#tms" @click.prevent="router.push('/products')">全球物流 TMS</a></li>
            <li><a href="/products#customs" @click.prevent="router.push('/products')">跨境关务</a></li>
          </ul>
        </div>
        <div>
          <h5>了解更多</h5>
          <ul>
            <li><a href="/why-us" @click.prevent="router.push('/why-us')">为什么选我们</a></li>
            <li><a href="/pain-points" @click.prevent="router.push('/pain-points')">痛点与方案</a></li>
            <li><a href="/intel" @click.prevent="router.push('/intel')">供应链新闻台</a></li>
            <li><a href="/contact" @click.prevent="router.push('/contact')">联系我们</a></li>
          </ul>
        </div>
      </div>
      <div class="footer-bottom">
        <span>© 2026 全球供应链大平台. 保留所有权利. <a href="http://www.beian.gov.cn/portal/registerSystemInfo?recordcode=44010602010128" target="_blank" rel="noreferrer">粤公网安备44010602010128号</a> | <a href="https://beian.miit.gov.cn/" target="_blank" rel="noreferrer">粤ICP备17142036号-7</a></span>
        <span class="foot-policy"><a href="#">信息保护政策</a><a href="#">用户协议</a><a href="#">用户行为管理规范</a></span>
      </div>
    </div>
  </footer>
</template>
