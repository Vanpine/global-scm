-- ============================================================
-- Global SCM 官网数据库 · 建表语句
-- MySQL 8.0+ / utf8mb4 / InnoDB
--
-- 设计原则：
--   1. 数据库中只存中文，英文走前端 vue-i18n
--   2. 列名避开 MySQL 8.0 保留字（如 lead → subtitle）
--   3. 灵活内容用 JSON 列，结构化查询字段单独建列
-- ============================================================

CREATE DATABASE IF NOT EXISTS global_scm
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE global_scm;

-- ============================================================
-- 1. 首页 Hero 区（单行配置）
-- ============================================================
DROP TABLE IF EXISTS home_hero;
CREATE TABLE home_hero (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    title               VARCHAR(150) NOT NULL COMMENT '主标题',
    highlight           VARCHAR(50)  COMMENT '高亮词',
    subtitle            VARCHAR(200) COMMENT '引导语',
    tags_json           JSON         COMMENT '标签行 [{"icon":"xxx","text":"xxx"},...]',
    cta_primary_text    VARCHAR(50)  COMMENT '主按钮文字',
    cta_primary_href    VARCHAR(100) COMMENT '主按钮链接',
    cta_secondary_text  VARCHAR(50)  COMMENT '次按钮文字',
    cta_secondary_href  VARCHAR(100) COMMENT '次按钮链接',
    video_url           VARCHAR(500) COMMENT '背景视频URL',
    updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='首页Hero区';

-- ============================================================
-- 2. 首页多重危机卡片
-- ============================================================
DROP TABLE IF EXISTS home_crisis_cards;
CREATE TABLE home_crisis_cards (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    tag         VARCHAR(30)  NOT NULL COMMENT '卡片分类标签',
    title       VARCHAR(200) NOT NULL COMMENT '标题',
    description TEXT         COMMENT '描述',
    items_json  JSON         COMMENT '要点列表 ["要点1","要点2",...]',
    img_url     VARCHAR(500) COMMENT '配图URL',
    sort_order  INT          NOT NULL DEFAULT 0 COMMENT '排序',
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='首页多重危机卡片';

-- ============================================================
-- 3. 首页轮播图
-- ============================================================
DROP TABLE IF EXISTS home_carousel;
CREATE TABLE home_carousel (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    img_url     VARCHAR(500) NOT NULL COMMENT '图片URL',
    eyebrow     VARCHAR(100) COMMENT '眉题',
    title       VARCHAR(300) COMMENT '标题',
    description TEXT         COMMENT '描述',
    sort_order  INT          NOT NULL DEFAULT 0 COMMENT '排序',
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='首页轮播图';

-- ============================================================
-- 4. 首页其他区块（stats / mission / ai-empowerment / risk-feed / cta）
-- ============================================================
DROP TABLE IF EXISTS home_sections;
CREATE TABLE home_sections (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    section     VARCHAR(40)  NOT NULL COMMENT '区块标识',
    title       VARCHAR(300) COMMENT '标题',
    subtitle    TEXT         COMMENT '副标题',
    items_json  JSON         COMMENT '数据内容（结构视区块类型而定）',
    sort_order  INT          NOT NULL DEFAULT 0 COMMENT '排序',
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_section_sort (section, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='首页其他区块';

-- ============================================================
-- 5. 各页面区块（products / solutions / why-us / intel / contact / pain-points）
-- ============================================================
DROP TABLE IF EXISTS page_sections;
CREATE TABLE page_sections (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    page        VARCHAR(30)  NOT NULL COMMENT '页面标识',
    section     VARCHAR(40)  NOT NULL COMMENT '区块标识',
    title       VARCHAR(300) COMMENT '标题',
    subtitle    TEXT         COMMENT '副标题',
    items_json  JSON         COMMENT '数据内容（结构视区块类型而定）',
    sort_order  INT          NOT NULL DEFAULT 0 COMMENT '排序',
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_page (page),
    UNIQUE KEY uk_page_section_sort (page, section, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='页面区块内容';

-- ============================================================
-- 6. 新闻文章
-- ============================================================
DROP TABLE IF EXISTS article_tags;
DROP TABLE IF EXISTS article_blocks;
DROP TABLE IF EXISTS articles;

CREATE TABLE articles (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    title         VARCHAR(300) NOT NULL COMMENT '标题',
    summary       VARCHAR(500) COMMENT '摘要',
    category      VARCHAR(30)  NOT NULL COMMENT '分类：war/logi/energy/policy',
    cover_img     VARCHAR(500) COMMENT '封面图URL',
    source        VARCHAR(200) COMMENT '来源',
    source_url    VARCHAR(500) COMMENT '来源链接',
    meta          VARCHAR(200) COMMENT '元信息：来源·领域·时间',
    status        VARCHAR(20)  NOT NULL DEFAULT 'published' COMMENT 'draft/published/archived',
    published_at  DATETIME     COMMENT '发布时间',
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_status_published (status, published_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='新闻文章';

-- ============================================================
-- 7. 文章内容块（kt=导语 / lead=引导 / p=段落 / quote=引用）
-- ============================================================
CREATE TABLE article_blocks (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    article_id  BIGINT       NOT NULL COMMENT '关联 articles.id',
    block_type  VARCHAR(10)  NOT NULL COMMENT 'kt/lead/p/quote',
    content     TEXT         NOT NULL COMMENT '内容',
    sort_order  INT          NOT NULL DEFAULT 0 COMMENT '排序',
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    INDEX idx_article_order (article_id, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章内容块';

-- ============================================================
-- 8. 文章标签
-- ============================================================
CREATE TABLE article_tags (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    article_id  BIGINT      NOT NULL,
    tag_name    VARCHAR(50) NOT NULL COMMENT '标签名',
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    INDEX idx_tag (tag_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文章标签';

-- ============================================================
-- 9. 联系表单提交记录
-- ============================================================
DROP TABLE IF EXISTS contacts;
CREATE TABLE contacts (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) COMMENT '姓名',
    company     VARCHAR(200) COMMENT '公司名称',
    email       VARCHAR(200) COMMENT '邮箱',
    phone       VARCHAR(50)  COMMENT '电话',
    message     TEXT         COMMENT '需求描述',
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='联系表单提交记录';

-- ============================================================
-- ============================================================
-- 初始数据
-- ============================================================
-- ============================================================

-- -------------------------------------------------------
-- 1. 首页 Hero
-- -------------------------------------------------------
INSERT INTO home_hero (title, highlight, subtitle, tags_json, cta_primary_text, cta_primary_href, cta_secondary_text, cta_secondary_href, video_url) VALUES
('全球供应链', '大平台', '赋能地方资源 · 连接全球市场',
'[{"icon":"trending-up","text":"降本增效"},{"icon":"shield","text":"抗风险"},{"icon":"cpu","text":"AI 赋能"}]',
'申请加入 →', '/contact', '了解产品 →', '/products',
'assets/vedio.mp4');

-- -------------------------------------------------------
-- 2. 首页多重危机卡片（6 张）
-- -------------------------------------------------------
INSERT INTO home_crisis_cards (tag, title, description, items_json, img_url, sort_order) VALUES
('贸易政策', '政策、关税与监管突变',
 '美国 Section 232、301 关税频繁调整，欧盟 CBAM 碳边境机制正式实施，企业合规成本与日俱增。突然加征或取消关税，让采购预算瞬间失控。',
 '["关税一日三变，到岸成本难以预估","出口管制与制裁清单持续扩大","ESG 合规、碳关税成为新贸易壁垒"]',
 'https://images.unsplash.com/photo-1681505531034-8d67054e07f6?auto=format&fit=crop&w=1400&q=85', 1),
('地缘政治', '地缘冲突与航线中断',
 '红海危机迫使主力班轮绕行好望角，霍尔木兹海峡紧张局势威胁全球两成石油运输。战争险费率飙升，交货周期与物流成本双双失控。',
 '["红海绕行每航次增加 10-14 天","战争险费率暴涨，运价剧烈波动","海峡封锁风险随时切断关键航线"]',
 'https://images.unsplash.com/photo-1605745341112-85968b19335b?auto=format&fit=crop&w=1400&q=85', 2),
('物流瓶颈', '物流与基础设施瓶颈',
 '全球主要港口频繁拥堵，舱位紧张、运价剧烈波动，运河限航与枢纽中断让供应链时刻面临中断风险，传统单一线路已无法应对。',
 '["港口拥堵、舱位紧张，船期大面积延误","集装箱运价单周波动可达 30%","苏伊士/巴拿马运河限航常态化"]',
 'https://images.unsplash.com/photo-1494412651409-8963ce7935a7?auto=format&fit=crop&w=1400&q=85', 3),
('需求风险', '需求波动与牛鞭效应',
 '终端需求微小波动，经经销商、品牌商、制造商逐级放大，最终在原料端形成剧烈震荡。爆单与积压只在一念之间，预测失准导致全链路库存失衡。',
 '["需求信号延迟 4-6 周传导至上游","牛鞭效应造成库存成本放大 3-5 倍","爆单期缺货 vs 淡季积压并存"]',
 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1400&q=85', 4),
('供应风险', '单点依赖与断供风险',
 '单一供应商、单一仓库、单一航线——任何一处发生罢工、火灾或自然灾害，核心 SKU 可能断供数月，产线停工损失以小时计。',
 '["单一供应商/仓库/航线集中风险","罢工、火灾、自然灾害随时触发断供","核心零部件断供导致全线停产"]',
 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=1400&q=85', 5),
('网络安全', '网络攻击与数字系统风险',
 '全球港口与物流平台频繁遭受勒索软件攻击，一次系统瘫痪即可导致货物滞留、数据泄露与数千万美元损失，数字化越深攻击面越广。',
 '["港口操作系统遭勒索攻击停摆","物流平台瘫痪导致全链路失明","客户数据与交易记录被窃取"]',
 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1400&q=85', 6);

-- -------------------------------------------------------
-- 3. 首页轮播图（4 张）
-- -------------------------------------------------------
INSERT INTO home_carousel (img_url, eyebrow, title, description, sort_order) VALUES
('https://images.unsplash.com/photo-1606185540834-d6e7483ee1a4?auto=format&fit=crop&w=1920&q=80',
 'END-TO-END VISIBILITY', '一张地图，掌控全球每一票货',
 '所有在途柜子、所有仓库库存、所有 PO 履约进度 —— 实时控制塔，一眼看清全盘。', 1),
('https://images.unsplash.com/photo-1613690399151-65ea69478674?auto=format&fit=crop&w=1920&q=80',
 'ELASTIC ROUTING', '弹性路由，告别脱钩断供',
 '苏伊士受阻自动切换好望角，海运中断切换中欧班列 —— 异常事件触发智能改道建议。', 2),
('https://images.unsplash.com/photo-1587293852726-70cdb56c2866?auto=format&fit=crop&w=1920&q=80',
 'SMART WAREHOUSE', '多仓协同，周转天数从 90 天降至 55 天',
 '国内仓 / 海外仓 / FBA 仓统一管理，AI 波次规划 + 扫码作业，库存周转天数从 90 天降至 55 天。', 3),
('https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=1920&q=80',
 'AI COPILOT', '用自然语言，指挥整条供应链',
 '“美西港口罢工会影响我哪些货？” —— Copilot 直连业务数据，秒级给出受影响清单与应对方案。', 4);

-- -------------------------------------------------------
-- 4. 首页其他区块
-- -------------------------------------------------------
INSERT INTO home_sections (section, title, subtitle, items_json, sort_order) VALUES
('stats', NULL, NULL,
 '[{"label":"需求预测准确率（目标）","value":"90%+"},{"label":"库存周转天数（目标）","value":"≤55天"},{"label":"异常响应时间（目标）","value":"≤4h"},{"label":"准时足量交付 OTIF（目标）","value":"92%+"}]', 1),
('mission', '让全球供应链，没有断链之忧', '在地缘冲突与贸易保护主义频发的时代，用 AI 重构供应链的连接方式与抗风险能力。',
 '[{"icon":"globe","title":"赋能地方基层资源，对接全球供应链","desc":"用 AI 把地方优势产业、特色原料与闲置产能精准对接全球需求，形成“单点突破、多点支撑”的网络，对冲断链风险、增强产业韧性。","tags":["单点突破","多点支撑","抗断链"]},{"icon":"chart","title":"让企业实现“降本、增效、抗风险”","desc":"“供应链管理 AI 控制台”实时监测全球气象、地缘政治、关税、贸易政策与物流，让企业在不确定时代保持灵活与韧性。","tags":["降本","增效","抗风险"]}]', 2),
('ai-empowerment', '用 AI 赋能，把不确定变成可管理', '面对上述挑战，用感知—分析—决策—执行的 AI 闭环，取代经验驱动与信息孤岛。',
 '[{"icon":"radar","title":"全球情报感知","sub":"政策 · 关税 · 台风 · 罢工","desc":"自动聚合海关政策、制裁名单、气象与港口状态，按品类/线路精准推送，让您从“我不知道”变成“我早有准备”。"},{"icon":"brain","title":"AI 数据驱动决策","sub":"需求预测 · TCO · 仿真","desc":"融合 12+ 维度数据的概率预测、全链路 TCO 优化、断点仿真推演，让决策从“差不多”变成“量化最优”。"},{"icon":"shield","title":"韧性供应网络","sub":"多源采购 · 弹性路由","desc":"分布式供应、多枢纽物流、应急一键切换 —— 单点断供、航线中断也能在数小时内重组链路。"}]', 3),
('risk-feed', '实时洞察全球供应链风险', '实时监测地缘冲突、港口拥堵、极端天气与政策变化，高危区域自动高亮预警。',
 '[{"title":"红海危机延续：主力班轮默认绕行好望角","cat":"logi","meta":"Reuters · 海运 · 今日","href":"news-redsea.html"},{"title":"霍尔木兹海峡近乎关闭，全球两成石油咽喉中断","cat":"energy","meta":"Bloomberg · 能源 · 2 小时前","href":"news-hormuz.html"},{"title":"美国 Section 232 金属关税扩围至铜，最高 50%","cat":"policy","meta":"Baker Tilly · 今日","href":"news-tariff.html"},{"title":"中国稀土管制悬顶：11 月 10 日大限将至","cat":"policy","meta":"TechTimes · 3 小时前","href":"news-rareearth.html"},{"title":"黑海出口走廊再遇袭，俄无人机击中三艘外籍商船","cat":"war","meta":"Modern Diplomacy · 5 小时前","href":"news-blacksea.html"},{"title":"欧盟 CBAM 碳边境机制进入正式期，进口商须清缴碳证","cat":"energy","meta":"European Commission · 2 天前","href":"news-cbam.html"}]', 4),
('cta', '准备好让供应链穿越不确定了吗？', '告诉我们您的业务场景，我们用真实数据帮您评估降本与抗风险空间。',
 '[{"text":"免费申请加入 →","href":"/contact","primary":true},{"text":"hello@globalscm.com","href":"mailto:hello@globalscm.com","primary":false}]', 5);

-- -------------------------------------------------------
-- 5. 页面区块数据
-- -------------------------------------------------------

-- === 产品功能页 (products) ===
INSERT INTO page_sections (page, section, title, subtitle, items_json, sort_order) VALUES
('products', 'hero', '六大模块协同运转', '从供应商到终端客户，全链路数字化',
 '[{"icon":"package","text":"采购"},{"icon":"warehouse","text":"仓储"},{"icon":"truck","text":"物流"},{"icon":"file-text","text":"关务"}]', 1),
('products', 'pain-points-flow', '一趟货从采购到签收，至少过这几关', '一张图看清：一趟货从采购到签收，需要经过哪些关键节点。',
 '[{"title":"找供应商","items":["靠不靠谱？","会不会突然断供？","比别人贵了多少？"]},{"title":"下采购单","items":["什么时候该补货？","补多少才不压库存？","报价太多怎么比？"]},{"title":"管仓储","items":["压多了还是压少了？","拣货老是出错？","效期过了才发现？"]},{"title":"管订单","items":["订单从哪发最省？","超时了谁负责？","退货怎么处理？"]},{"title":"追物流","items":["货现在到哪了？","会不会延误？","延误了怎么办？"]},{"title":"报清关","items":["HS 归对了吗？","关税多交了？","单证被退过吗？"]}]', 2),
('products', 'modules', '每个模块，对应一个关键环节', '六个模块，一一对应供应链的六个关键节点。',
 '[{"id":"supplier","icon":"warehouse","title":"供应商管理","sub":"Supplier Management","desc":"不在出问题后救火，而在出问题前预警。自动追踪每个供应商的准时率、质量合格率、价格趋势，恶化前提醒你切换备选。","tags":["准时率追踪","质量监控","价格预警","多源备选"]},{"id":"procurement","icon":"clipboard","title":"智能采购","sub":"Procurement","desc":"不再凭感觉判断“该补货了”。AI 预测需求 + TCO 全链路比价 + 自动跟单，PO 周期从 3–5 天缩至 1 天内。","tags":["AI 需求预测","TCO 比价","PO 自动化","交期预警"]},{"id":"wms","icon":"package","title":"仓储管理 WMS","sub":"Warehouse","desc":"库存不是越少越好——断货的代价远大于仓储费。动态安全库存模型帮你找到最优水位，周转天数从 90 天降至 55 天。","tags":["动态安全库存","波次拣货","效期管理","FBA 对接"]},{"id":"oms","icon":"list","title":"订单履约 OMS","sub":"Order Management","desc":"订单进来，系统自动选最省最快的方式发出。多渠道接单、智能拆合、SLA 超时预警——不用每天盯屏幕。","tags":["多渠道接单","智能路由","自动拆合","SLA 预警"]},{"id":"tms","icon":"truck","title":"全球物流 TMS","sub":"Transportation","desc":"货到哪里了、会不会延误——不用打电话问货代。实时轨迹追踪 + ETA 预测 + 异常自动告警，出问题前就知道。","tags":["实时追踪","ETA 预测","多式联运","异常告警"]},{"id":"customs","icon":"file-text","title":"跨境关务","sub":"Customs","desc":"关税多交了不知道，HS 归错被罚款。AI 自动归类 + 关税优化 + 合规风控，报关差错率从 5–10% 压至 2% 以下。","tags":["HS 智能归类","关税优化","单证 AI 审核","合规预警"]}]', 3),
('products', 'beyond-core', '供应链跑通了，把货卖好、把账算清', '六大模块管好货的流转，下面这两个帮你把货卖出去、把账算明白。',
 '[{"icon":"shuffle","title":"分销与供销商","sub":"Distribution Network","desc":"有好货缺渠道，有渠道缺好货——供销双方还在靠微信对接、手工对账，分账扯皮每周都在发生。品牌方上架分销池，经销商零库存选品，订单完成自动分账。一个人管 100+ 分销商不费力，窜货实时监控。","tags":["供销入驻","分销选品","自动分账","窜货监控"]},{"icon":"chart","title":"数据统计与报表中心","sub":"Analytics","desc":"数据散在采购、仓储、物流各系统，想看经营全貌得等各部门拉 Excel——等报表出来，问题可能已经发生了三天。所有数据汇成一块实时看板，直接打字问“哪个 SKU 毛利在降？”，AI 自动定位原因。不等报表，不用开会。","tags":["实时看板","自然语言问数","成本归集","预警中心"]}]', 4),
('products', 'ai-everywhere', '六个模块，六套 AI 在背后跑', '下 PO 自动比价，库存低了自动预警，航线断了自动推荐备选——AI 长在每个决策节点上。',
 '[{"icon":"cpu","title":"AI Copilot","sub":"Natural Language · Business Data","desc":"直接对接业务数据库，用自然语言提问。问“美西港罢工会影响我哪些货”，秒级给出受影响清单与建议。"},{"icon":"trending-up","title":"需求预测引擎","sub":"12+ Dimensions · Weekly Rolling","desc":"融合历史销量、搜索热度、季节因子、竞品价格等维度，按 SKU×区域×周滚动预测，跑在库存消耗前面。"},{"icon":"alert-triangle","title":"风险识别引擎","sub":"Trend Tracking · Early Signal","desc":"持续追踪交期、质量、价格的微小波动趋势，在恶化成事故前发出信号——不等固定阈值报警，提前替你察觉。"},{"icon":"dollar-sign","title":"TCO 优化引擎","sub":"Total Cost · Multi-Route Compare","desc":"报价看单价，AI 算全局——关税、运费、仓储、资金占用一起算。同一批货不同路线成本可差 15%，系统帮你定位。"},{"icon":"sliders","title":"排程仿真引擎","sub":"What-If Simulation · 12-Week Preview","desc":"输入促销计划、航线变化、供应商交期，系统跑完仿真告诉你瓶颈在哪。提前 12 周预演，留足调整时间。"},{"icon":"target","title":"决策推荐卡片","sub":"Multi-Option · Impact Analysis","desc":"每次报警附带 2–3 个可行方案，每个方案的花费、耗时、副作用一目了然——你只需选择，不用开会讨论。"}]', 5),
('products', 'cta', '想看这些模块怎么组合到你的业务场景？', '每个企业的供应链都不一样，去解决方案页查看不同场景的搭配方式。',
 '[{"text":"查看解决方案 →","href":"/solutions","primary":true}]', 6);

-- === 解决方案页 (solutions) ===
INSERT INTO page_sections (page, section, title, subtitle, items_json, sort_order) VALUES
('solutions', 'hero', '按场景精准匹配', '每个企业的供应链都不一样，方案也不该一样',
 '[{"icon":"globe","text":"跨境采购"},{"icon":"home","text":"海外仓"},{"icon":"send","text":"一件代发"},{"icon":"shuffle","text":"分销网络"}]', 1),
('solutions', 'scenarios', '按你的业务场景，找到对应方案', '不做大一统推荐，每个场景都有具体的落地路径。',
 '[{"id":"procure","tag":"跨境采购","tagClass":"tag-procure","title":"从寻源到 PO 签发，全程在系统里跑","desc":"不是找不到供应商，是不知道哪个靠谱、不确定关税会怎么变。多源比价 + 关税沙盘推演 + 自动跟单，PO 周期从 3–5 天缩至 1 天内。","items":["多源寻源，自动追踪供应商准时率与质量","关税 TCO 沙盘推演，报价背后费用全透明","快反补货，需求信号直达采购决策"],"img":"https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=1400&q=85"},{"id":"overseas","tag":"海外仓","tagClass":"tag-overseas","title":"多仓库存一盘棋，AI 告诉你该放哪、补多少","desc":"国内仓、海外仓、FBA、保税仓统一库存视图，AI 动态分配水位。放多了压资金，放少了断货——找到最优平衡点。","items":["多仓网络统一视图，库存水位一目了然","FBA 智能补货建议，避免断货与冗余","头程尾程全链路追踪，异常提前告警"],"img":"https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=1400&q=85"},{"id":"dropship","tag":"一件代发","tagClass":"tag-dropship","title":"零仓储测出爆款，跑通了再备货","desc":"新品测款、长尾 SKU、小批量试水——不是所有货都值得先囤到海外。包裹从国内仓直发消费者，自动匹配最优申报模式，试错成本降到最低。","items":["小包直邮，自动匹配 9610/9710/9810 模式","全程轨迹追踪，消费者端透明可见","测款数据回传，指导备货决策"],"img":"https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?auto=format&fit=crop&w=1400&q=85"},{"id":"distribution","tag":"分销网络","tagClass":"tag-distribution","title":"供销双方智能撮合，自动分账不扯皮","desc":"有好货的缺渠道，有渠道的缺好货。供销商上架分销池，分销商零库存选品，订单完成自动按比分账，一个人管 100+ 分销商不费力。","items":["双边撮合，供需智能匹配","订单完成自动分账，告别手工对账","分销等级 + 窜货监控，渠道秩序可控"],"img":"https://images.unsplash.com/photo-1556761175-b413da4baf72?auto=format&fit=crop&w=1400&q=85"}]', 2),
('solutions', 'fulfillment', '四种履约通道，OMS 自动匹配最优', '系统根据库存位置、渠道 SLA、物流成本与目的国，自动匹配最优通道。',
 '[{"badge":"A","title":"FBA 履约","sub":"Amazon Fulfillment","desc":"商品存 Amazon FBA 仓，全托管拣货配送。适合 Prime 标商品，平台做库存视图与补货决策。"},{"badge":"B","title":"第三方海外仓","sub":"3PL Warehouse","desc":"多平台统一库存发货，商家自管尾程。平台负责运单创建、比价、轨迹追踪与 POD 回传。"},{"badge":"C","title":"直邮 FBS/FBM","sub":"Direct Mail","desc":"国内仓直发国际快递至海外消费者。适合小件、低频、长尾 SKU 与测试期新品。"},{"badge":"D","title":"保税备货","sub":"Bonded Warehouse","desc":"批量入境内保税仓，下单后清关发货。1–3 天妥投，单件物流成本比直邮低 30–40%。"}]', 3),
('solutions', 'stages', '按成长阶段，选择适配组合', '没有放之四海皆准的方案。结合跨境企业的出口实践，我们把履约选型归纳为三个成长阶段（单量数字仅供参考）。',
 '[{"icon":"seed","title":"初创试水期","sub":"月单量 < 2,000 · SKU 多而散","desc":"国内仓直邮 + 少量 FBA 试款，用最小成本测出真实需求，再决定加码方向。","tags":["直邮为主","小批量试款","需求验证"]},{"icon":"rocket","title":"增长扩张期","sub":"月单量 2,000–20,000 · 爆款显现","desc":"FBA 保 Prime 时效 + 海外仓压成本，双仓并行，AI 需求预测驱动补货节奏。","tags":["FBA + 海外仓","智能补货","防断货积压"]},{"icon":"mountain","title":"成熟规模期","sub":"月单量 > 20,000 · 多区域多渠道","desc":"多国区域仓 + 多源供应 + 弹性路由，构建韧性网络，控制塔做全局最优决策。","tags":["区域仓网络","多源采购","控制塔"]},{"icon":"import","title":"做进口？优先「保税备货」","sub":"IMPORT · 进口方向","desc":"若你把海外品牌货卖给中国消费者，建议「保税仓批量备货 + 清单核放、汇总申报」：批量海运入境内保税仓，下单后单件清关发货，1–3 天极速妥投、单件物流成本比直邮低 30–40%，适合奶粉、美妆、母婴等高复购品类；小众长尾则用 9610 直邮测款。","tags":["保税仓备货","清单核放","9610 直邮测款"]}]', 4),
('solutions', 'perspectives', '关于跨境供应链的几点观点', '并非每条“行业常识”都成立。以下是我们结合实践，对几个常见问题的看法。',
 '[{"icon":"zap","title":"不建议过度依赖 FBA","desc":"FBA 时效有优势，但平台规则、仓储费与封号风险都不在自己手中。把核心库存放在自有 / 海外仓，用 FBA 承接 Prime 流量，主动权更可控。"},{"icon":"scale","title":"库存不是越少越好","desc":"盲目压库存，是用断货换“账面好看”。真正该优化的是「服务水平 vs 持有成本」的平衡点——这正是动态安全库存模型存在的意义。"},{"icon":"send","title":"直邮的价值常被低估","desc":"不少人把直邮当低端备选，其实它是低成本的试款方式：零仓储、上架快、下架快。新品先用直邮验证，跑通后再海运备货，可有效降低试错成本。"},{"icon":"shield","title":"韧性正变得和效率一样重要","desc":"过去十年供应链追求极致效率，但一次断链就可能让全盘受损。后疫情时代，能否在扰动中快速重组，正变得和效率同样关键。"}]', 5),
('solutions', 'outcomes', '典型场景下的目标成效', '以下为典型业务场景的目标改善示意，帮助你预估价值，非特定客户真实数据。',
 '[{"metric":"70% → 93%","label":"采购准时交付率","desc":"通过多源采购 + AI 需求预测，缓解单一供应商依赖问题。","scene":"典型场景 · 跨境品牌商"},{"metric":"90 → 55 天","label":"库存周转天数","desc":"智能补货 + 动态安全库存策略，降低呆滞库存占比。","scene":"典型场景 · 海外仓运营商"},{"metric":"2–5 天 → 4 小时","label":"异常事件响应时间","desc":"实时轨迹追踪 + 自动异常预警，从被动应对到主动管控。","scene":"典型场景 · 跨境物流商"}]', 6),
('solutions', 'cta', '想了解这些场景背后的行业挑战？', '每个业务场景背后，都是地缘、政策、供需等宏观挑战在驱动。看清全局，方案才落得住。',
 '[{"text":"查看八大痛点与对策 →","href":"/pain-points","primary":false}]', 7);

-- === 为什么选我们页 (why-us) ===
INSERT INTO page_sections (page, section, title, subtitle, items_json, sort_order) VALUES
('why-us', 'hero', '为什么选择我们', '两种模式，关键指标摊开来看',
 '[{"icon":"chart","text":"数据驱动"},{"icon":"cpu","text":"AI 赋能"},{"icon":"trending-up","text":"持续降本"}]', 1),
('why-us', 'comparison', '传统经验 vs AI 数据驱动', '七个关键指标，两种模式的表现对比。',
 '{"old":{"title":"经验驱动模式","rows":[{"metric":"采购计划准确率","value":"60–70%（人工估算）"},{"metric":"PO 处理周期","value":"3–5 天（邮件 / Excel）"},{"metric":"库存周转天数","value":"90–120 天"},{"metric":"异常响应时间","value":"2–5 天（人工发现）"},{"metric":"报关差错率","value":"5–10%"},{"metric":"端到端可视性","value":"多系统拼凑，耗时数天"},{"metric":"决策方式","value":"Excel + 经验直觉"}]},"new":{"title":"AI 数据驱动模式","rows":[{"metric":"采购计划准确率","value":"≥ 90%（AI 预测驱动）"},{"metric":"PO 处理周期","value":"≤ 1 天（系统协同）"},{"metric":"库存周转天数","value":"≤ 55 天"},{"metric":"异常响应时间","value":"≤ 4 小时（自动预警）"},{"metric":"报关差错率","value":"≤ 2%（AI 辅助归类）"},{"metric":"端到端可视性","value":"秒级控制塔，一图掌控"},{"metric":"决策方式","value":"AI 数据驱动 + 量化推演"}]},"savings":[{"value":"-32%","label":"库存成本"},{"value":"-25%","label":"物流成本"},{"value":"-45%","label":"关务罚款"},{"value":"-60%","label":"人工工时"}]}', 2),
('why-us', 'copilot', '认识您的供应链大脑', '预测需求、响应中断、做出更聪明的决策 —— 全部通过一个 7×24 在线的 AI Copilot。',
 '[{"num":"01","phase":"PREDICT · 预测","title":"90%+ 准确率的需求预测","desc":"融合历史销量、搜索热度、季节因子、竞品价格等 12+ 维度数据，按 SKU × 区域 × 周粒度滚动输出，告别拍脑袋备货。","chat":[{"role":"user","text":"SKU-8892 库存不多了，什么时候该补货？"},{"role":"ai","text":"在手 42 件，在途 200 件（ETA 6/8）。近 30 天日均消耗 15 件，动态安全库存 60 件。⚠️ 存在约 8 天断货窗口，建议立即紧急补货 200 件，或从杭州仓调拨 120 件（成本更低）。"}]},{"num":"02","phase":"RESPOND · 响应","title":"从数天，到数小时","desc":"台风路径 ∩ 您的在途柜子 → 自动匹配受影响运单 → 推送替代方案 → 一键切换。异常响应从传统 2–5 天缩短到 4 小时以内。","chat":[{"role":"user","text":"美西长滩港是不是有罢工？会影响我哪些货？"},{"role":"ai","text":"已确认长滩港自 5/26 起罢工。您受影响在途运单共 12 票：3 票已到港待卸（滞港费 ~$1,200/天），5 票 3 天内到达。🟡 建议 5 票申请改港至奥克兰，规避滞港风险。要我生成改港申请草稿吗？"}]},{"num":"03","phase":"DECIDE · 决策","title":"不只是预警，更是可执行的选择","desc":"系统不仅报警，更给出 2–3 个推荐方案及量化影响：方案 A 切换备选供应商 +8% 成本；方案 B 空运补货 +15% 成本但缩短 20 天 —— 您只需要选择。","chat":[{"role":"ai","text":"检测到供应商 A 交期持续恶化（28 → 31 → 35 天）。📋 方案 A：切换备选供应商 X，成本 +8%，交期不变。📋 方案 B：部分空运补货，成本 +15%，缩短 20 天。🟢 推荐方案 A。要我帮您执行 PO 变更并通知双方吗？"},{"role":"user","text":"执行方案 A。"}]},{"num":"04","phase":"EXECUTE · 执行","title":"一键下发，全链路自动执行","desc":"决策一旦确认，PO 变更、运单改港、库存调拨自动下发至对应系统，无需跨部门邮件沟通。执行结果实时回传，若偏差超出阈值自动触发二次预警。","chat":[{"role":"ai","text":"✅ PO-7742 已切换至供应商 X，新交期 6/18。✅ 供应商 A 已收到暂停通知。✅ 杭州仓调拨单已生成，预计 6/8 到达。📊 所有变更已同步至控制塔，异常偏差超过 5% 会自动提醒。"}]}]', 3),
('why-us', 'difference', '六个维度，做出区别', '不是功能清单的比拼，而是底层架构和产品理念的差异。',
 '[{"icon":"globe","title":"内置全球情报感知","sub":"Global Intelligence Layer","desc":"不只是流程数字化，更在流程之上叠加一层实时情报：政策、关税、台风、罢工自动关联到具体货物，提前预警而非事后补救。"},{"icon":"link","title":"统一数据底座","sub":"Unified Data Foundation","desc":"采购、仓储、物流、订单、关务共用同一套主数据，一个 SKU 全链路 ID 一致。从 PO 到 POD，一键追溯、秒级定位。"},{"icon":"trending-up","title":"可量化的目标","sub":"Measurable Outcomes","desc":"不做空泛承诺：采购准时率 ≥ 93%、库存周转 ≤ 55 天、异常响应 ≤ 4 小时。先验证、再扩展，可演示、可试用。"},{"icon":"cpu","title":"AI 贯穿全链路","sub":"AI Everywhere","desc":"AI 不独立打包，长在每个决策节点上。下 PO 自动比价、库存低了自动预警、航线断了自动推荐备选——无需手动触发。"},{"icon":"shield","title":"弹性供应网络","sub":"Resilient Network","desc":"多源采购 + 多枢纽物流 + 弹性路由。单点断供数小时内重组链路，不把鸡蛋放在一个篮子里。"},{"icon":"zap","title":"快速落地验证","sub":"Rapid Deployment","desc":"模块化设计，先从一个场景切入，数周内看到效果再扩展。不是动辄 12 个月的笨重部署。"}]', 4);

-- === 全球情报页 (intel) ===
INSERT INTO page_sections (page, section, title, subtitle, items_json, sort_order) VALUES
('intel', 'hero', '全球情报要闻', '实时追踪政策、关税、地缘与物流动态',
 '[{"icon":"file-text","text":"政策速递"},{"icon":"globe","text":"地缘观察"},{"icon":"truck","text":"物流快报"}]', 1),
('intel', 'news-groups', NULL, NULL,
 '[{"group":"地缘冲突","icon":"globe","articles":[{"title":"黑海出口走廊再遇袭，俄无人机击中三艘外籍商船","summary":"乌克兰粮食与金属外运走廊安全告急，袭击或推高全球粮价，非洲、中东、亚洲进口国首当其冲。","cat":"war","meta":"Modern Diplomacy · 5 小时前","img":"https://images.unsplash.com/photo-1494412651409-8963ce7935a7?auto=format&fit=crop&w=900&q=75","href":"news-blacksea.html"},{"title":"乌克兰“物流封锁”战：年内击中 15 座俄炼油厂","summary":"1–5 月乌方打击 15 座炼油厂，约四成俄炼油产能离线，克里米亚燃油配给，俄已限制成品油出口。","cat":"war","meta":"Kyiv Independent · 8 小时前","img":"https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=900&q=75","href":"news-ukraine.html"},{"title":"战争险重定价：中东冲突推高海运保险，承保人撤出海湾","summary":"多家 P&I 俱乐部 72 小时内取消海湾战争险承保，西方船舶保费升至船价数个百分点，成本沿全链路传导。","cat":"war","meta":"Insurance Business · 今日","img":"https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=900&q=75","href":"news-mideast.html"}]},{"group":"交通物流","icon":"truck","articles":[{"title":"红海危机延续：主力班轮默认绕行好望角","summary":"CMA CGM、马士基等已把好望角作为亚欧默认航线，单程增加 10–14 天、燃油上升约 30%，每箱附加费 500–1,500 美元。","cat":"logi","meta":"Reuters · 海运 · 今日","img":"https://images.unsplash.com/photo-1605745341112-85968b19335b?auto=format&fit=crop&w=900&q=75","href":"news-redsea.html"},{"title":"霍尔木兹海峡紧张加剧，全球石油运输咽喉告急","summary":"伊朗革命卫队扣押多艘商船，海上战争险飙升，若海峡封锁全球约两成石油海运将中断。","cat":"energy","meta":"Bloomberg · 能源 · 今日","img":"https://images.unsplash.com/photo-1606964212858-c215029db704?auto=format&fit=crop&w=900&q=75","href":"news-hormuz.html"},{"title":"巴拿马运河持续限航，亚洲—美东航线承压","summary":"加通湖水位持续偏低，每日通行量较正常减少约四成，部分班轮被迫改道苏伊士或绕行好望角。","cat":"logi","meta":"El Faro · 物流 · 今日","img":"https://images.unsplash.com/photo-1504892611385-e10d7248b5a5?auto=format&fit=crop&w=900&q=75","href":"news-panama.html"}]},{"group":"贸易政策","icon":"file-text","articles":[{"title":"美国 Section 232 金属关税扩围至铜，最高 50%","summary":"美国商务部以国家安全为由启动对进口铜及铜制品的 232 条款调查，初步建议税率 25–50%。","cat":"policy","meta":"Baker Tilly · 今日","img":"https://images.unsplash.com/photo-1450101499163-c8848c66ca85?auto=format&fit=crop&w=900&q=75","href":"news-tariff.html"},{"title":"美国对华关税再升级：Section 301 清单扩至新能源","summary":"USTR 发布新的 301 条款排除清单修订，新增光伏逆变器等品类，中国商务部强烈反对。","cat":"policy","meta":"Reuters · 贸易 · 今日","img":"https://images.unsplash.com/photo-1681505531034-8d67054e07f6?auto=format&fit=crop&w=900&q=75","href":"news-export-control.html"},{"title":"欧盟碳边境调节机制（CBAM）进入正式期","summary":"2026 年起进口商须按季申报隐含碳排放并清缴 CBAM 证书，首批覆盖钢铁、铝、水泥、化肥、电力、氢。","cat":"policy","meta":"European Commission · 政策","img":"https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=900&q=75","href":"news-cbam.html"},{"title":"欧盟数字产品护照新规将落地，供应链溯源要求升级","summary":"2026 年起多类产品须附数字护照方可入欧，打通从原料到终端全链数据成为刚性需求。","cat":"policy","meta":"European Parliament · 法规","img":"https://images.unsplash.com/photo-1587293852726-70cdb56c2866?auto=format&fit=crop&w=900&q=75","href":"news-eu-border.html"},{"title":"美国 Section 122 调查瞄准半导体供应链","summary":"美商务部依 Section 122 对半导体供应链启动国家安全影响调查，评估晶圆制造、封测环节的海外依赖风险。","cat":"policy","meta":"US Commerce Dept. · 半导体","img":"https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=900&q=75","href":"news-section122.html"},{"title":"中国对稀土出口实施管制，11 月 10 日大限将至","summary":"商务部加强对17种稀土元素的出口管制，包括镝、铽等，引发全球供应链紧张，担忧扩展到其他领域。","cat":"policy","meta":"TechTimes · 3 小时前","img":"https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=900&q=75","href":"news-rareearth.html"},{"title":"USMCA 日落审查启动：美墨加贸易协定面临重新谈判","summary":"USMCA 联合审查将于 2026 年 7 月 1 日启动，涉及汽车原产地规则、劳工条款与数字贸易章节，北美供应链面临变数。","cat":"policy","meta":"CBC News · 北美","img":"https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=900&q=75","href":"news-usmca.html"}]},{"group":"能源与供应链安全","icon":"alert-triangle","articles":[{"title":"欧盟 CBAM 碳边境机制进入正式期，进口商须清缴碳证","summary":"2026 年起钢铁、铝、水泥、化肥、电力、氢六类产品进口须按季申报碳排放并清缴 CBAM 证书，过渡期结束。","cat":"energy","meta":"European Commission · 2 天前","img":"https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=900&q=75","href":"news-cbam.html"},{"title":"中国对美加征报复性关税，原料药与精细化工首当其冲","summary":"商务部宣布对原产于美国的部分化工品、原料药加征关税，涉及医药与精细化工供应链。","cat":"policy","meta":"Bloomberg · 化工","img":"https://images.unsplash.com/photo-1532187863486-af6f0b3b6e9e?auto=format&fit=crop&w=900&q=75","href":"news-pharma.html"}]}]', 2);

-- === 联系我们页 (contact) ===
INSERT INTO page_sections (page, section, title, subtitle, items_json, sort_order) VALUES
('contact', 'hero', '和我们聊聊您的供应链', '填写右侧表单或邮件联系，我们将在 24 小时内回复，并结合您的真实场景给出建议。',
 '[]', 1),
('contact', 'offices', NULL, NULL,
 '[{"city":"英国牛津","role":"全球营运总部","address":"Oxford, UK","desc":"战略规划 · 全球客户 · AI 研发"},{"city":"新加坡","role":"亚太总部","address":"Singapore","desc":"东南亚市场 · 跨境物流枢纽"},{"city":"中国香港","role":"亚洲营运中心","address":"Hong Kong","desc":"大湾区连接 · 金融结算 · 转口贸易"},{"city":"马来西亚","role":"东南亚交付中心","address":"Malaysia","desc":"共享服务中心 · 多语言支持"}]', 2);

-- === 痛点与方案页 (pain-points) ===
INSERT INTO page_sections (page, section, title, subtitle, items_json, sort_order) VALUES
('pain-points', 'hero', '供应链的八道坎', '从宏观环境到企业运营，逐一拆解',
 '[{"icon":"globe","text":"地缘"},{"icon":"list","text":"政策"},{"icon":"chart","text":"需求"},{"icon":"link","text":"供应"}]', 1),
('pain-points', 'preview', '这些困扰，每天都在发生', '四个最常见的供应链痛点，完整拆解见下方。',
 '[{"icon":"globe","title":"脱钩断供","sub":"Decoupling Risk","desc":"关键航线一夜关闭，在途货物滞留，关税突变利润由正转负。"},{"icon":"chart","title":"信息孤岛","sub":"Data Silos","desc":"数据散落 5 个系统，翻找数天才拼出全貌，早已错过应对窗口。"},{"icon":"dollar-sign","title":"成本失控","sub":"Cost Out of Control","desc":"20+ 项隐性附加费难以比价，“看起来便宜”的报价实际更贵。"},{"icon":"clock","title":"响应迟缓","sub":"Slow Response","desc":"异常发生 3 天后才知道哪些货受影响，损失已经造成。"}]', 2);

-- -------------------------------------------------------
-- 6. 新闻文章
-- -------------------------------------------------------
INSERT INTO articles (id, title, summary, category, cover_img, source, meta, status, published_at) VALUES
(1,  '红海危机延续：主力班轮默认绕行好望角',
     'CMA CGM、马士基等已把好望角作为亚欧默认航线，单程增加 10–14 天、燃油上升约 30%，每箱附加费 500–1,500 美元。',
     'logi', 'https://images.unsplash.com/photo-1605745341112-85968b19335b?auto=format&fit=crop&w=1600&q=75',
     'Reuters', 'Reuters · Container News · 海运 · 今日', 'published', NOW()),
(2,  '乌克兰”物流封锁”战：年内击中 15 座俄炼油厂',
     '1–5 月乌方打击 15 座炼油厂，约四成俄炼油产能离线，克里米亚燃油配给，俄已限制成品油出口。',
     'war', 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=1600&q=75',
     'Kyiv Independent', 'Kyiv Independent · 地缘 · 8 小时前', 'published', NOW()),
(3,  '战争险重定价：中东冲突推高海运保险，承保人撤出海湾',
     '多家 P&I 俱乐部 72 小时内取消海湾战争险承保，西方船舶保费升至船价数个百分点，成本沿全链路传导。',
     'war', 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=1600&q=75',
     'Insurance Business', 'Insurance Business · 海运 · 今日', 'published', NOW()),
(4,  '黑海出口走廊再遇袭，俄无人机击中三艘外籍商船',
     '乌克兰粮食与金属外运走廊安全告急，袭击或推高全球粮价，非洲、中东、亚洲进口国首当其冲。',
     'war', 'https://images.unsplash.com/photo-1494412651409-8963ce7935a7?auto=format&fit=crop&w=1600&q=75',
     'Modern Diplomacy', 'Modern Diplomacy · 黑海 · 5 小时前', 'published', NOW()),
(5,  '霍尔木兹海峡紧张加剧，全球石油运输咽喉告急',
     '伊朗革命卫队扣押多艘商船，海上战争险飙升，若海峡封锁全球约两成石油海运将中断。',
     'energy', 'https://images.unsplash.com/photo-1606964212858-c215029db704?auto=format&fit=crop&w=1600&q=75',
     'Bloomberg', 'Bloomberg · 能源 · 今日', 'published', NOW()),
(6,  '巴拿马运河持续限航，亚洲—美东航线承压',
     '加通湖水位持续偏低，每日通行量较正常减少约四成，部分班轮被迫改道苏伊士或绕行好望角。',
     'logi', 'https://images.unsplash.com/photo-1504892611385-e10d7248b5a5?auto=format&fit=crop&w=1600&q=75',
     'El Faro', 'El Faro · 物流 · 今日', 'published', NOW()),
(7,  '美国 Section 232 金属关税扩围至铜，最高 50%',
     '美国商务部以国家安全为由启动对进口铜及铜制品的 232 条款调查，初步建议税率 25–50%。',
     'policy', 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?auto=format&fit=crop&w=1600&q=75',
     'Baker Tilly', 'Baker Tilly · NatLawReview · 关税 · 今日', 'published', NOW()),
(8,  '美国对华关税再升级：Section 301 清单扩至新能源',
     'USTR 发布新的 301 条款排除清单修订，新增光伏逆变器等品类，中国商务部强烈反对。',
     'policy', 'https://images.unsplash.com/photo-1681505531034-8d67054e07f6?auto=format&fit=crop&w=1600&q=75',
     'Reuters', 'Reuters · 贸易 · 今日', 'published', NOW()),
(9,  '欧盟碳边境调节机制（CBAM）进入正式期',
     '2026 年起进口商须按季申报隐含碳排放并清缴 CBAM 证书，首批覆盖钢铁、铝、水泥、化肥、电力、氢。',
     'energy', 'https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?auto=format&fit=crop&w=1600&q=75',
     'European Commission', 'European Commission · 政策 · 2 天前', 'published', NOW()),
(10, '欧盟数字产品护照新规将落地，供应链溯源要求升级',
     '2026 年起多类产品须附数字护照方可入欧，打通从原料到终端全链数据成为刚性需求。',
     'policy', 'https://images.unsplash.com/photo-1587293852726-70cdb56c2866?auto=format&fit=crop&w=1600&q=75',
     'European Parliament', 'European Parliament · 法规 · 3 天前', 'published', NOW()),
(11, '美国 Section 122 调查瞄准半导体供应链',
     '美商务部依 Section 122 对半导体供应链启动国家安全影响调查，评估晶圆制造、封测环节的海外依赖风险。',
     'policy', 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1600&q=75',
     'US Commerce Dept.', 'US Commerce Dept. · 半导体 · 今日', 'published', NOW()),
(12, '中国对稀土出口实施管制，11 月 10 日大限将至',
     '商务部加强对17种稀土元素的出口管制，包括镝、铽等，引发全球供应链紧张，担忧扩展到其他领域。',
     'policy', 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1600&q=75',
     'TechTimes', 'TechTimes · 稀土 · 3 小时前', 'published', NOW()),
(13, 'USMCA 日落审查启动：美墨加贸易协定面临重新谈判',
     'USMCA 联合审查将于 2026 年 7 月 1 日启动，涉及汽车原产地规则、劳工条款与数字贸易章节，北美供应链面临变数。',
     'policy', 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&w=1600&q=75',
     'CBC News', 'CBC News · 北美 · 今日', 'published', NOW()),
(14, '中国对美加征报复性关税，原料药与精细化工首当其冲',
     '商务部宣布对原产于美国的部分化工品、原料药加征关税，涉及医药与精细化工供应链。',
     'policy', 'https://images.unsplash.com/photo-1532187863486-af6f0b3b6e9e?auto=format&fit=crop&w=1600&q=75',
     'Bloomberg', 'Bloomberg · 化工 · 2 天前', 'published', NOW());

-- -------------------------------------------------------
-- 7. 文章内容块
-- -------------------------------------------------------
INSERT INTO article_blocks (article_id, block_type, content, sort_order) VALUES
-- 1. 红海危机
(1, 'kt', '胡塞袭扰常态化，好望角成为亚欧默认航线，苏伊士仅对获豁免船旗保留可选性\n单程增加约 3,000–3,500 海里、10–14 天航程\n每段燃油消耗上升约 30%，单航次额外成本约 100 万美元\n承运人加收 500–1,500 美元/箱过境附加费\n2026 年 2 月 ME11 航线试探性恢复经苏伊士，但仍属高风险例外', 1),
(1, 'lead', '截至 2026 年年中，胡塞武装对红海航运的袭扰已从突发事件固化为结构性现实，全球主力班轮把绕行好望角作为亚欧贸易的默认路线。', 2),
(1, 'p', '自 2023 年底以来，也门胡塞武装持续袭击红海与曼德海峡过境船舶。进入 2026 年，CMA CGM、马士基等主要承运人已将绕行非洲好望角确立为亚欧与亚洲—美东航线的默认方案，苏伊士运河仅对少数获豁免船旗的航次保留可选性。', 3),
(1, 'quote', '承运人正从”战术性避让”转向”战略性重构网络”——这意味着红海的不稳定将持续影响未来数个季度的供应链规划。', 4),
(1, 'p', '绕行好望角使亚欧单程增加约 3,000–3,500 海里、10–14 天航程，每段燃油消耗上升约 30%，单航次额外成本约 100 万美元。承运人普遍加收 500–1,500 美元/箱的过境附加费，并通过运力重排与班期重设来吸收延误。', 5),
(1, 'p', '对汽车、电子、快消等时效敏感行业，这意味着必须重新评估库存布局、安全库存与供应商多元化策略。部分货主已转向跨太平洋至美西 + 内陆铁路、经迪拜 / 新加坡的海空联运，或 18–22 天的中欧班列作为替代路径。', 6),
(1, 'quote', '在不确定的航运环境中，弹性路由与动态安全库存，正从”可选项”变成”必需品”。', 7),
(1, 'p', '行业普遍预期红海绕行至少持续到 2027 年——即便袭击频率下降，保险市场仍会维持高企的战争险溢价。供应链团队应将”航程延长”假设固化进计划，并把”异常触发 → 智能改道”纳入标准流程，而非临时救火。', 8),
-- 2. 乌克兰炼油厂
(2, 'kt', '1–5 月乌方打击 15 座俄炼油厂\n约四成俄炼油产能离线\n克里米亚燃油配给，俄已限制成品油出口\n无人机远程打击改变冲突格局', 1),
(2, 'lead', '乌克兰正将”物流封锁”作为战略工具，年内对俄炼油厂发动系统性打击，全球能源供应链受到持续扰动。', 2),
(2, 'p', '2026 年 1–5 月，乌克兰军方运用无人机对俄罗斯纵深炼油设施发动系统性打击，累计击中 15 座炼油厂。约四成俄炼油产能在打击后离线或降负荷运行，克里米亚地区已实施燃油配给制度，俄政府亦正式限制了成品油出口。', 3),
(2, 'quote', '战争形态正从”前线消耗”转向”供应链瘫痪”——工业产能、仓储与输配网络已成为战略打击目标。', 4),
(2, 'p', '炼油产能受损对全球成品油市场的传导路径清晰：俄方为保国内供应而压缩出口，推高国际柴油与汽油基差。亚洲买家被迫从更远的中东与印度采购，抬升吨海里需求与运费。', 5),
(2, 'p', '企业应将能源运输路线的稳定性、替代燃料方案及库存缓冲纳入供应链风险管理框架，尤其对依赖俄油或经黑海转运的品类。', 6),
-- 3. 中东战争险
(3, 'kt', '多家 P&I 俱乐部 72 小时内取消海湾战争险承保\n西方船舶保费升至船价数个百分点\n中东冲突持续扰动全球能源与航运格局', 1),
(3, 'lead', '中东地缘冲突烈度持续升级，多家保赔协会大幅收紧海湾地区战争险承保，全球海运保险与能源运输面临结构性重定价。', 2),
(3, 'p', '受伊朗革命卫队扣押多艘商船及也门胡塞武装持续攻击红海航运影响，多家 P&I 俱乐部在近期 72 小时内取消对海湾及部分中东水域的战争险承保。西方旗船舶保费已升至船价的数个百分点，部分船东选择绕行非洲南部以规避风险。', 3),
(3, 'quote', '当”可保性”本身成为问题，海运合同的履约基础就动摇了——这是比运价波动更根本的风险。', 4),
(3, 'p', '战争险保费的激增沿全链路传导：船东→承运人→货主→终端消费者。同时，货物保险条款中的战争排除条款也被更频繁地激活，进口商可能面临货物已发货但保险不覆盖的风险敞口。', 5),
(3, 'p', '建议贸易商与物流商审阅现有货运保险条款、与货代确认承运人保险状态，并评估替代路线与多式联运方案的可行性与成本变化。', 6),
-- 4. 黑海走廊
(4, 'kt', '俄无人机袭击三艘途经黑海出口走廊的外籍商船（5 月底）\n船上起火，船员自行扑灭\n走廊承运乌克兰粮食、金属与农产品外运\n战时临时民用走廊成本高、安全难以保障\n袭击或推高全球粮价，非洲、中东、亚洲进口国受冲击', 1),
(4, 'lead', '乌克兰指认俄罗斯于 5 月底对途经黑海出口走廊的三艘外籍商船发动无人机袭击，全球关键的粮食与能源运输通道安全再度告急。', 2),
(4, 'p', '据乌克兰副总理库列巴，袭击发生在周四深夜至次日凌晨，三艘行驶在粮食与出口贸易航线上的外籍商船遭无人机攻击并起火，船员自行将火扑灭。黑海走廊对全球粮食供应、能源运输与国际贸易至关重要。', 3),
(4, 'quote', '当军事行动、经济战与国际贸易利益日益重叠，商船便成了最脆弱的前线。', 4),
(4, 'p', '乌克兰高度依赖海运出口维持战时经济，尤其是粮食、金属与农产品。俄方反复打击港口、仓储与航运通道，已多次扰乱出口并威胁全球供应链。2023 年俄退出”黑海粮食协议”后，乌方于当年 8 月开辟临时民用船舶走廊以维持外运。', 5),
(4, 'p', '黑海贸易中断的影响远超乌克兰本身——它直接传导至全球粮价、大宗商品市场与供应链，尤其冲击高度依赖乌克兰粮食的非洲、中东与亚洲部分地区。', 6),
(4, 'quote', '粮食安全是供应链韧性最敏感的一环；一条走廊的安危，牵动数十个进口国的餐桌。', 7),
(4, 'p', '对采购与贸易企业而言，应将黑海走廊的不确定性纳入大宗采购的情景规划：分散粮源、密切跟踪战争险与航运保险变动、并在高波动窗口预留缓冲库存与替代供应方案。', 8),
-- 5. 霍尔木兹海峡
(5, 'kt', '伊朗革命卫队扣押多艘过境商船\n海上战争险费率暴涨\n若海峡封锁，全球约两成石油海运将中断\n备选路线有限且成本极高', 1),
(5, 'lead', '霍尔木兹海峡紧张局势急剧升级，伊朗革命卫队频繁扣押商船，全球石油运输最关键的”咽喉”面临结构性风险。', 2),
(5, 'p', '近期伊朗革命卫队在霍尔木兹海峡及周边水域扣押多艘商船，声称其违反海事法规。海上战争险费率随之暴涨，多条航次的保险成本从数千美元飙升至数十万美元级别。', 3),
(5, 'quote', '霍尔木兹海峡的脆弱性不在于”是否会封锁”，而在于市场对封锁预期的自我实现——恐慌本身足以扭曲运价与库存。', 4),
(5, 'p', '霍尔木兹海峡每日通过约两成的全球石油海运量，包括原油与成品油。一旦封锁，中东至亚洲、欧洲的海运石油将被迫绕行非洲好望角或经有限替代管道，吨海里需求将飙升并推高全球能源成本。', 5),
(5, 'p', '建议石油贸易商与消费企业评估霍尔木兹风险对自身油品供应与定价的潜在影响，建立多源供应与缓冲库存机制，并持续跟踪海军护航与保险市场动态。', 6),
-- 6. 巴拿马运河
(6, 'kt', '加通湖水位持续偏低\n每日通行量较正常减少约四成\n部分班轮被迫改道苏伊士或绕行好望角\n亚洲—美东航线时间与成本双升', 1),
(6, 'lead', '巴拿马运河因持续干旱导致的低水位限制短期内无法解除，亚洲至美东航线的物流格局正在被重塑。', 2),
(6, 'p', '巴拿马运河流域近两年降水持续偏少，加通湖水位难以恢复至正常水平。运河管理局虽通过节水措施维持运营，但每日允许通过的船舶数量仍较正常时期减少约四成，且限吃水深度常态化。', 3),
(6, 'quote', '运河不是开关——当水位限制成为新常态，供应链需要的是路线多样化，而非等待一场大雨。', 4),
(6, 'p', '亚洲—美东航线受运河限航影响最明显：部分班轮改道苏伊士运河（又面临红海风险），或绕行好望角从而增加约 2 周航程。运费上升叠加时效变慢，对零售、汽车与电子等行业的库存策略构成持续压力。', 5),
(6, 'p', '物流团队应把运河限航纳入年度运输计划的情景假设，评估美西港口 + 内陆铁路的替代方案的成本与时效，并在关键旺季提前预留运力与缓冲库存。', 6),
-- 7. Section 232 金属关税
(7, 'kt', '4 月 2 日总统公告、4 月 6 日生效，将铜及衍生品纳入 232\n钢/铝/铜主金属按全额征 50%\n衍生品按全额征 25%；金属密集型工业、电网设备 15%（至 2027）\n境外但完全使用美国金属制造的产品征 10%\n金属占比 ≤15% 的产品不再受 232 约束', 1),
(7, 'lead', '美国 2026 年 4 月对 Section 232 金属关税进行重大重构，将铜纳入并按全额征税，重塑金属及含金属制成品的进口成本与产地选择。', 2),
(7, 'p', '依据 4 月 2 日总统公告（4 月 6 日生效），钢、铝、铜及其衍生品按全额海关价值征税：主金属（如钢卷、铝板）50%，实质性由这些金属构成的衍生品 25%，金属密集型工业设备与电网设备 15%（至 2027 年），境外但完全使用美国金属制造的产品 10%。', 3),
(7, 'quote', '关税不是单一数字，而是牵动产地、供应商与定价的连锁变量——越早量化，越主动。', 4),
(7, 'p', '与此前按季度增列衍生品的做法不同，新框架终止了季度增列流程、设立产品分组与分档税率，并把金属占比 ≤15% 的产品移出 232 覆盖。这提升了可预期性，但也要求企业精确核算每个 SKU 的金属构成与原产地。', 5),
(7, 'p', '据公开口径，2026 年 4 月美国平均有效关税率约为 11.8%，金属、含金属制品与车辆受影响最深。对采购团队而言，关键是把税则映射到自身物料清单：哪些 HS 编码受影响、税率几何、是否存在可替代产地。', 6),
(7, 'quote', '真正省钱的，不是单价最低的报价，而是把关税、物流与合规算进去后总成本最优的方案。', 7),
(7, 'p', '建议企业用”关税沙盘”在 PO 创建时自动拉取目的国 HS 税率，做多产地 TCO 比价，并对受影响合同重审价格条款；同时关注 7 月 1 日 USMCA 联合复审等关键节点对供应链布局的潜在影响。', 8),
-- 8. Section 301 新能源
(8, 'kt', 'USTR 发布新的 301 条款排除清单修订\n新增光伏逆变器等新能源品类\n中国商务部强烈反对\n新能源供应链面临关税不确定性', 1),
(8, 'lead', '美国贸易代表办公室（USTR）对 Section 301 关税排除清单进行新一轮修订，将光伏逆变器等新能源品类纳入加税范围，中美贸易摩擦进一步延伸至绿色经济领域。', 2),
(8, 'p', 'USTR 最新发布的 301 条款排除清单修订中，新增光伏逆变器、储能电池管理系统等品类，同时维持对部分传统品类的高关税。中国商务部随即发表声明强烈反对，称此举损害全球清洁能源供应链的稳定性。', 3),
(8, 'quote', '当关税从传统制造业蔓延至新能源，它就不再只是贸易政策——而是影响全球脱碳节奏的变量。', 4),
(8, 'p', '对新能源设备进口商与项目开发商而言，关税变化直接影响设备采购成本与项目经济性。建议在项目报价与采购合同中加入关税变动条款，并评估从东南亚、墨西哥等不受 301 影响的产地替代采购的可行性。', 5),
-- 9. CBAM 碳边境
(9, 'kt', '2026 年起进口商须按季申报隐含碳排放并清缴 CBAM 证书\n首批覆盖钢铁、铝、水泥、化肥、电力、氢\n过渡期结束，进入正式执行阶段\n碳成本成为跨境贸易新变量', 1),
(9, 'lead', '欧盟碳边境调节机制（CBAM）于 2026 年正式进入执行阶段，进口商须按季申报碳排放并清缴 CBAM 证书，碳成本成为对欧贸易的新刚性变量。', 2),
(9, 'p', '经过 2023–2025 年的三年过渡期，CBAM 自 2026 年起进入正式执行阶段。首批覆盖六类产品——钢铁、铝、水泥、化肥、电力与氢——进口商须按季申报产品的隐含碳排放量，并清缴相应数量的 CBAM 证书。', 3),
(9, 'quote', '碳不是”要不要算”的问题，而是”算不准就多交钱”的问题——碳排放数据正从 ESG 附录变成财务项。', 4),
(9, 'p', 'CBAM 证书价格锚定欧盟碳市场（ETS）的周度均价，碳成本随碳价波动。对于碳强度较高的出口产品（如长流程钢材），CBAM 相当于增加了数个百分点乃至更高的隐性关税。', 5),
(9, 'p', '建议对欧出口企业尽快建立产品碳足迹核算能力，收集供应商碳排放数据，评估 CBAM 对产品到岸成本的量化影响，并在可行时优化生产流程以降低碳排放强度。', 6),
-- 10. 欧盟数字产品护照
(10, 'kt', '2026 年起多类产品须附数字护照方可入欧\n覆盖电池、电子、纺织、建筑材料等品类\n打通从原料到终端全链数据成为刚性需求\n供应链透明度要求大幅提升', 1),
(10, 'lead', '欧盟数字产品护照（DPP）新规即将全面落地，多类产品须附完整溯源数据方可进入欧盟市场，供应链透明度从”加分项”变为”准入门槛”。', 2),
(10, 'p', '根据欧盟《可持续产品生态设计法规》（ESPR），2026 年起电池、电子、纺织、建筑材料等多类产品在进入欧盟市场前，须为其配备数字产品护照。护照须包含从原料成分、制造工艺、碳足迹到维修与回收信息的全生命周期数据。', 3),
(10, 'quote', '数字护照本质上是一张”供应链身份证”——谁掌握它，谁就掌握了对欧出口的通行权。', 4),
(10, 'p', '对于中国出口企业而言，DPP 意味着需要向上游追溯原料来源、向下游保证数据可访问性，数据链条断裂的任一环节都将导致产品无法合法入欧。这也是全球供应链透明度大趋势的一个缩影——美国、日韩也在推进类似制度。', 5),
(10, 'p', '建议出口企业尽早梳理产品品类是否落入 DPP 覆盖范围，建立从原料到成品的数据采集与管理系统，并与上游供应商沟通碳排放与原料溯源数据的共享要求。', 6),
-- 11. Section 122 半导体
(11, 'kt', '美商务部依 Section 122 对半导体供应链启动国家安全影响调查\n评估晶圆制造、封测环节的海外依赖风险\n可能触发新的进口限制或本土化要求\n全球半导体供应链格局面临再调整', 1),
(11, 'lead', '美国商务部援引《贸易扩展法》Section 122，对半导体供应链启动国家安全影响调查，全球芯片供应链的产地布局面临新一轮政策干预。', 2),
(11, 'p', '美国商务部已正式启动对半导体供应链的 Section 122 调查，评估美国在晶圆制造、先进封装与测试环节的海外依赖程度及其对国家安全的影响。调查可能引发新的进口限制、本土化投资要求或盟友间的供应链合作协议。', 3),
(11, 'quote', '半导体已从”商业芯片”变成”安全筹码”——供应链的每一次重组，背后都是地缘政治的逻辑。', 4),
(11, 'p', '目前全球先进制程晶圆（7nm 及以下）约九成产能集中在东亚地区，美国通过 CHIPS 法案等政策吸引本土与盟友投资。Section 122 调查的结果可能推动更多”友岸外包”安排——即把封测与部分晶圆产能转移至美国、日本、欧洲或东南亚友好国家。', 5),
(11, 'p', '半导体下游用户（汽车、电子、工业设备等）应关注调查进展对芯片供应来源与价格的潜在影响，评估关键芯片品类的第二供应源，并在采购策略中纳入地缘风险溢价考量。', 6),
-- 12. 中国稀土管制
(12, 'kt', '商务部加强对 17 种稀土元素的出口管制\n包括镝、铽等关键重稀土\n11 月 10 日大限将至\n全球稀土供应链紧张，担忧扩展到其他领域', 1),
(12, 'lead', '中国商务部宣布对 17 种稀土元素实施出口管制新规，11 月 10 日为关键实施节点，全球稀土供应链面临再平衡压力。', 2),
(12, 'p', '中国商务部最新公告对包括镝、铽在内的 17 种稀土元素加强出口管制，要求出口企业获得专项许可并报告最终用途与最终用户。镝和铽是制造高性能永磁体的关键材料，广泛应用于电动汽车、风力发电机与国防电子设备。', 3),
(12, 'quote', '稀土不是”贵不贵”的问题，而是”有没有”的问题——没有镝和铽，就没有高性能电机。', 4),
(12, 'p', '中国目前掌控全球约六成稀土开采与约九成的冶炼分离产能，管制措施引发美国、日本与欧盟的高度关注。日本经济产业省已召集企业商讨稀土储备与替代来源方案，美国国防部也加速推进稀土供应链本土化与盟友合作。', 5),
(12, 'p', '建议依赖稀土材料的制造企业评估自身供应链的稀土依赖度，测试替代材料或减量化方案，并与供应商协商长期供货协议与缓冲库存安排。同时关注各国政府稀土储备释放与替代矿山开发的进展。', 6),
-- 13. USMCA 日落审查
(13, 'kt', 'USMCA 联合审查将于 2026 年 7 月 1 日启动\n涉及汽车原产地规则、劳工条款与数字贸易章节\n北美供应链面临重大变数\n16 年协议可能首度经历实质性修订', 1),
(13, 'lead', '美墨加贸易协定（USMCA）首次联合审查即将于 2026 年 7 月 1 日启动，涉及汽车原产地规则、劳工标准与数字贸易等核心条款，北美供应链面临政策变数。', 2),
(13, 'p', 'USMCA 第 34 章规定的首次联合审查将于 2026 年 7 月 1 日正式启动，三方将对协定执行情况进行全面评估并提出修订建议。这是 USMCA 自 2020 年生效以来最重要的政策节点，审查结果将直接影响协定的存续与条款调整。', 3),
(13, 'quote', 'USMCA 审查不只是”续约”——它可能重新定义北美自由贸易的规则，而汽车产业是首当其冲的风向标。', 4),
(13, 'p', '汽车原产地规则是审查中最受关注的议题：目前的区域价值含量要求（RVC）为 75%，是否上调至更高比例、以及对”核心部件”的定义是否收紧，将直接影响亚洲与欧洲供应商在北美市场的准入成本。劳工条款的强化也可能推高墨西哥的制造业成本。', 5),
(13, 'p', '在北美有供应链布局的企业应密切关注审查进展，评估原产地规则变化对自身产品的 RVC 合规影响，在采购与产能规划中预留调整空间，并考虑在墨西哥、美国或加拿大做本地化产能布局以对冲政策风险。', 6),
-- 14. 中国报复性关税
(14, 'kt', '商务部宣布对原产于美国的部分化工品、原料药加征关税\n涉及医药与精细化工供应链\n中美贸易博弈持续升级\n医药与化工行业进口成本将上升', 1),
(14, 'lead', '中国商务部宣布对原产于美国的部分化工品与原料药加征报复性关税，中美贸易博弈进一步延伸至医药与精细化工供应链。', 2),
(14, 'p', '在美国持续升级对华关税的背景下，中国商务部发布公告对原产于美国的部分化工品、原料药与中间体加征关税。受影响品类包括部分药用辅料、精细化工中间体与特种化学品，税率因品类而异。', 3),
(14, 'quote', '医药供应链正在被地缘政治重塑——从”全球采购、成本最优”转向”多源布局、供应安全优先”。', 4),
(14, 'p', '原料药与精细化工是全球化程度最高的供应链之一，中美之间的关税升级可能促使仿制药企业、CDMO（合同研发生产组织）重新评估采购与生产布局。部分品类可能出现短期供应紧张与价格波动。', 5),
(14, 'p', '医药与化工企业应梳理自身对美进口原料的依赖度与替代性，评估从印度、欧洲或国内替代供应商采购的可行性与注册变更成本，并在关键品类的采购合同中加入关税变动相关的价格调整条款。', 6);

-- -------------------------------------------------------
-- 8. 文章标签
-- -------------------------------------------------------
INSERT INTO article_tags (article_id, tag_name) VALUES
(1, '红海'), (1, '好望角'), (1, '弹性路由'), (1, '海运'),
(2, '乌克兰'), (2, '炼油厂'), (2, '能源'), (2, '地缘冲突'),
(3, '战争险'), (3, '中东'), (3, '海运保险'), (3, '能源'),
(4, '黑海'), (4, '粮食安全'), (4, '大宗商品'), (4, '航运'),
(5, '霍尔木兹'), (5, '石油'), (5, '伊朗'), (5, '能源安全'),
(6, '巴拿马运河'), (6, '限航'), (6, '美东航线'), (6, '物流'),
(7, '关税'), (7, 'Section232'), (7, '金属'), (7, 'TCO'),
(8, '关税'), (8, 'Section301'), (8, '新能源'), (8, '光伏'),
(9, 'CBAM'), (9, '碳关税'), (9, '欧盟'), (9, '碳排放'),
(10, '数字护照'), (10, 'ESPR'), (10, '溯源'), (10, '欧盟'),
(11, '半导体'), (11, 'Section122'), (11, '芯片'), (11, '供应链安全'),
(12, '稀土'), (12, '出口管制'), (12, '永磁体'), (12, '关键矿产'),
(13, 'USMCA'), (13, '北美'), (13, '原产地规则'), (13, '汽车'),
(14, '报复性关税'), (14, '原料药'), (14, '化工'), (14, '医药');
