<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { getPageSections } from '@/api/page'
import { useScrollReveal } from '@/composables/useScrollReveal'
import { useRouter } from 'vue-router'

const router = useRouter()
const sections = ref([])

onMounted(async () => {
  sections.value = await getPageSections('intel') || []
  await nextTick()
  refreshReveal()
})

const { refresh: refreshReveal } = useScrollReveal()

function findSection(code) {
  return sections.value.find(s => s.section === code)
}

// ── 静态新闻数据（匹配原型）────────────────────────
const NEWS_GROUPS = [
  {
    title: '地缘冲突',
    icon: `<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>`,
    cat: 'war',
    articles: [
      { id: 'blacksea', title: '黑海出口走廊再遇袭，俄无人机击中三艘外籍商船', summary: '乌克兰粮食与金属外运走廊安全告急，袭击或推高全球粮价，非洲、中东、亚洲进口国首当其冲。', meta: 'Modern Diplomacy · 5 小时前', img: 'https://images.unsplash.com/photo-1494412651409-8963ce7935a7?auto=format&fit=crop&w=900&q=75' },
      { id: 'ukraine', title: '乌克兰"物流封锁"战：年内击中 15 座俄炼油厂', summary: '1–5 月乌方打击 15 座炼油厂，约四成俄炼油产能离线，克里米亚燃油配给，俄已限制成品油出口。', meta: 'Kyiv Independent · 8 小时前', img: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=900&q=75' },
      { id: 'mideast', title: '战争险重定价：中东冲突推高海运保险，承保人撤出海湾', summary: '多家 P&amp;I 俱乐部 72 小时内取消海湾战争险承保，西方船舶保费升至船价数个百分点，成本沿全链路传导。', meta: 'Insurance Business · 今日', img: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=900&q=75' },
    ]
  },
  {
    title: '交通物流',
    icon: `<rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/>`,
    cat: 'logi',
    articles: [
      { id: 'redsea', title: '红海危机延续：主力班轮默认绕行好望角', summary: 'CMA CGM、马士基等已把好望角作为亚欧默认航线，单程增加 10–14 天、燃油上升约 30%，每箱附加费 500–1,500 美元。', meta: 'Reuters · 海运 · 今日', img: 'https://images.unsplash.com/photo-1605745341112-85968b19335b?auto=format&fit=crop&w=900&q=75' },
      { id: 'eu-border', title: '东欧陆运口岸受阻，中欧班列绕行加价', summary: '过境俄罗斯—白俄罗斯—波兰的主通道持续受地缘冲突影响，陆运时效与成本上升，企业转向多枢纽与备选路由。', meta: 'GMK Center · 1 天前', img: 'https://images.unsplash.com/photo-1566576721346-d4a3b4eaeb55?auto=format&fit=crop&w=900&q=75' },
      { id: 'panama', title: '巴拿马运河暂不限航，2027 干旱风险笼罩', summary: '运河管理局称年内维持 38 班/日、不限航；但 El Niño 强度上升，2027 旱季或重演 2023 减班至 22 班/日的局面。', meta: 'Tico Times · 1 天前', img: 'https://images.unsplash.com/photo-1605745341112-85968b19335b?auto=format&fit=crop&w=900&q=75' },
    ]
  },
  {
    title: '能源与环境',
    icon: `<polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/>`,
    cat: 'energy',
    articles: [
      { id: 'hormuz', title: '霍尔木兹海峡近乎关闭，全球两成石油咽喉中断', summary: '自 2 月底美以空袭伊朗以来，海峡日通行量从约 95 艘骤降至个位数，布伦特原油逼近 95 美元，战争险一度暴涨逾十倍。', meta: 'Bloomberg · 能源 · 2 小时前', img: 'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=900&q=75' },
      { id: 'cbam', title: '欧盟 CBAM 碳边境机制进入正式期，进口商须清缴碳证', summary: '自 1 月 1 日起，钢铁、水泥、铝、化肥、电力、氢进口需具备授权申报人资格并清缴碳证；Q1 碳价 75.36 欧元/吨。', meta: 'European Commission · 2 天前', img: 'https://images.unsplash.com/photo-1494412651409-8963ce7935a7?auto=format&fit=crop&w=900&q=75' },
    ]
  },
  {
    title: '贸易政策',
    icon: `<line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/>`,
    cat: 'policy',
    articles: [
      { id: 'tariff', title: '美国 Section 232 金属关税扩围至铜，最高 50%', summary: '4 月 6 日起钢、铝、铜及衍生品按全额征税：主金属 50%、衍生品 25%、部分工业设备 15%，重塑采购成本与产地选择。', meta: 'Baker Tilly · 今日', img: 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?auto=format&fit=crop&w=900&q=75' },
      { id: 'section122', title: '美国 10% 普遍关税陷法律拉锯，7 月 24 日到期前仍在征收', summary: '国际贸易法院裁定 Section 122 关税违法，但联邦巡回法院发出临时中止令，CBP 继续照常征收，退税并不自动。', meta: 'Flexport · 今日', img: 'https://images.unsplash.com/photo-1517048676732-d65bc937f952?auto=format&fit=crop&w=900&q=75' },
      { id: 'rareearth', title: '中国稀土管制悬顶：11 月 10 日大限将至', summary: '2025 年 4 月七类中重稀土许可制仍生效；10 月扩大管制暂停至 11 月 10 日，若重启，域外条款将波及含中国稀土的海外制成品。', meta: 'TechTimes · IEA · 3 小时前', img: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=900&q=75' },
      { id: 'export-control', title: '美对华 AI 芯片管制收紧，明确适用海外子公司', summary: '商务部澄清：对总部在华企业，其海外子公司同样受 AI 芯片出口限制约束；H200 按个案审查，Blackwell 仍禁运。', meta: 'Al Jazeera · BIS · 1 天前', img: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=900&q=75' },
      { id: 'pharma', title: '美国对进口药品加征关税，最高 100%', summary: '对专利药品及原料药按 20%–100% 分档征税，7 月 31 日 / 9 月 29 日分批生效，英国药品按 10%，重塑医药供应链布局。', meta: 'Baker Tilly · 1 天前', img: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=900&q=75' },
      { id: 'usmca', title: 'USMCA 联合复审临近，7 月 1 日成关键节点', summary: '依第 34.7 条，协定生效六年后启动联合复审；若三国未共同确认，将进入十年"日落"机制，牵动北美供应链与近岸布局。', meta: 'Deluair · 2 天前', img: 'https://images.unsplash.com/photo-1605902711622-cfb43c4437b5?auto=format&fit=crop&w=900&q=75' },
    ]
  },
]

// ── Hero 标签图标映射 ──────────────────────────────
const HERO_ICONS = {
  'file-text': `<path d="M4 6h16"/><path d="M4 10h16"/><path d="M4 14h8"/><path d="M4 18h5"/><rect x="14" y="14" width="6" height="6" rx="1"/>`,
  globe: `<circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/>`,
  truck: `<rect x="1" y="3" width="15" height="13"/><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/>`,
}
</script>

<template>
  <!-- ═══ Hero ═══ -->
  <section class="hero" style="min-height:100vh; height:100vh;" v-if="findSection('hero')">
    <img class="hero-video" src="https://images.unsplash.com/photo-1450101499163-c8848c66ca85?auto=format&fit=crop&w=1920&q=85" alt="" style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;pointer-events:none;">
    <div class="hero-overlay"></div>
    <div class="hero-content">
      <h1>全球情报<span>要闻</span></h1>
      <p class="lead">实时追踪政策、关税、地缘与物流动态</p>
      <p class="hero-sub">
        <span v-for="(item, i) in parseItems(findSection('hero').itemsJson)" :key="i">
          <svg class="icon-svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="HERO_ICONS[item.icon] || ''"></svg>
          {{ item.text }}
        </span>
      </p>
    </div>
  </section>

  <!-- ═══ 全球情报要闻 ═══ -->
  <section class="section news-hub" id="news" style="padding-bottom:56px;">
    <div class="container">
      <div class="news-group reveal" v-for="(group, gi) in NEWS_GROUPS" :key="gi">
        <h3 class="news-group-title">
          <svg class="icon-svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="group.icon"></svg>
          {{ group.title }}
        </h3>
        <div class="news-grid">
          <div class="news-card" v-for="(article, ai) in group.articles" :key="ai"
               @click="router.push('/news/' + article.id)" style="cursor:pointer;">
            <div class="news-thumb">
              <img :src="article.img" alt="" loading="lazy" onerror="this.onerror=null;this.style.display='none';this.parentNode.classList.add('noimg')">
              <span :class="'news-cat ' + group.cat">{{ group.title }}</span>
            </div>
            <div class="news-info">
              <h3>{{ article.title }}</h3>
              <p class="news-sum">{{ article.summary }}</p>
              <div class="news-foot">
                <span class="news-meta">{{ article.meta }}</span>
                <span class="news-more">阅读详情 →</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <p class="news-disclaimer reveal">* 全球情报要闻基于 2026 年公开报道整理，用于展示版式与解读视角；点击任意卡片查看完整内容。</p>
    </div>
  </section>

  <!-- ═══ 可缩放世界地图 ═══ -->
  <section class="section" style="padding-top:56px;">
    <div class="container">
      <div class="text-center reveal" style="margin-bottom:48px;">
        <div class="eyebrow">INTERACTIVE MAP · 区域态势</div>
        <h2 class="section-title">可缩放的全球风险地图</h2>
        <p class="section-sub">放大任意区域，查看港口、航线与高危事件的分布细节。滚轮缩放、拖动平移、点击标记查看详情。</p>
      </div>
      <div class="leaflet-wrap reveal">
        <div id="riskLeaflet"></div>
        <div class="map-legend">
          <span><i style="background:#ff3b30"></i>高危</span>
          <span><i style="background:#ff9500"></i>关注</span>
          <span><i style="background:#34c759"></i>正常</span>
        </div>
      </div>
      <p class="section-sub reveal" style="font-size:13px;margin-top:18px;opacity:0.7;">* 供应链风险点为演示数据；全球地震为 USGS 实时数据（纯前端直连，每 60 秒自动刷新）。</p>
    </div>
  </section>
</template>
