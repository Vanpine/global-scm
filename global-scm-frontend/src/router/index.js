import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/HomeView.vue')
  },
  {
    path: '/products',
    name: 'Products',
    component: () => import('@/views/ProductsView.vue')
  },
  {
    path: '/solutions',
    name: 'Solutions',
    component: () => import('@/views/SolutionsView.vue')
  },
  {
    path: '/why-us',
    name: 'WhyUs',
    component: () => import('@/views/WhyUsView.vue')
  },
  {
    path: '/intel',
    name: 'Intel',
    component: () => import('@/views/IntelView.vue')
  },
  {
    path: '/news/:id',
    name: 'NewsDetail',
    component: () => import('@/views/NewsDetail.vue')
  },
  {
    path: '/pain-points',
    name: 'PainPoints',
    component: () => import('@/views/PainPointsView.vue')
  },
  {
    path: '/contact',
    name: 'Contact',
    component: () => import('@/views/ContactView.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0, behavior: 'instant' }
  }
})

export default router
