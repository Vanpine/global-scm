-- ============================================================
-- 双语数据填充：为所有 _en 列填入英文翻译
-- 执行方式：mysql -u root -p global_scm < 此文件
-- ============================================================

-- ============================================================
-- 1. home_hero（1行）
-- ============================================================
UPDATE home_hero SET
    title_en = 'Global Supply Chain',
    highlight_en = 'Platform',
    subtitle_en = 'Empowering Local Resources · Connecting Global Markets',
    tags_json_en = '[{"icon": "trending-up", "text": "Cost Reduction"}, {"icon": "shield", "text": "Risk Resilience"}, {"icon": "cpu", "text": "AI-Powered"}]',
    cta_primary_text_en = 'Join Now →',
    cta_secondary_text_en = 'Learn More →'
WHERE id = 1;

-- ============================================================
-- 2. home_carousel（4行）
-- ============================================================
UPDATE home_carousel SET
    eyebrow_en = 'END-TO-END VISIBILITY',
    title_en = 'One Map, Full Control of Every Shipment',
    description_en = 'All containers in transit, all warehouse inventory, all PO fulfillment progress — a real-time control tower with complete visibility.'
WHERE id = 1;

UPDATE home_carousel SET
    eyebrow_en = 'ELASTIC ROUTING',
    title_en = 'Elastic Routing, No More Supply Chain Disruptions',
    description_en = 'Suez blocked? Auto-switch to Cape of Good Hope. Ocean freight disrupted? Switch to China-Europe Railway — intelligent rerouting triggered by anomalies.'
WHERE id = 2;

UPDATE home_carousel SET
    eyebrow_en = 'SMART WAREHOUSE',
    title_en = 'Multi-Warehouse Synergy: Inventory Turnover from 90 Days to 55 Days',
    description_en = 'Unified management of domestic/overseas/FBA warehouses. AI wave planning + barcode operations reduce inventory turnover from 90 days to 55 days.'
WHERE id = 3;

UPDATE home_carousel SET
    eyebrow_en = 'AI COPILOT',
    title_en = 'Command Your Supply Chain in Natural Language',
    description_en = '"Which shipments will be affected by the US West Coast port strike?" — Copilot connects directly to business data and delivers affected shipment lists and response plans in seconds.'
WHERE id = 4;

-- ============================================================
-- 3. home_crisis_cards（6行）
-- ============================================================
UPDATE home_crisis_cards SET
    tag_en = 'Trade Policy',
    title_en = 'Policy, Tariff & Regulatory Shocks',
    description_en = 'Frequent adjustments to US Section 232 and 301 tariffs, formal implementation of EU CBAM carbon border mechanism — compliance costs keep rising. Sudden tariff changes can instantly derail procurement budgets.',
    items_json_en = '["Tariffs change rapidly, making landed costs unpredictable", "Export controls and sanctions lists keep expanding", "ESG compliance and carbon tariffs become new trade barriers"]'
WHERE id = 1;

UPDATE home_crisis_cards SET
    tag_en = 'Geopolitics',
    title_en = 'Geopolitical Conflict & Route Disruptions',
    description_en = 'The Red Sea crisis forces major carriers to reroute around the Cape of Good Hope; Hormuz Strait tensions threaten 20% of global oil transport. War risk premiums soar, and both delivery times and logistics costs spiral out of control.',
    items_json_en = '["Red Sea detour adds 10–14 days per voyage", "War risk premiums surge, freight rates fluctuate wildly", "Strait closure risks could cut off critical routes at any time"]'
WHERE id = 2;

UPDATE home_crisis_cards SET
    tag_en = 'Logistics Bottleneck',
    title_en = 'Logistics & Infrastructure Bottlenecks',
    description_en = 'Major global ports face frequent congestion, space is tight, rates are volatile. Canal restrictions and hub disruptions put supply chains at constant risk — a single traditional route can no longer cope.',
    items_json_en = '["Port congestion and space shortages cause widespread delays", "Container freight rates can swing 30% in a single week", "Suez/Panama Canal restrictions become the new normal"]'
WHERE id = 3;

UPDATE home_crisis_cards SET
    tag_en = 'Demand Risk',
    title_en = 'Demand Volatility & Bullwhip Effect',
    description_en = 'Small fluctuations in end-user demand are amplified through distributors, brands, and manufacturers, ultimately causing violent swings at the raw material level. Overstock and shortages can flip overnight — forecasting errors lead to chain-wide inventory imbalances.',
    items_json_en = '["Demand signals take 4–6 weeks to reach upstream", "Bullwhip effect amplifies inventory costs 3–5×", "Stockouts during peak season coexist with overstock during off-season"]'
WHERE id = 4;

UPDATE home_crisis_cards SET
    tag_en = 'Supply Risk',
    title_en = 'Single-Point Dependency & Supply Disruption',
    description_en = 'A single supplier, a single warehouse, a single route — a strike, fire, or natural disaster at any point can disrupt core SKUs for months. Production line downtime costs are measured by the hour.',
    items_json_en = '["Concentration risk in single supplier/warehouse/route", "Strikes, fires, and natural disasters trigger supply disruptions at any time", "Core component shortages cause full-line production halts"]'
WHERE id = 5;

UPDATE home_crisis_cards SET
    tag_en = 'Cybersecurity',
    title_en = 'Cyber Attacks & Digital System Risk',
    description_en = 'Global ports and logistics platforms are frequently hit by ransomware attacks. A single system outage can cause cargo detention, data breaches, and tens of millions in losses — the deeper the digitalization, the wider the attack surface.',
    items_json_en = '["Port operating systems crippled by ransomware", "Logistics platform outages cause chain-wide blindness", "Customer data and transaction records stolen"]'
WHERE id = 6;

-- ============================================================
-- 4. home_sections（5行 - static content）
-- ============================================================
UPDATE home_sections SET
    title_en = NULL,
    subtitle_en = NULL,
    items_json_en = '[{"label": "Demand Forecast Accuracy (Target)", "value": "90%+"}, {"label": "Inventory Turnover Days (Target)", "value": "≤55 days"}, {"label": "Anomaly Response Time (Target)", "value": "≤4h"}, {"label": "On-Time In-Full OTIF (Target)", "value": "92%+"}]'
WHERE id = 1;

UPDATE home_sections SET
    title_en = 'Supply Chains Without Disruption Worries',
    subtitle_en = 'In an era of frequent geopolitical conflicts and trade protectionism, AI is reshaping how supply chains connect and build resilience.',
    items_json_en = '[{"desc": "Using AI to precisely match local competitive industries, specialty materials, and idle capacity with global demand, forming a network of \\"single-point breakthroughs, multi-point support\\" to hedge against disruption risks and strengthen industrial resilience.", "icon": "globe", "tags": ["Single-Point Breakthrough", "Multi-Point Support", "Anti-Disruption"], "title": "Empowering Local Resources to Connect with Global Supply Chains"}, {"desc": "The \\"Supply Chain Management AI Console\\" monitors global weather, geopolitics, tariffs, trade policies, and logistics in real time, enabling businesses to remain agile and resilient in uncertain times.", "icon": "chart", "tags": ["Cost Reduction", "Efficiency", "Risk Resilience"], "title": "Enabling Businesses to Reduce Costs, Boost Efficiency & Mitigate Risks"}]'
WHERE id = 2;

UPDATE home_sections SET
    title_en = 'AI-Powered: Turning Uncertainty into Manageability',
    subtitle_en = 'Facing these challenges, we replace experience-driven decisions and information silos with an AI closed loop: Perception → Analysis → Decision → Execution.',
    items_json_en = '[{"sub": "Policy · Tariffs · Typhoons · Strikes", "desc": "Automatically aggregate customs policies, sanctions lists, weather, and port status, delivering precise push notifications by category/route — transforming \\"I didn\'t know\\" into \\"I\'m already prepared.\\"", "icon": "radar", "title": "Global Intelligence Perception"}, {"sub": "Demand Forecast · TCO · Simulation", "desc": "Probabilistic forecasting integrating 12+ data dimensions, full-chain TCO optimization, disruption simulation — turning decisions from \\"rough guess\\" to \\"quantified optimal.\\"", "icon": "brain", "title": "AI Data-Driven Decision Making"}, {"sub": "Multi-Source Procurement · Elastic Routing", "desc": "Distributed supply, multi-hub logistics, one-click emergency switching — single-point disruptions or route interruptions can be reorganized within hours.", "icon": "shield", "title": "Resilient Supply Network"}]'
WHERE id = 3;

UPDATE home_sections SET
    title_en = 'Real-Time Global Supply Chain Risk Intelligence',
    subtitle_en = 'Real-time integration of GDACS global disasters (floods/cyclones/wildfires/droughts/volcanoes) and USGS earthquake data, with automatic risk highlighting for high-threat areas.',
    items_json_en = '[{"cat": "logi", "href": "news-redsea.html", "meta": "Reuters · Shipping · Today", "title": "Red Sea Crisis Continues: Major Carriers Default to Cape Route"}, {"cat": "energy", "href": "news-hormuz.html", "meta": "Bloomberg · Energy · 2h ago", "title": "Strait of Hormuz Nearly Closed, 20% of Global Oil Chokepoint Disrupted"}, {"cat": "policy", "href": "news-tariff.html", "meta": "Baker Tilly · Today", "title": "US Section 232 Metal Tariffs Expand to Copper, Up to 50%"}, {"cat": "policy", "href": "news-rareearth.html", "meta": "TechTimes · 3h ago", "title": "China Rare Earth Export Controls Loom: November 10 Deadline"}, {"cat": "war", "href": "news-blacksea.html", "meta": "Modern Diplomacy · 5h ago", "title": "Black Sea Export Corridor Attacked Again, Russian Drones Hit Three Foreign Vessels"}, {"cat": "energy", "href": "news-cbam.html", "meta": "European Commission · 2 days ago", "title": "EU CBAM Carbon Border Mechanism Enters Formal Phase, Importers Must Surrender Certificates"}]'
WHERE id = 4;

UPDATE home_sections SET
    title_en = 'Ready to Navigate Your Supply Chain Through Uncertainty?',
    subtitle_en = 'Tell us about your business scenario — we\'ll use real data to evaluate your cost reduction and risk mitigation opportunities.',
    items_json_en = '[{"href": "/contact", "text": "Apply to Join Free →", "primary": true}, {"href": "mailto:hello@globalscm.com", "text": "hello@globalscm.com", "primary": false}]'
WHERE id = 5;

-- ============================================================
-- 5. articles（14行）- titles & summaries
-- ============================================================
UPDATE articles SET title_en = 'Red Sea Crisis Continues: Major Carriers Default to Cape Route', summary_en = 'CMA CGM, Maersk and others have made the Cape of Good Hope the default Asia-Europe route, adding 10–14 days per voyage, ~30% higher fuel consumption, and $500–$1,500 per container in surcharges.', meta_en = 'Reuters · Container News · Shipping · Today' WHERE id = 1;
UPDATE articles SET title_en = 'Ukraine\'s "Logistics Blockade": 15 Russian Refineries Hit This Year', summary_en = 'Ukrainian strikes hit 15 refineries in Jan–May, ~40% of Russian refining capacity offline; Crimea on fuel rationing, Russia restricts refined product exports.', meta_en = 'Kyiv Independent · Geopolitics · 8h ago' WHERE id = 2;
UPDATE articles SET title_en = 'War Risk Repricing: Middle East Conflict Drives Up Marine Insurance, Underwriters Exit Gulf', summary_en = 'Multiple P&I Clubs cancel Gulf war risk coverage within 72 hours; Western-flag vessel premiums rise to several percent of hull value, costs cascade through the chain.', meta_en = 'Insurance Business · Shipping · Today' WHERE id = 3;
UPDATE articles SET title_en = 'Black Sea Export Corridor Attacked Again, Russian Drones Hit Three Foreign Vessels', summary_en = 'Ukraine grain and metal export corridor security in jeopardy; attacks could push up global food prices, hitting African, Middle Eastern, and Asian importers hardest.', meta_en = 'Modern Diplomacy · Black Sea · 5h ago' WHERE id = 4;
UPDATE articles SET title_en = 'Strait of Hormuz Tensions Escalate, Global Oil Transit Chokepoint at Risk', summary_en = 'Iran\'s Revolutionary Guard seizes multiple commercial vessels; marine war risk premiums surge. A strait closure would disrupt ~20% of global seaborne oil.', meta_en = 'Bloomberg · Energy · Today' WHERE id = 5;
UPDATE articles SET title_en = 'Panama Canal Restrictions Persist, Asia–US East Coast Routes Under Pressure', summary_en = 'Gatun Lake water levels remain low; daily transits down ~40% from normal. Some liner services forced to divert via Suez or round the Cape of Good Hope.', meta_en = 'El Faro · Logistics · Today' WHERE id = 6;
UPDATE articles SET title_en = 'US Section 232 Metal Tariffs Expand to Copper, Up to 50%', summary_en = 'The US Commerce Department launches a Section 232 national security investigation into copper imports, with preliminary recommended tariff rates of 25–50%.', meta_en = 'Baker Tilly · NatLawReview · Tariffs · Today' WHERE id = 7;
UPDATE articles SET title_en = 'US Tariffs on China Escalate Again: Section 301 List Expands to Clean Energy', summary_en = 'USTR releases new Section 301 exclusion list revisions, adding PV inverters and other categories; China\'s Ministry of Commerce strongly opposes.', meta_en = 'Reuters · Trade · Today' WHERE id = 8;
UPDATE articles SET title_en = 'EU Carbon Border Adjustment Mechanism (CBAM) Enters Formal Phase', summary_en = 'From 2026, importers must report embedded emissions quarterly and surrender CBAM certificates. Initial coverage: steel, aluminum, cement, fertilizer, electricity, and hydrogen.', meta_en = 'European Commission · Policy · 2 days ago' WHERE id = 9;
UPDATE articles SET title_en = 'EU Digital Product Passport Rules Loom, Supply Chain Traceability Requirements Escalate', summary_en = 'From 2026, multiple product categories must carry digital passports to enter the EU; full-chain data from raw materials to end products becomes a mandatory requirement.', meta_en = 'European Parliament · Regulation · 3 days ago' WHERE id = 10;
UPDATE articles SET title_en = 'US Section 122 Investigation Targets Semiconductor Supply Chain', summary_en = 'The US Commerce Department invokes Section 122 of the Trade Expansion Act to investigate national security impacts of semiconductor supply chain dependencies on foreign sources.', meta_en = 'US Commerce Dept. · Semiconductors · Today' WHERE id = 11;
UPDATE articles SET title_en = 'China Imposes Rare Earth Export Controls, November 10 Deadline Approaches', summary_en = 'China\'s Ministry of Commerce strengthens export controls on 17 rare earth elements, including dysprosium and terbium, triggering global supply chain tensions and fears of spillover to other sectors.', meta_en = 'TechTimes · Rare Earth · 3h ago' WHERE id = 12;
UPDATE articles SET title_en = 'USMCA Sunset Review Begins: US-Mexico-Canada Trade Agreement Faces Renegotiation', summary_en = 'The USMCA joint review launches July 1, 2026, covering automotive rules of origin, labor provisions, and digital trade chapters — North American supply chains face uncertainty.', meta_en = 'CBC News · North America · Today' WHERE id = 13;
UPDATE articles SET title_en = 'China Imposes Retaliatory Tariffs on US Chemical Products and APIs', summary_en = 'China\'s Ministry of Commerce announces tariffs on certain US-origin chemicals and active pharmaceutical ingredients, affecting pharmaceutical and fine chemical supply chains.', meta_en = 'Bloomberg · Chemicals · 2 days ago' WHERE id = 14;

-- ============================================================
-- 6. article_blocks（89行）- content_en
-- ============================================================
UPDATE article_blocks SET content_en = 'Houthi attacks become normalized; Cape of Good Hope becomes default Asia-Europe route; Suez only optional for exempted flag vessels.\nSingle voyage adds ~3,000–3,500 nautical miles and 10–14 days.\nFuel consumption rises ~30% per leg; additional cost ~$1M per voyage.\nCarriers impose $500–$1,500/container transit surcharges.\nFeb 2026: ME11 service tentatively resumes Suez transit but remains a high-risk exception.' WHERE id = 1;
UPDATE article_blocks SET content_en = 'By mid-2026, Houthi attacks on Red Sea shipping have solidified from sporadic incidents into a structural reality, with global mainline operators treating the Cape of Good Hope as the default route for Asia-Europe trade.' WHERE id = 2;
UPDATE article_blocks SET content_en = 'Since late 2023, Yemen\'s Houthi forces have continuously attacked vessels transiting the Red Sea and Bab el-Mandeb Strait. Entering 2026, CMA CGM, Maersk, and other major carriers have established the Cape of Good Hope detour as the default routing for Asia-Europe and Asia-US East Coast services, with the Suez Canal remaining optional only for voyages under exempted flags.' WHERE id = 3;
UPDATE article_blocks SET content_en = '"Carriers are shifting from tactical avoidance to strategic network reconfiguration — this means Red Sea instability will continue to impact supply chain planning for several quarters to come."' WHERE id = 4;
UPDATE article_blocks SET content_en = 'The Cape detour adds approximately 3,000–3,500 nautical miles and 10–14 days per Asia-Europe voyage, with fuel consumption rising about 30% and additional costs of roughly $1 million per voyage. Carriers generally impose transit surcharges of $500–$1,500 per container and absorb delays through capacity reshuffling and schedule resets.' WHERE id = 5;
UPDATE article_blocks SET content_en = 'For time-sensitive industries such as automotive, electronics, and fast-moving consumer goods, this means reassessing inventory placement, safety stock levels, and supplier diversification strategies. Some shippers have already shifted to trans-Pacific to US West Coast plus inland rail, sea-air via Dubai/Singapore, or the 18–22 day China-Europe Railway Express as alternative paths.' WHERE id = 6;
UPDATE article_blocks SET content_en = '"In an uncertain shipping environment, elastic routing and dynamic safety stock are moving from optional to essential."' WHERE id = 7;
UPDATE article_blocks SET content_en = 'The industry broadly expects Red Sea detours to persist until at least 2027 — even if attack frequency declines, insurance markets will maintain elevated war risk premiums. Supply chain teams should embed "extended voyage duration" assumptions into plans and incorporate "anomaly trigger → intelligent rerouting" into standard processes rather than ad-hoc firefighting.' WHERE id = 8;

UPDATE article_blocks SET content_en = 'Jan–May: Ukraine strikes 15 Russian refineries.\n~40% of Russian refining capacity offline.\nCrimea on fuel rationing; Russia restricts refined product exports.\nLong-range drone strikes reshape the conflict landscape.' WHERE id = 9;
UPDATE article_blocks SET content_en = 'Ukraine is weaponizing logistics blockade as a strategic tool, launching systematic strikes on Russian refineries this year, causing sustained disruption to global energy supply chains.' WHERE id = 10;
UPDATE article_blocks SET content_en = 'In January–May 2026, the Ukrainian military employed drones to conduct systematic strikes on Russian deep-penetration refining facilities, hitting a cumulative total of 15 refineries. Approximately 40% of Russian refining capacity is offline or operating at reduced loads following the strikes; Crimea has implemented fuel rationing, and the Russian government has formally restricted refined product exports.' WHERE id = 11;
UPDATE article_blocks SET content_en = '"The nature of warfare is shifting from frontline attrition to supply chain paralysis — industrial capacity, warehousing, and distribution networks have become strategic strike targets."' WHERE id = 12;
UPDATE article_blocks SET content_en = 'The transmission path of refining capacity damage to global refined product markets is clear: Russia curtails exports to preserve domestic supply, pushing up international diesel and gasoline basis differentials. Asian buyers are forced to source from more distant Middle Eastern and Indian supplies, raising ton-mile demand and freight rates.' WHERE id = 13;
UPDATE article_blocks SET content_en = 'Companies should incorporate energy transportation route stability, alternative fuel options, and inventory buffers into their supply chain risk management frameworks, particularly for categories dependent on Russian oil or transiting through the Black Sea.' WHERE id = 14;

UPDATE article_blocks SET content_en = 'Multiple P&I Clubs cancel Gulf war risk coverage within 72 hours.\nWestern-flag vessel premiums rise to several percent of hull value.\nMiddle East conflict continues to disrupt global energy and shipping patterns.' WHERE id = 15;
UPDATE article_blocks SET content_en = 'Escalating intensity of Middle East geopolitical conflict has led multiple P&I Clubs to sharply tighten war risk underwriting in the Gulf region, triggering structural repricing of global marine insurance and energy transportation.' WHERE id = 16;
UPDATE article_blocks SET content_en = 'Following the seizure of multiple commercial vessels by Iran\'s Revolutionary Guard and continued Houthi attacks on Red Sea shipping, several P&I Clubs cancelled war risk coverage for the Gulf and parts of Middle Eastern waters within a recent 72-hour window. Premiums for Western-flag vessels have risen to several percentage points of hull value, with some owners opting to reroute around southern Africa to mitigate risk.' WHERE id = 17;
UPDATE article_blocks SET content_en = '"When insurability itself becomes the issue, the foundation of maritime contract performance is shaken — this is a more fundamental risk than freight rate volatility."' WHERE id = 18;
UPDATE article_blocks SET content_en = 'The surge in war risk premiums transmits along the entire chain: shipowner → carrier → cargo owner → end consumer. Simultaneously, war exclusion clauses in cargo insurance policies are being invoked more frequently, exposing importers to scenarios where goods have shipped but insurance coverage is absent.' WHERE id = 19;
UPDATE article_blocks SET content_en = 'Traders and logistics providers are advised to review existing cargo insurance terms, confirm carrier insurance status with forwarders, and assess the feasibility and cost implications of alternative routes and multimodal solutions.' WHERE id = 20;

UPDATE article_blocks SET content_en = 'Russian drones attack three foreign-flagged commercial vessels transiting the Black Sea export corridor (late May).\nFires broke out onboard, extinguished by crew.\nThe corridor carries Ukrainian grain, metals, and agricultural exports.\nWartime temporary civilian corridors are costly and difficult to secure.\nAttacks could push up global food prices; African, Middle Eastern, and Asian importers affected.' WHERE id = 21;
UPDATE article_blocks SET content_en = 'Ukraine alleges that Russia launched drone attacks on three foreign-flagged commercial vessels transiting the Black Sea export corridor in late May, once again threatening the security of a critical global food and energy transport route.' WHERE id = 22;
UPDATE article_blocks SET content_en = 'According to Ukrainian Deputy Prime Minister Kuleba, the attacks occurred late Thursday night into the early hours of the following day. Three foreign-flagged commercial vessels on grain and export trade routes were struck by drones and caught fire; the crew extinguished the flames themselves. The Black Sea corridor is vital for global food supply, energy transport, and international trade.' WHERE id = 23;
UPDATE article_blocks SET content_en = '"When military operations, economic warfare, and international trade interests increasingly overlap, merchant vessels become the most vulnerable front line."' WHERE id = 24;
UPDATE article_blocks SET content_en = 'Ukraine relies heavily on seaborne exports to sustain its wartime economy, particularly grain, metals, and agricultural products. Russia has repeatedly struck ports, storage facilities, and shipping lanes, disrupting exports and threatening global supply chains multiple times. After Russia withdrew from the Black Sea Grain Initiative in 2023, Ukraine opened a temporary civilian vessel corridor in August of that year to maintain outbound shipments.' WHERE id = 25;
UPDATE article_blocks SET content_en = 'The impact of Black Sea trade disruption extends far beyond Ukraine itself — it transmits directly to global food prices, commodity markets, and supply chains, particularly hitting regions of Africa, the Middle East, and parts of Asia that are highly dependent on Ukrainian grain.' WHERE id = 26;
UPDATE article_blocks SET content_en = '"Food security is the most sensitive link in supply chain resilience; the fate of one corridor affects the dining tables of dozens of importing nations."' WHERE id = 27;
UPDATE article_blocks SET content_en = 'For procurement and trading enterprises, Black Sea corridor uncertainty should be incorporated into commodity sourcing scenario planning: diversify grain sources, closely track war risk and marine insurance developments, and maintain buffer inventory and alternative supply plans during high-volatility windows.' WHERE id = 28;

UPDATE article_blocks SET content_en = 'Iran\'s Revolutionary Guard seizes multiple transiting commercial vessels.\nMarine war risk premiums surge dramatically.\nIf the strait is blockaded, ~20% of global seaborne oil would be disrupted.\nAlternative routes are limited and extremely costly.' WHERE id = 29;
UPDATE article_blocks SET content_en = 'Tensions in the Strait of Hormuz have escalated sharply, with Iran\'s Revolutionary Guard Corps frequently seizing commercial vessels; the world\'s most critical oil transit chokepoint faces structural risk.' WHERE id = 30;
UPDATE article_blocks SET content_en = 'Recently, Iran\'s Revolutionary Guard Corps has seized multiple commercial vessels in the Strait of Hormuz and surrounding waters, claiming violations of maritime regulations. Marine war risk premiums have surged accordingly, with insurance costs for some voyages jumping from thousands to hundreds of thousands of dollars.' WHERE id = 31;
UPDATE article_blocks SET content_en = '"The vulnerability of the Strait of Hormuz lies not in whether it will be blockaded, but in the market\'s self-fulfilling expectation of blockade — panic alone is sufficient to distort freight rates and inventory behavior."' WHERE id = 32;
UPDATE article_blocks SET content_en = 'The Strait of Hormuz sees approximately 20% of global seaborne oil pass through daily, including both crude and refined products. In the event of a blockade, Middle East-to-Asia and Europe oil shipments would be forced to detour around Africa\'s Cape of Good Hope or through limited alternative pipelines, surging ton-mile demand and driving up global energy costs.' WHERE id = 33;
UPDATE article_blocks SET content_en = 'Oil traders and consuming enterprises should assess the potential impact of Hormuz risk on their own oil supply and pricing, establish multi-source supply and buffer inventory mechanisms, and continuously monitor naval escort and insurance market developments.' WHERE id = 34;

UPDATE article_blocks SET content_en = 'Gatun Lake water levels remain persistently low.\nDaily transits reduced ~40% from normal.\nSome liner services forced to divert via Suez or round the Cape of Good Hope.\nAsia–US East Coast routes face both time and cost increases.' WHERE id = 35;
UPDATE article_blocks SET content_en = 'Low-water restrictions on the Panama Canal caused by persistent drought cannot be lifted in the short term, reshaping the logistics landscape for Asia-to-US East Coast routes.' WHERE id = 36;
UPDATE article_blocks SET content_en = 'The Panama Canal watershed has experienced below-normal precipitation for nearly two consecutive years, with Gatun Lake levels struggling to recover to normal. Although the Canal Authority maintains operations through water conservation measures, the daily number of vessels permitted to transit remains approximately 40% below normal levels, with draft restrictions now a permanent feature.' WHERE id = 37;
UPDATE article_blocks SET content_en = '"A canal is not an on-off switch — when water-level restrictions become the new normal, supply chains need route diversification, not a prayer for rain."' WHERE id = 38;
UPDATE article_blocks SET content_en = 'Asia–US East Coast routes are most visibly affected by canal restrictions: some liner services divert via the Suez Canal (facing Red Sea risks in turn) or round the Cape of Good Hope, adding approximately 2 weeks of voyage time. Rising freight costs combined with slower transit exert sustained pressure on inventory strategies for retail, automotive, and electronics industries.' WHERE id = 39;
UPDATE article_blocks SET content_en = 'Logistics teams should incorporate canal restrictions into annual transportation planning scenario assumptions, evaluate the cost and transit time of US West Coast port plus inland rail alternatives, and pre-book capacity and buffer inventory ahead of critical peak seasons.' WHERE id = 40;

UPDATE article_blocks SET content_en = 'April 2 Presidential Proclamation, effective April 6, brings copper and derivatives under Section 232.\nSteel/aluminum/copper primary metals: 50% on full value.\nDerivatives: 25% on full value; metal-intensive industrial and grid equipment: 15% (through 2027).\nProducts manufactured abroad entirely from US-origin metal: 10%.\nProducts with metal content ≤15% are no longer subject to Section 232.' WHERE id = 41;
UPDATE article_blocks SET content_en = 'The US undertook a major restructuring of Section 232 metal tariffs in April 2026, bringing copper into scope and applying tariffs on full customs value — reshaping import costs and origin decisions for metals and metal-containing manufactured goods.' WHERE id = 42;
UPDATE article_blocks SET content_en = 'Per the April 2 Presidential Proclamation (effective April 6), steel, aluminum, copper, and their derivatives are subject to tariffs on full customs value: primary metal forms (e.g., steel coil, aluminum plate) at 50%, derivatives substantially composed of these metals at 25%, metal-intensive industrial equipment and grid equipment at 15% (through 2027), and products manufactured abroad entirely from US-origin metal at 10%.' WHERE id = 43;
UPDATE article_blocks SET content_en = '"A tariff is not a single number — it\'s a chain of variables affecting origin, supplier, and pricing. The sooner you quantify it, the more proactive you can be."' WHERE id = 44;
UPDATE article_blocks SET content_en = 'Unlike the previous practice of quarterly derivative additions, the new framework terminates the quarterly addition process, establishes product groupings with tiered rates, and removes products with metal content ≤15% from Section 232 coverage. This improves predictability but also requires companies to precisely calculate the metal composition and origin of every SKU.' WHERE id = 45;
UPDATE article_blocks SET content_en = 'According to public estimates, the average US effective tariff rate in April 2026 was approximately 11.8%, with metals, metal-containing products, and vehicles most deeply affected. For procurement teams, the key is mapping tariffs to their own bills of materials: which HS codes are affected, at what rate, and whether alternative origins exist.' WHERE id = 46;
UPDATE article_blocks SET content_en = '"What truly saves money isn\'t the lowest unit-price quote — it\'s the option with the best total cost once tariffs, logistics, and compliance are all factored in."' WHERE id = 47;
UPDATE article_blocks SET content_en = 'Enterprises are advised to use a "tariff sandbox" to automatically pull destination-country HS tariff rates at PO creation, perform multi-origin TCO comparisons, and review price clauses in affected contracts. Also monitor key milestones such as the July 1 USMCA joint review for potential impacts on supply chain footprint planning.' WHERE id = 48;

UPDATE article_blocks SET content_en = 'USTR releases new Section 301 exclusion list revisions.\nPV inverters and other clean-energy categories newly added.\nChina\'s Ministry of Commerce strongly opposes.\nClean-energy supply chains face tariff uncertainty.' WHERE id = 49;
UPDATE article_blocks SET content_en = 'The US Trade Representative (USTR) has undertaken a new round of revisions to Section 301 tariff exclusion lists, bringing PV inverters and other clean-energy categories into scope; US-China trade friction is extending further into the green economy.' WHERE id = 50;
UPDATE article_blocks SET content_en = 'In the latest published revisions to Section 301 exclusion lists, USTR has added categories including PV inverters and battery energy storage management systems, while maintaining high tariffs on certain traditional categories. China\'s Ministry of Commerce immediately issued a statement strongly opposing the move, arguing it undermines the stability of global clean-energy supply chains.' WHERE id = 51;
UPDATE article_blocks SET content_en = '"When tariffs spread from traditional manufacturing to clean energy, they cease to be merely trade policy — they become a variable affecting the pace of global decarbonization."' WHERE id = 52;
UPDATE article_blocks SET content_en = 'For clean-energy equipment importers and project developers, tariff changes directly affect equipment procurement costs and project economics. It is advisable to include tariff variation clauses in project quotations and procurement contracts, and to assess the feasibility of alternative sourcing from origins not subject to Section 301, such as Southeast Asia or Mexico.' WHERE id = 53;

UPDATE article_blocks SET content_en = 'From 2026, importers must report embedded emissions quarterly and surrender CBAM certificates.\nInitial coverage: steel, aluminum, cement, fertilizer, electricity, hydrogen.\nThe transition period ends; formal implementation begins.\nCarbon cost becomes a new variable in cross-border trade.' WHERE id = 54;
UPDATE article_blocks SET content_en = 'The EU Carbon Border Adjustment Mechanism (CBAM) enters its formal implementation phase in 2026; importers must report emissions quarterly and surrender CBAM certificates, making carbon cost a new rigid variable in trade with Europe.' WHERE id = 55;
UPDATE article_blocks SET content_en = 'Following a three-year transition period from 2023–2025, CBAM enters formal implementation from 2026. The initial phase covers six product categories — steel, aluminum, cement, fertilizer, electricity, and hydrogen — with importers required to report the embedded carbon emissions of their products quarterly and surrender the corresponding number of CBAM certificates.' WHERE id = 56;
UPDATE article_blocks SET content_en = '"Carbon isn\'t a question of whether to calculate it — it\'s that getting the calculation wrong means overpaying. Carbon emissions data is moving from the ESG appendix to a financial line item."' WHERE id = 57;
UPDATE article_blocks SET content_en = 'CBAM certificate prices are anchored to the weekly average price of EU carbon market (ETS) allowances, meaning carbon costs fluctuate with carbon prices. For export products with higher carbon intensity — such as blast-furnace steel — CBAM effectively adds a hidden tariff of several percentage points or more.' WHERE id = 58;
UPDATE article_blocks SET content_en = 'Enterprises exporting to Europe are advised to establish product carbon footprint accounting capabilities as soon as possible, collect supplier carbon emissions data, assess the quantitative impact of CBAM on product landed costs, and — where feasible — optimize production processes to reduce carbon intensity.' WHERE id = 59;

UPDATE article_blocks SET content_en = 'From 2026, multiple product categories must carry digital passports to enter the EU.\nCoverage includes batteries, electronics, textiles, and construction materials.\nEnd-to-end data connectivity from raw materials to finished products becomes a mandatory requirement.\nSupply chain transparency requirements are dramatically elevated.' WHERE id = 60;
UPDATE article_blocks SET content_en = 'The EU\'s Digital Product Passport (DPP) regulation is about to land in full force; multiple product categories must carry complete traceability data to enter the EU market, transforming supply chain transparency from a nice-to-have into a market-access requirement.' WHERE id = 61;
UPDATE article_blocks SET content_en = 'Under the EU Ecodesign for Sustainable Products Regulation (ESPR), from 2026 batteries, electronics, textiles, construction materials, and other product categories entering the EU market must be equipped with a Digital Product Passport. The passport must contain full-lifecycle data spanning raw material composition, manufacturing processes, carbon footprint, and repair and recycling information.' WHERE id = 62;
UPDATE article_blocks SET content_en = '"A digital passport is essentially a supply chain ID card — whoever controls it controls the right of entry to the European market."' WHERE id = 63;
UPDATE article_blocks SET content_en = 'For Chinese exporting enterprises, DPP means the need to trace raw material sources upstream and ensure data accessibility downstream; a data chain break at any link renders the product legally unable to enter the EU. It also represents a microcosm of the broader global trend towards supply chain transparency — the US, Japan, and South Korea are advancing similar systems.' WHERE id = 64;
UPDATE article_blocks SET content_en = 'Export enterprises are advised to identify early whether their product categories fall within DPP scope, establish data collection and management systems spanning raw materials to finished products, and communicate carbon emissions and raw material traceability data-sharing requirements with upstream suppliers.' WHERE id = 65;

UPDATE article_blocks SET content_en = 'US Commerce Department launches Section 122 national security impact investigation into the semiconductor supply chain.\nAssesses overseas dependency risk in wafer fabrication, packaging, and testing.\nMay trigger new import restrictions or localization requirements.\nGlobal semiconductor supply chain landscape faces further realignment.' WHERE id = 66;
UPDATE article_blocks SET content_en = 'The US Department of Commerce has invoked Section 122 of the Trade Expansion Act to launch a national security impact investigation into the semiconductor supply chain; the global chip supply chain\'s manufacturing footprint is facing a new round of policy intervention.' WHERE id = 67;
UPDATE article_blocks SET content_en = 'The US Department of Commerce has formally launched a Section 122 investigation into the semiconductor supply chain, assessing the degree of US overseas dependency in wafer fabrication, advanced packaging, and testing, and its implications for national security. The investigation could trigger new import restrictions, localization investment requirements, or allied supply chain cooperation agreements.' WHERE id = 68;
UPDATE article_blocks SET content_en = '"Semiconductors have moved from commercial chips to security bargaining chips — every restructuring of the supply chain is driven by geopolitical logic."' WHERE id = 69;
UPDATE article_blocks SET content_en = 'Currently, approximately 90% of global advanced-node wafer capacity (7nm and below) is concentrated in East Asia, with the US attracting domestic and allied investment through policies such as the CHIPS Act. The outcome of the Section 122 investigation could drive more "friend-shoring" arrangements — shifting packaging, testing, and some wafer fabrication capacity to the US, Japan, Europe, or friendly Southeast Asian nations.' WHERE id = 70;
UPDATE article_blocks SET content_en = 'Downstream semiconductor users (automotive, electronics, industrial equipment, etc.) should monitor the investigation\'s progress for potential impacts on chip supply sources and pricing, evaluate second-source options for critical chip categories, and incorporate geopolitical risk premiums into procurement strategies.' WHERE id = 71;

UPDATE article_blocks SET content_en = 'Ministry of Commerce strengthens export controls on 17 rare earth elements.\nIncludes key heavy rare earths such as dysprosium and terbium.\nNovember 10 deadline looms.\nGlobal rare earth supply chains tighten; concerns of spillover to other sectors.' WHERE id = 72;
UPDATE article_blocks SET content_en = 'China\'s Ministry of Commerce has announced new export control regulations for 17 rare earth elements, with November 10 as the key implementation milestone; global rare earth supply chains face rebalancing pressure.' WHERE id = 73;
UPDATE article_blocks SET content_en = 'The latest Ministry of Commerce announcement strengthens export controls on 17 rare earth elements including dysprosium and terbium, requiring exporters to obtain special licenses and report end-use and end-users. Dysprosium and terbium are critical materials for manufacturing high-performance permanent magnets widely used in electric vehicles, wind turbines, and defense electronics.' WHERE id = 74;
UPDATE article_blocks SET content_en = '"Rare earths aren\'t a question of cost — they\'re a question of availability. Without dysprosium and terbium, there are no high-performance motors."' WHERE id = 75;
UPDATE article_blocks SET content_en = 'China currently controls approximately 60% of global rare earth mining and roughly 90% of smelting and separation capacity; the control measures have drawn intense attention from the US, Japan, and the EU. Japan\'s Ministry of Economy, Trade and Industry has convened companies to discuss rare earth stockpiling and alternative sourcing, while the US Department of Defense is accelerating rare earth supply chain localization and allied cooperation.' WHERE id = 76;
UPDATE article_blocks SET content_en = 'Manufacturing enterprises reliant on rare earth materials are advised to assess their supply chain\'s rare earth dependency, test alternative materials or reduction strategies, and negotiate long-term supply agreements and buffer stock arrangements with suppliers. Also monitor government rare earth reserve releases and the progress of alternative mine development.' WHERE id = 77;

UPDATE article_blocks SET content_en = 'USMCA Joint Review launches July 1, 2026.\nCovers automotive rules of origin, labor provisions, and digital trade chapters.\nNorth American supply chains face significant uncertainty.\nThe 16-year-old agreement may undergo substantive revision for the first time.' WHERE id = 78;
UPDATE article_blocks SET content_en = 'The first-ever USMCA joint review is about to launch on July 1, 2026, covering core provisions including automotive rules of origin, labor standards, and digital trade; North American supply chains face policy uncertainty.' WHERE id = 79;
UPDATE article_blocks SET content_en = 'The first joint review mandated by USMCA Chapter 34 officially launches on July 1, 2026, with the three parties conducting a comprehensive assessment of the agreement\'s implementation and proposing amendments. This is the most significant policy milestone since USMCA entered into force in 2020, with the review\'s outcome directly affecting the agreement\'s continuation and clause adjustments.' WHERE id = 80;
UPDATE article_blocks SET content_en = '"The USMCA review isn\'t just a renewal — it could redefine the rules of North American free trade, and the automotive industry is the first and most telling bellwether."' WHERE id = 81;
UPDATE article_blocks SET content_en = 'Automotive rules of origin are the most closely watched issue in the review: the current Regional Value Content (RVC) requirement stands at 75%; whether it will be raised higher, and whether the definition of "core parts" will be tightened, will directly affect the market access costs for Asian and European suppliers in the North American market. Strengthened labor provisions could also push up manufacturing costs in Mexico.' WHERE id = 82;
UPDATE article_blocks SET content_en = 'Enterprises with supply chain footprints in North America should closely monitor review developments, assess the impact of rules-of-origin changes on their products\' RVC compliance, reserve adjustment space in procurement and capacity planning, and consider localized capacity deployment in Mexico, the US, or Canada to hedge against policy risk.' WHERE id = 83;

UPDATE article_blocks SET content_en = 'Ministry of Commerce announces retaliatory tariffs on certain US-origin chemicals and APIs.\nAffects pharmaceutical and fine chemical supply chains.\nUS-China trade博弈 continues to escalate.\nImport costs for pharmaceutical and chemical industries set to rise.' WHERE id = 84;
UPDATE article_blocks SET content_en = 'China\'s Ministry of Commerce has announced retaliatory tariffs on certain US-origin chemicals and active pharmaceutical ingredients, extending the US-China trade博弈 into the pharmaceutical and fine chemical supply chains.' WHERE id = 85;
UPDATE article_blocks SET content_en = 'Against the backdrop of continued US tariff escalation on China, the Ministry of Commerce issued a notice imposing tariffs on certain chemicals, active pharmaceutical ingredients, and intermediates originating from the United States. Affected categories include certain pharmaceutical excipients, fine chemical intermediates, and specialty chemicals, with rates varying by category.' WHERE id = 86;
UPDATE article_blocks SET content_en = '"Pharmaceutical supply chains are being reshaped by geopolitics — shifting from \'global sourcing for lowest cost\' toward \'multi-source布局 with supply security as the priority\'."' WHERE id = 87;
UPDATE article_blocks SET content_en = 'APIs and fine chemicals represent some of the most globalized supply chains; tariff escalation between China and the US could prompt generic drug companies and CDMOs to reassess procurement and production布局. Some categories may experience short-term supply tightness and price volatility.' WHERE id = 88;
UPDATE article_blocks SET content_en = 'Pharmaceutical and chemical enterprises should map their dependency on US-imported raw materials and substitutability, assess the feasibility and regulatory change costs of sourcing from India, Europe, or domestic alternative suppliers, and include tariff-change-related price adjustment clauses in procurement contracts for critical categories.' WHERE id = 89;

-- ============================================================
-- 7. article_tags（56行）- tag_name_en
-- ============================================================
UPDATE article_tags SET tag_name_en = 'Red Sea' WHERE id = 1;
UPDATE article_tags SET tag_name_en = 'Cape of Good Hope' WHERE id = 2;
UPDATE article_tags SET tag_name_en = 'Elastic Routing' WHERE id = 3;
UPDATE article_tags SET tag_name_en = 'Shipping' WHERE id = 4;
UPDATE article_tags SET tag_name_en = 'Ukraine' WHERE id = 5;
UPDATE article_tags SET tag_name_en = 'Oil Refinery' WHERE id = 6;
UPDATE article_tags SET tag_name_en = 'Energy' WHERE id = 7;
UPDATE article_tags SET tag_name_en = 'Geopolitical Conflict' WHERE id = 8;
UPDATE article_tags SET tag_name_en = 'War Risk' WHERE id = 9;
UPDATE article_tags SET tag_name_en = 'Middle East' WHERE id = 10;
UPDATE article_tags SET tag_name_en = 'Marine Insurance' WHERE id = 11;
UPDATE article_tags SET tag_name_en = 'Energy' WHERE id = 12;
UPDATE article_tags SET tag_name_en = 'Black Sea' WHERE id = 13;
UPDATE article_tags SET tag_name_en = 'Food Security' WHERE id = 14;
UPDATE article_tags SET tag_name_en = 'Commodities' WHERE id = 15;
UPDATE article_tags SET tag_name_en = 'Shipping' WHERE id = 16;
UPDATE article_tags SET tag_name_en = 'Strait of Hormuz' WHERE id = 17;
UPDATE article_tags SET tag_name_en = 'Oil' WHERE id = 18;
UPDATE article_tags SET tag_name_en = 'Iran' WHERE id = 19;
UPDATE article_tags SET tag_name_en = 'Energy Security' WHERE id = 20;
UPDATE article_tags SET tag_name_en = 'Panama Canal' WHERE id = 21;
UPDATE article_tags SET tag_name_en = 'Transit Restrictions' WHERE id = 22;
UPDATE article_tags SET tag_name_en = 'US East Coast Route' WHERE id = 23;
UPDATE article_tags SET tag_name_en = 'Logistics' WHERE id = 24;
UPDATE article_tags SET tag_name_en = 'Tariffs' WHERE id = 25;
UPDATE article_tags SET tag_name_en = 'Section 232' WHERE id = 26;
UPDATE article_tags SET tag_name_en = 'Metals' WHERE id = 27;
UPDATE article_tags SET tag_name_en = 'TCO' WHERE id = 28;
UPDATE article_tags SET tag_name_en = 'Tariffs' WHERE id = 29;
UPDATE article_tags SET tag_name_en = 'Section 301' WHERE id = 30;
UPDATE article_tags SET tag_name_en = 'Clean Energy' WHERE id = 31;
UPDATE article_tags SET tag_name_en = 'Solar' WHERE id = 32;
UPDATE article_tags SET tag_name_en = 'CBAM' WHERE id = 33;
UPDATE article_tags SET tag_name_en = 'Carbon Tariff' WHERE id = 34;
UPDATE article_tags SET tag_name_en = 'EU' WHERE id = 35;
UPDATE article_tags SET tag_name_en = 'Carbon Emissions' WHERE id = 36;
UPDATE article_tags SET tag_name_en = 'Digital Passport' WHERE id = 37;
UPDATE article_tags SET tag_name_en = 'ESPR' WHERE id = 38;
UPDATE article_tags SET tag_name_en = 'Traceability' WHERE id = 39;
UPDATE article_tags SET tag_name_en = 'EU' WHERE id = 40;
UPDATE article_tags SET tag_name_en = 'Semiconductor' WHERE id = 41;
UPDATE article_tags SET tag_name_en = 'Section 122' WHERE id = 42;
UPDATE article_tags SET tag_name_en = 'Chips' WHERE id = 43;
UPDATE article_tags SET tag_name_en = 'Supply Chain Security' WHERE id = 44;
UPDATE article_tags SET tag_name_en = 'Rare Earth' WHERE id = 45;
UPDATE article_tags SET tag_name_en = 'Export Controls' WHERE id = 46;
UPDATE article_tags SET tag_name_en = 'Permanent Magnets' WHERE id = 47;
UPDATE article_tags SET tag_name_en = 'Critical Minerals' WHERE id = 48;
UPDATE article_tags SET tag_name_en = 'USMCA' WHERE id = 49;
UPDATE article_tags SET tag_name_en = 'North America' WHERE id = 50;
UPDATE article_tags SET tag_name_en = 'Rules of Origin' WHERE id = 51;
UPDATE article_tags SET tag_name_en = 'Automotive' WHERE id = 52;
UPDATE article_tags SET tag_name_en = 'Retaliatory Tariffs' WHERE id = 53;
UPDATE article_tags SET tag_name_en = 'APIs' WHERE id = 54;
UPDATE article_tags SET tag_name_en = 'Chemicals' WHERE id = 55;
UPDATE article_tags SET tag_name_en = 'Pharmaceuticals' WHERE id = 56;

-- ============================================================
-- 8. page_sections - title_en / subtitle_en
--    items_json_en 翻译请执行 sql/update_items_json_en.sql
-- ============================================================
UPDATE page_sections SET title_en = 'Six Modules Working in Synergy', subtitle_en = 'From supplier to end customer, full-chain digitalization' WHERE id = 1;
UPDATE page_sections SET title_en = 'A Single Shipment Passes Through These Gates from Procurement to Delivery', subtitle_en = 'One glance to see: the key checkpoints a shipment passes through from procurement to delivery.' WHERE id = 2;
UPDATE page_sections SET title_en = 'Each Module Addresses a Critical Link', subtitle_en = 'Six modules, one-to-one mapped to six critical supply chain nodes.' WHERE id = 3;
UPDATE page_sections SET title_en = 'Supply Chain Running Smoothly? Now Sell Better and Settle Accounts Clearly', subtitle_en = 'The six modules manage goods flow; these two help you sell more and track finances accurately.' WHERE id = 4;
UPDATE page_sections SET title_en = 'Six Modules, Six AI Engines Running Behind the Scenes', subtitle_en = 'Auto price comparison when issuing POs, auto alerts when inventory is low, auto alternative route suggestions when shipping lanes are disrupted — AI is embedded at every decision point.' WHERE id = 5;
UPDATE page_sections SET title_en = 'Want to See How These Modules Fit Your Business Scenario?', subtitle_en = 'Every company\'s supply chain is different. Visit the Solutions page to explore scenario-specific combinations.' WHERE id = 6;
UPDATE page_sections SET title_en = 'Precision-Matched by Scenario', subtitle_en = 'Every company\'s supply chain is different — solutions shouldn\'t be one-size-fits-all.' WHERE id = 7;
UPDATE page_sections SET title_en = 'Find the Right Solution for Your Business Scenario', subtitle_en = 'No generic recommendations — every scenario has a concrete implementation path.' WHERE id = 8;
UPDATE page_sections SET title_en = 'Four Fulfillment Channels, OMS Auto-Matches the Optimal Route', subtitle_en = 'The system automatically selects the optimal channel based on inventory location, channel SLA, logistics cost, and destination country.' WHERE id = 9;
UPDATE page_sections SET title_en = 'Choose the Right Combination by Growth Stage', subtitle_en = 'No one-size-fits-all solution. Based on cross-border export practices, we categorize fulfillment selection into three growth stages (order volumes are for reference only).' WHERE id = 10;
UPDATE page_sections SET title_en = 'A Few Perspectives on Cross-Border Supply Chains', subtitle_en = 'Not every piece of conventional wisdom holds true. Here are our thoughts on several common questions, informed by practice.' WHERE id = 11;
UPDATE page_sections SET title_en = 'Target Outcomes in Typical Scenarios', subtitle_en = 'The following are illustrative target improvements for typical business scenarios to help you estimate value — not actual data from specific clients.' WHERE id = 12;
UPDATE page_sections SET title_en = 'Want to Understand the Industry Challenges Behind These Scenarios?', subtitle_en = 'Behind every business scenario are macro-level drivers — geopolitics, policy, supply-demand dynamics. Solutions only land firmly when you see the full picture.' WHERE id = 13;
UPDATE page_sections SET title_en = 'Why Choose Us', subtitle_en = 'Two Models, Key Metrics Side by Side' WHERE id = 14;
UPDATE page_sections SET title_en = 'Traditional Experience vs AI Data-Driven', subtitle_en = 'Seven key metrics, comparing performance across the two models.' WHERE id = 15;
UPDATE page_sections SET title_en = 'Meet Your Supply Chain Brain', subtitle_en = 'Forecast demand, respond to disruptions, make smarter decisions — all through a 24/7 AI Copilot.' WHERE id = 16;
UPDATE page_sections SET title_en = 'Six Dimensions That Set Us Apart', subtitle_en = 'Not a feature checklist contest, but differences in underlying architecture and product philosophy.' WHERE id = 17;
UPDATE page_sections SET title_en = 'Global Intelligence Briefing', subtitle_en = 'Real-time tracking of policy, tariffs, geopolitics, and logistics developments.' WHERE id = 18;
UPDATE page_sections SET title_en = NULL, subtitle_en = NULL WHERE id = 19;
UPDATE page_sections SET title_en = 'Let\'s Talk About Your Supply Chain', subtitle_en = 'Fill out the form or email us — we\'ll respond within 24 hours and provide tailored recommendations based on your real-world scenario.' WHERE id = 20;
UPDATE page_sections SET title_en = NULL, subtitle_en = NULL WHERE id = 21;
UPDATE page_sections SET title_en = 'Eight Hurdles in Supply Chain', subtitle_en = 'From macro environment to enterprise operations, unpacked one by one.' WHERE id = 32;
UPDATE page_sections SET title_en = 'These Pain Points Happen Every Day', subtitle_en = 'The four most common supply chain pain points — full breakdown below.' WHERE id = 33;
UPDATE page_sections SET title_en = 'Eight Hurdles, Deconstructed', subtitle_en = 'Each pain point corresponds to a concrete, actionable solution.' WHERE id = 34;
UPDATE page_sections SET title_en = 'One Underlying Logic: The Supply Chain Brain', subtitle_en = 'Replace experience-driven decisions and information silos with a Perception → Analysis → Decision → Execution closed loop.' WHERE id = 35;
