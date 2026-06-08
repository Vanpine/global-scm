import request from './request'

/**
 * 提交联系表单
 * 对应后端 ContactController → POST /api/contact
 *
 * @param {Object} form  表单数据
 * @param {string} form.name     姓名
 * @param {string} form.company  公司名称
 * @param {string} form.email    邮箱
 * @param {string} form.phone    电话
 * @param {string} form.message  需求描述
 *
 * 所有字段均为可选，但建议至少填写 name + email + message
 * 以便客服回复
 *
 * @returns {Promise<null>}  成功返回 null（后端写库后无业务数据返回）
 *
 * @example
 * await submitContact({
 *   name: '张三',
 *   company: '某科技有限公司',
 *   email: 'zhangsan@example.com',
 *   phone: '13800138000',
 *   message: '我们想了解跨境物流解决方案'
 * })
 */
export function submitContact(form) {
  return request.post('/contact', form)
}
