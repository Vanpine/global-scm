import { createI18n } from 'vue-i18n'
import zhCN from './locales/zh-CN.json'
import enUS from './locales/en-US.json'

function getSavedLang() {
  const stored = localStorage.getItem('lang')
  if (stored && ['zh-CN', 'en-US'].includes(stored)) return stored
  return 'zh-CN'
}

const i18n = createI18n({
  legacy: false,
  locale: getSavedLang(),
  fallbackLocale: 'zh-CN',
  messages: {
    'zh-CN': zhCN,
    'en-US': enUS
  }
})

export default i18n
