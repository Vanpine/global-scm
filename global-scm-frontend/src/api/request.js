import axios from 'axios'

/** Axios 实例：全局 baseURL + 超时 + 拦截器 */
const request = axios.create({
  baseURL: '/api',       // Vite proxy 转发到后端 120.26.30.114:8080
  timeout: 15000         // 15s 超时
})

/**
 * 请求拦截器
 * 可在此处统一注入 token、请求头等
 */
request.interceptors.request.use(
  (config) => {
    // 预留：config.headers.Authorization = `Bearer ${token}`
    return config
  },
  (err) => Promise.reject(err)
)

/**
 * 响应拦截器
 * 统一解包 { code, message, data } 格式
 *  - code === 200 → 返回 data
 *  - code !== 200 → 打印警告，返回 null
 *  - 网络异常      → 打印错误，向上抛出
 */
request.interceptors.response.use(
  (res) => {
    const body = res.data
    if (body.code === 200) {
      return body.data
    }
    // 业务错误（404、500 等）
    console.warn(`[API] ${res.config.url} → ${body.code} ${body.message}`)
    return null
  },
  (err) => {
    // 网络超时 / 服务器不可达
    const url = err.config?.url || 'unknown'
    console.error(`[API] ${url} → 网络异常`, err.message)
    return Promise.reject(err)
  }
)

export default request
