// ===== i18n =====
const I18N = {
  'zh-CN': {
    skip: '跳到主要内容',
    brand: 'AI卡路里',
    navHow: '使用流程', navFeatures: '功能特点', navScreenshots: '应用界面', navFaq: '常见问题', navGet: '获取 App',
    heroEyebrow: '✦ AI 营养识别助手',
    heroTitle: '拍照记录饮食，营养目标更清楚',
    heroSubtitle: '拍一张照片，AI 立即估算卡路里、蛋白质、碳水和脂肪，并帮你追踪饮水、体重与每日目标。',
    learnMore: '查看界面',
    trust1: '📷 拍照即识别', trust2: '🥗 全营养追踪', trust3: '🌏 中英双语',
    calToday: '今日摄入', calAi: 'AI 估算', calUnit: '/ 2000 kcal',
    mProtein: '蛋白质', mCarbs: '碳水', mFat: '脂肪',
    calFoot: '意大利面 · 约 680 kcal · 识别 95%',
    chipA: '💧 饮水 6 / 8 杯', chipB: '⚖️ 本周 -0.4 kg',
    proofRating: '健康 · 营养追踪',
    stat1: '拍照识别', stat2: '核心营养素', stat3: '双语界面', stat4: '广告 · 追踪',
    howTitle: '三步记录一餐', howSub: '拍照、识别、追踪——把复杂的营养记录变简单。',
    step1Title: '拍照记录餐食', step1Desc: '对准食物拍一张，或从相册选择、手动搜索——想怎么记都可以。',
    step2Title: 'AI 识别营养', step2Desc: 'AI 自动识别食物，估算卡路里以及蛋白质、碳水和脂肪，减少手动输入。',
    step3Title: '追踪目标与趋势', step3Desc: '对照每日目标查看进度，追踪饮水、体重与营养趋势，坚持得更久。',
    featuresTitle: '核心功能', featuresSub: '为“少输入、看得懂、能坚持”而设计。',
    feature1Title: 'AI 食物识别', feature1Desc: '拍照识别餐食并估算卡路里与主要营养成分，几秒完成一次记录。',
    feature2Title: '宏量营养追踪', feature2Desc: '记录蛋白质、碳水、脂肪与热量摄入，让每日饮食结构一目了然。',
    feature3Title: '个性化目标', feature3Desc: '依据年龄、性别与活动水平设定每日热量目标，贴近你的真实状态。',
    feature4Title: '饮水与体重', feature4Desc: '记录每日饮水、BMI 与体重趋势，把健康管理放进同一个闭环。',
    feature5Title: '趋势与统计', feature5Desc: '用周、月视图查看摄入趋势和营养素分布，随时调整饮食计划。',
    feature6Title: '本地优先与隐私', feature6Desc: '记录数据以本地存储为先，仅在识别时联网分析，隐私始终由你掌握。',
    screenshotsTitle: '应用界面', screenshotsSub: '左右滑动，点击任意截图可放大查看。',
    shot1: '今日摄入概览', shot2: '拍照识别食物', shot3: 'AI 营养估算', shot4: '搜索快速添加', shot5: '趋势与统计', shot6: '目标与体重',
    privacyTitle: '你的饮食数据，尽在掌握', privacyDesc: '记录以本地存储为先，仅在拍照识别时联网分析。没有广告、不做用户追踪。',
    pp1: '数据本地优先', pp2: '仅识别时联网', pp3: '无用户追踪', pp4: '无广告干扰',
    faqTitle: '常见问题',
    q1: 'AI 食物识别需要联网吗？', a1: '拍照识别由 AI 完成，需要联网上传照片进行分析；识别之外的记录浏览与数据查看均可在设备本地进行。',
    q2: '支持哪些设备和系统？', a2: '支持 iPhone 与 iPad，建议使用较新的 iOS / iPadOS 版本以获得完整体验。',
    q3: '可以追踪哪些营养数据？', a3: '可追踪卡路里、蛋白质、碳水化合物、脂肪，以及每日饮水、BMI 和体重趋势。',
    q4: '除了拍照还能怎样添加食物？', a4: '除拍照识别外，还支持从相册选择照片、搜索食物库以及手动输入，随时快速记录。',
    q5: '支持中英双语吗？是否收费？', a5: '界面支持简体中文与英文双语，App 可免费下载使用。',
    downloadTitle: '立即下载 Food Calories', downloadSubtitle: '拍一张照片，开始更清楚的营养管理。', downloadNote: '免费下载 · 支持 iPhone 与 iPad',
    footerRights: 'AI卡路里 / Food Calories. 保留所有权利。', footerMadeBy: 'Built by WeiProduct',
    stickySub: 'AI 拍照识别 · 免费', stickyGet: '获取',
    eyeHow: '使用流程', eyeDemo: '互动演示', eyeFeatures: '功能特点', eyePersonas: '使用场景', eyeScreens: '界面预览', eyeMethod: '识别原理', eyeCompare: '效率对比', eyePrivacy: '隐私承诺', eyeFaq: '答疑解惑',
    demoTitle: '亲手试试识别的感觉', demoSub: '点一个示例餐食，看看 AI 识别结果长什么样。',
    demoFood1: '🍜 拉面', demoFood2: '🥗 蔬菜沙拉', demoFood3: '🍕 披萨', demoFood4: '🍱 便当',
    demoPlaceholder: '选择上方任意餐食', demoScanning: 'AI 识别中…',
    demoDisclaimer: '示例估算——App 内数值以你的照片为准。',
    personaTitle: '适合这样的你', personaSub: '不同的目标，同一个更省力的记录方式。',
    persona1Name: '减脂新手', persona1Pain: '总在猜一顿饭有多少热量？', persona1Win: '拍一张，数字立刻有。',
    persona2Name: '健身增肌党', persona2Pain: '蛋白质够不够，每天手算太累。', persona2Win: '三大营养素自动估算，达标一眼看清。',
    persona3Name: '忙碌上班族', persona3Pain: '一忙起来，记录总是坚持不下来。', persona3Win: '电梯里就能记完一顿午餐。',
    persona4Name: '习惯养成者', persona4Pain: '饮水、体重、三餐分散在不同 App。', persona4Win: '一个闭环，每天顺手完成。',
    methodTitle: '从照片到营养素', methodSub: '一张照片如何变成卡路里与三大营养素——原理与边界都说清楚。',
    methodStep1: '你的照片', methodStep2: 'AI 视觉识别', methodStep3: '食物匹配', methodStep4: '分量估算', methodStep5: '卡路里 + 三大营养素',
    methodNote1: '是估算不是化验——一键即可修正。', methodNote2: '相册照片、手动搜索同样可用。', methodNote3: '只有识别这一步需要联网。',
    cmpTitle: '为什么拍照，而不是手输', cmpSub: '不点名对比——只对比记录一顿饭要花的功夫。',
    cmpCol0: '对比项', cmpCol1: 'AI卡路里', cmpCol2: '手动记录 App', cmpCol3: '笔记和表格',
    cmpRow1: '记录一顿饭', cmpRow2: '蛋白质 · 碳水 · 脂肪', cmpRow3: '饮水体重同一 App', cmpRow4: '广告与追踪', cmpRow5: 'EN / 中文 双语',
    cmpCell1a: '拍一张', cmpCell1b: '逐项搜索', cmpCell1c: '全部手输',
    cmpCell2a: '自动估算', cmpCell2b: '手动查表', cmpCell2c: '自己计算',
    cmpBuiltIn: '内置', cmpVaries: '视应用而定', cmpNone: '无',
    footTagline: '拍一张照片，营养看得清。', footLinksTitle: '快速链接', footPrefsTitle: '偏好设置', footTheme: '切换深浅色', footDownload: '下载 App',
    /* AI-AVATAR */
    aiTitle: 'AI分身 · AI卡路里助手',
    aiGreeting: '你好！我是 AI卡路里 的 AI分身 🥗 关于拍照识别、营养追踪、隐私或价格，都可以问我。',
    aiPlaceholder: '输入你的问题…',
    aiSend: '发送',
    aiChip1: '拍照怎么算出卡路里？',
    aiChip2: '我的饮食数据安全吗？',
    aiChip3: '免费吗？支持哪些设备？',
    aiDisclaimer: 'AI 生成，仅供参考',
    aiError: '抱歉，AI 助手暂时连不上，请稍后再试。(Sorry, the assistant is temporarily unreachable — please try again later.)'
    /* /AI-AVATAR */
  },
  'en': {
    skip: 'Skip to content',
    brand: 'Food Calories',
    navHow: 'How it works', navFeatures: 'Features', navScreenshots: 'Screens', navFaq: 'FAQ', navGet: 'Get App',
    heroEyebrow: '✦ AI nutrition assistant',
    heroTitle: 'Snap your meal, see the nutrition clearly',
    heroSubtitle: 'Take a photo and AI instantly estimates calories, protein, carbs and fat — then tracks water, weight and your daily goals.',
    learnMore: 'See screens',
    trust1: '📷 Snap to recognize', trust2: '🥗 Full macro tracking', trust3: '🌏 EN / 中文',
    calToday: 'Today', calAi: 'AI estimate', calUnit: '/ 2000 kcal',
    mProtein: 'Protein', mCarbs: 'Carbs', mFat: 'Fat',
    calFoot: 'Pasta · ~680 kcal · 95% match',
    chipA: '💧 Water 6 / 8 cups', chipB: '⚖️ This week -0.4 kg',
    proofRating: 'Health · Nutrition tracking',
    stat1: 'Photo recognition', stat2: 'Core macros', stat3: 'Bilingual UI', stat4: 'Ads · Tracking',
    howTitle: 'Log a meal in three steps', howSub: 'Snap, recognize, track — nutrition logging made simple.',
    step1Title: 'Snap your meal', step1Desc: 'Point and shoot, pick from your album, or search manually — log it however you like.',
    step2Title: 'AI estimates nutrition', step2Desc: 'AI recognizes the food and estimates calories plus protein, carbs and fat — less typing.',
    step3Title: 'Track goals & trends', step3Desc: 'See progress against daily goals and follow water, weight and nutrition trends to stay consistent.',
    featuresTitle: 'Core Features', featuresSub: 'Designed to log less, understand more, and stick with it.',
    feature1Title: 'AI Food Recognition', feature1Desc: 'Snap a meal to recognize it and estimate calories and key nutrients in seconds.',
    feature2Title: 'Macro Tracking', feature2Desc: 'Log protein, carbs, fat and calories so your daily nutrition breakdown is always clear.',
    feature3Title: 'Personalized Goals', feature3Desc: 'Set a daily calorie target based on your age, sex and activity level — tuned to you.',
    feature4Title: 'Water & Weight', feature4Desc: 'Track daily water, BMI and weight trends to keep your health in one closed loop.',
    feature5Title: 'Trends & Analytics', feature5Desc: 'View intake trends and nutrient distribution by week or month, and adjust anytime.',
    feature6Title: 'Local-first & Private', feature6Desc: 'Your records are stored on-device first and only go online for recognition — privacy stays with you.',
    screenshotsTitle: 'App Screens', screenshotsSub: 'Swipe through — tap any screen to zoom in.',
    shot1: 'Daily intake overview', shot2: 'Snap to recognize', shot3: 'AI nutrition estimate', shot4: 'Search & quick add', shot5: 'Trends & analytics', shot6: 'Goals & weight',
    privacyTitle: 'Your nutrition data stays yours', privacyDesc: 'Records are stored on-device first and only go online when recognizing a photo. No ads, no user tracking.',
    pp1: 'Local-first storage', pp2: 'Online only to recognize', pp3: 'Zero user tracking', pp4: 'No ads',
    faqTitle: 'Frequently Asked Questions',
    q1: 'Does AI food recognition need internet?', a1: 'Photo recognition is done by AI and needs a connection to upload and analyze the image. Browsing records and viewing your data works on-device.',
    q2: 'Which devices and systems are supported?', a2: 'iPhone and iPad are supported. A recent iOS / iPadOS version is recommended for the full experience.',
    q3: 'What nutrition data can it track?', a3: 'Calories, protein, carbohydrates and fat, plus daily water intake, BMI and weight trends.',
    q4: 'How else can I add food besides photos?', a4: 'Beyond photo recognition, you can pick a photo from your album, search the food library, or enter items manually.',
    q5: 'Is it bilingual? Is it free?', a5: 'The interface supports Simplified Chinese and English, and the app is free to download.',
    downloadTitle: 'Download Food Calories Now', downloadSubtitle: 'Snap a photo and start clearer nutrition tracking.', downloadNote: 'Free download · iPhone & iPad',
    footerRights: 'AI卡路里 / Food Calories. All rights reserved.', footerMadeBy: 'Built by WeiProduct',
    stickySub: 'AI photo recognition · Free', stickyGet: 'Get',
    eyeHow: 'How it works', eyeDemo: 'Interactive demo', eyeFeatures: 'Features', eyePersonas: 'Who it’s for', eyeScreens: 'A look inside', eyeMethod: 'Under the hood', eyeCompare: 'Comparison', eyePrivacy: 'Privacy', eyeFaq: 'Good to know',
    demoTitle: 'See how recognition feels', demoSub: 'Tap a sample meal and watch an AI-style estimate appear.',
    demoFood1: '🍜 Ramen', demoFood2: '🥗 Salad bowl', demoFood3: '🍕 Pizza slice', demoFood4: '🍱 Bento',
    demoPlaceholder: 'Pick a sample meal above', demoScanning: 'AI recognizing…',
    demoDisclaimer: 'Sample estimate — values in-app are per your photo.',
    personaTitle: 'Made for how you eat', personaSub: 'Different goals, one lower-effort way to log.',
    persona1Name: 'Weight-loss starter', persona1Pain: 'Tired of guessing what a meal costs you?', persona1Win: 'Snap it and see the number.',
    persona2Name: 'Gym & protein tracker', persona2Pain: 'Protein targets shouldn’t need spreadsheet math.', persona2Win: 'Macros are estimated automatically, at a glance.',
    persona3Name: 'Busy 9-to-6', persona3Pain: 'Too busy to log meals at a desk.', persona3Win: 'Log lunch in the elevator instead.',
    persona4Name: 'Habit keeper', persona4Pain: 'Water, weight and meals scattered across apps.', persona4Win: 'One daily loop keeps them together.',
    methodTitle: 'From photo to macros', methodSub: 'How one photo becomes calories and macros — including the honest limits.',
    methodStep1: 'Your photo', methodStep2: 'AI vision', methodStep3: 'Food match', methodStep4: 'Portion estimate', methodStep5: 'Calories + P/C/F',
    methodNote1: 'Estimates, not lab values — edit anything with a tap.', methodNote2: 'Works with album photos and manual search too.', methodNote3: 'Only the recognition step goes online.',
    cmpTitle: 'Why snap instead of type', cmpSub: 'No named competitors — just the effort it takes to log one meal.',
    cmpCol0: 'Task', cmpCol1: 'Food Calories', cmpCol2: 'Manual calorie apps', cmpCol3: 'Notes & spreadsheets',
    cmpRow1: 'Logging one meal', cmpRow2: 'Protein · carbs · fat', cmpRow3: 'Water & weight in one app', cmpRow4: 'Ads & tracking', cmpRow5: 'EN / 中文 bilingual',
    cmpCell1a: 'One photo', cmpCell1b: 'Search each item', cmpCell1c: 'Type everything',
    cmpCell2a: 'Auto-estimated', cmpCell2b: 'Manual lookup', cmpCell2c: 'Manual math',
    cmpBuiltIn: 'Built in', cmpVaries: 'Varies', cmpNone: 'None',
    footTagline: 'Snap a photo, see your nutrition clearly.', footLinksTitle: 'Quick links', footPrefsTitle: 'Preferences', footTheme: 'Toggle theme', footDownload: 'Download',
    /* AI-AVATAR */
    aiTitle: 'AI Avatar · Food Calories Assistant',
    aiGreeting: 'Hi! I\'m the AI avatar for Food Calories 🥗 Ask me about photo recognition, nutrition tracking, privacy, or pricing.',
    aiPlaceholder: 'Type your question…',
    aiSend: 'Send',
    aiChip1: 'How does photo calorie counting work?',
    aiChip2: 'Is my food data private?',
    aiChip3: 'Is it free? Which devices?',
    aiDisclaimer: 'AI-generated · for reference only',
    aiError: 'Sorry, the assistant is temporarily unreachable — please try again later. （抱歉，AI 助手暂时连不上，请稍后再试。）'
    /* /AI-AVATAR */
  }
};

let currentLang = 'zh-CN';

function applyLang(lang) {
  currentLang = I18N[lang] ? lang : 'zh-CN';
  const t = I18N[currentLang];
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const k = el.getAttribute('data-i18n');
    if (t[k] !== undefined) el.textContent = t[k];
  });
  /* AI-AVATAR: translate placeholder attributes */
  document.querySelectorAll('[data-i18n-ph]').forEach(el => {
    const k = el.getAttribute('data-i18n-ph');
    if (t[k] !== undefined) el.setAttribute('placeholder', t[k]);
  });
  /* /AI-AVATAR */
  document.documentElement.lang = currentLang;
  const ls = document.getElementById('langSwitch');
  if (ls) ls.textContent = currentLang === 'zh-CN' ? 'EN' : '中文';
  const fl = document.getElementById('footLang');
  if (fl) fl.textContent = currentLang === 'zh-CN' ? 'EN' : '中文';
  try { localStorage.setItem('lang', currentLang); } catch (e) {}
}

function initLang() {
  let saved;
  try { saved = localStorage.getItem('lang'); } catch (e) {}
  if (!saved) saved = (navigator.language || '').toLowerCase().startsWith('zh') ? 'zh-CN' : 'en';
  applyLang(saved);
}

// ===== Theme =====
function setTheme(theme) {
  document.documentElement.setAttribute('data-theme', theme);
  const meta = document.getElementById('themeColorMeta');
  if (meta) meta.setAttribute('content', theme === 'dark' ? '#0b0f0e' : '#19a974');
  try { localStorage.setItem('theme', theme); } catch (e) {}
}
function initTheme() {
  let saved;
  try { saved = localStorage.getItem('theme'); } catch (e) {}
  if (!saved) saved = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  setTheme(saved);
}

// ===== Eased number counter =====
function animateCount(el, target, dur, fmt) {
  const t0 = performance.now();
  const tick = (now) => {
    const p = Math.min(1, (now - t0) / dur);
    const eased = 1 - Math.pow(1 - p, 3);
    el.textContent = fmt(Math.round(target * eased));
    if (p < 1) requestAnimationFrame(tick);
  };
  requestAnimationFrame(tick);
}

// ===== Hero calorie animation =====
function initHero() {
  const device = document.getElementById('heroDevice');
  if (!device) return;
  const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const numEl = document.getElementById('calNum');
  const target = 1250;
  const fmt = (n) => n.toLocaleString('en-US');

  const start = () => {
    device.classList.add('animate');
    if (!numEl) return;
    if (reduce) { numEl.textContent = fmt(target); return; }
    animateCount(numEl, target, 1400, fmt);
  };

  requestAnimationFrame(() => requestAnimationFrame(start));
}

// ===== Try-it recognition demo =====
const DEMO_FOODS = [
  { key: 'demoFood1', kcal: 520, p: 22, c: 74, f: 16, pw: 44, cw: 74, fw: 32 },
  { key: 'demoFood2', kcal: 320, p: 12, c: 26, f: 18, pw: 24, cw: 26, fw: 36 },
  { key: 'demoFood3', kcal: 285, p: 12, c: 36, f: 10, pw: 24, cw: 36, fw: 20 },
  { key: 'demoFood4', kcal: 610, p: 27, c: 82, f: 18, pw: 54, cw: 82, fw: 36 }
];

function initDemo() {
  const card = document.getElementById('demoCard');
  if (!card) return;
  const chips = Array.from(document.querySelectorAll('.demo-chip'));
  const nameEl = document.getElementById('demoFood');
  const kcalEl = document.getElementById('demoKcal');
  const valP = document.getElementById('demoValP');
  const valC = document.getElementById('demoValC');
  const valF = document.getElementById('demoValF');
  const barP = document.getElementById('demoBarP');
  const barC = document.getElementById('demoBarC');
  const barF = document.getElementById('demoBarF');
  const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  let timer = null;
  let started = false;

  function select(i) {
    started = true;
    chips.forEach((c, j) => c.classList.toggle('active', j === i));
    const food = DEMO_FOODS[i];

    const show = () => {
      card.classList.remove('scanning');
      nameEl.setAttribute('data-i18n', food.key);
      nameEl.textContent = I18N[currentLang][food.key];
      valP.textContent = food.p + ' g';
      valC.textContent = food.c + ' g';
      valF.textContent = food.f + ' g';
      barP.style.setProperty('--w', food.pw + '%');
      barC.style.setProperty('--w', food.cw + '%');
      barF.style.setProperty('--w', food.fw + '%');
      card.classList.add('done');
      if (reduce) { kcalEl.textContent = '~' + food.kcal; return; }
      animateCount(kcalEl, food.kcal, 900, (n) => '~' + n);
    };

    if (timer) clearTimeout(timer);
    if (reduce) { show(); return; }
    card.classList.remove('done');
    nameEl.setAttribute('data-i18n', 'demoScanning');
    nameEl.textContent = I18N[currentLang].demoScanning;
    card.classList.remove('scanning');
    void card.offsetWidth;
    card.classList.add('scanning');
    timer = setTimeout(show, 900);
  }

  chips.forEach((c, i) => c.addEventListener('click', () => select(i)));

  if ('IntersectionObserver' in window) {
    const io = new IntersectionObserver((entries) => {
      entries.forEach((en) => {
        if (en.isIntersecting) { io.disconnect(); if (!started) select(0); }
      });
    }, { threshold: 0.4 });
    io.observe(card);
  } else {
    select(0);
  }
}

// ===== Gallery =====
function initGallery() {
  const track = document.getElementById('galTrack');
  if (!track) return;
  const shots = Array.from(track.children);
  const dotsWrap = document.getElementById('galDots');
  const prev = document.getElementById('galPrev');
  const next = document.getElementById('galNext');

  shots.forEach((_, i) => {
    const b = document.createElement('button');
    b.type = 'button';
    b.setAttribute('aria-label', 'screenshot ' + (i + 1));
    if (i === 0) b.classList.add('active');
    b.addEventListener('click', () => shots[i].scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' }));
    dotsWrap.appendChild(b);
  });
  const dots = Array.from(dotsWrap.children);

  function activeIndex() {
    const c = track.scrollLeft + track.clientWidth / 2;
    let best = 0, bd = Infinity;
    shots.forEach((s, i) => {
      const center = s.offsetLeft + s.offsetWidth / 2;
      const d = Math.abs(center - c);
      if (d < bd) { bd = d; best = i; }
    });
    return best;
  }
  track.addEventListener('scroll', () => {
    const i = activeIndex();
    dots.forEach((d, j) => d.classList.toggle('active', j === i));
  }, { passive: true });

  const step = () => (shots[1] ? shots[1].offsetLeft - shots[0].offsetLeft : 300);
  if (prev) prev.addEventListener('click', () => track.scrollBy({ left: -step(), behavior: 'smooth' }));
  if (next) next.addEventListener('click', () => track.scrollBy({ left: step(), behavior: 'smooth' }));

  // Lightbox
  const lb = document.createElement('div');
  lb.className = 'lightbox';
  lb.innerHTML = '<button class="lightbox-close" aria-label="close">&times;</button><img alt="">';
  document.body.appendChild(lb);
  const lbImg = lb.querySelector('img');
  const close = () => lb.classList.remove('open');
  lb.addEventListener('click', e => { if (e.target === lb || e.target.classList.contains('lightbox-close')) close(); });
  document.addEventListener('keydown', e => { if (e.key === 'Escape') close(); });
  track.querySelectorAll('.phone').forEach(p => {
    p.addEventListener('click', () => {
      const img = p.querySelector('img');
      lbImg.src = img.src; lbImg.alt = img.alt;
      lb.classList.add('open');
    });
  });
}

// ===== Scroll reveal =====
function initReveal() {
  const els = document.querySelectorAll('.reveal');
  if (!('IntersectionObserver' in window)) { els.forEach(e => e.classList.add('in')); return; }
  const io = new IntersectionObserver((entries) => {
    entries.forEach(en => {
      if (en.isIntersecting) { en.target.classList.add('in'); io.unobserve(en.target); }
    });
  }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
  els.forEach((el, i) => { el.style.transitionDelay = (Math.min(i, 6) * 0.05) + 's'; io.observe(el); });
}

// ===== Nav + sticky + progress =====
function initScroll() {
  const nav = document.getElementById('navbar');
  const sticky = document.getElementById('stickyCta');
  const prog = document.getElementById('scrollProgress');
  const onScroll = () => {
    const y = window.scrollY;
    if (nav) nav.classList.toggle('scrolled', y > 20);
    if (sticky) sticky.classList.toggle('show', y > 640);
    if (prog) {
      const max = document.documentElement.scrollHeight - window.innerHeight;
      prog.style.width = (max > 0 ? Math.min(100, (y / max) * 100) : 0) + '%';
    }
  };
  window.addEventListener('scroll', onScroll, { passive: true });
  window.addEventListener('resize', onScroll, { passive: true });
  onScroll();
}

// ===== Init =====
document.addEventListener('DOMContentLoaded', () => {
  initTheme();
  initLang();
  initHero();
  initDemo();
  initGallery();
  initReveal();
  initScroll();

  const yr = document.getElementById('currentYear');
  if (yr) yr.textContent = new Date().getFullYear();

  const ls = document.getElementById('langSwitch');
  if (ls) ls.addEventListener('click', () => applyLang(currentLang === 'zh-CN' ? 'en' : 'zh-CN'));
  const tt = document.getElementById('themeToggle');
  if (tt) tt.addEventListener('click', () => setTheme(document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark'));
  const fl = document.getElementById('footLang');
  if (fl) fl.addEventListener('click', () => applyLang(currentLang === 'zh-CN' ? 'en' : 'zh-CN'));
  const ft = document.getElementById('footTheme');
  if (ft) ft.addEventListener('click', () => setTheme(document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark'));

  document.querySelectorAll('a[href^="#"]').forEach(a => {
    a.addEventListener('click', function (e) {
      const id = this.getAttribute('href');
      if (id.length > 1) {
        const target = document.querySelector(id);
        if (target) { e.preventDefault(); target.scrollIntoView({ behavior: 'smooth', block: 'start' }); }
      }
    });
  });
});

/* AI-AVATAR: floating "AI分身" assistant widget */
(function () {
  const AI_PROXY_URL = 'https://personal-portfolio-api-sandy.vercel.app/api/chat-proxy';
  const AI_SYSTEM_PROMPT = [
    'You are the "AI分身" (AI avatar) assistant on the promo website of Food Calories (AI卡路里), an iOS nutrition-tracking app by WeiProduct.',
    '',
    'App facts (the ONLY facts you may state):',
    '- One-liner: snap a photo of your meal and AI instantly estimates calories, protein, carbs and fat — then tracks water, weight and your daily goals.',
    '- Key features: AI photo food recognition (point and shoot, pick from the photo album, search the food library, or enter items manually); macro tracking (calories, protein, carbohydrates, fat); personalized daily calorie goals based on age, sex and activity level; daily water intake, BMI and weight-trend tracking; weekly/monthly intake trends and nutrient analytics; AI results are estimates, not lab values, and can be corrected with one tap.',
    '- Privacy: local-first — records are stored on-device first; internet is used only for the photo-recognition step (the photo is uploaded for analysis); no account required, no ads, no user tracking.',
    '- Platform: iPhone and iPad; a recent iOS / iPadOS version is recommended for the full experience.',
    '- Price: free.',
    '- Languages: English and Simplified Chinese (中文).',
    '- App Store link: https://apps.apple.com/app/id6748717022',
    '',
    'Style rules:',
    '- ALWAYS reply in the same language as the user\'s most recent message: English question → English answer, 中文提问 → 中文回答. Do NOT default to Chinese just because the app has a Chinese name.',
    '- Keep replies to 1-3 short sentences; be friendly and concrete.',
    '- NEVER invent download counts, ratings, reviews, or features not listed above.',
    '- Do not give medical or dietary advice beyond describing what the app tracks.',
    '- If asked about unrelated topics, politely steer the conversation back to Food Calories.',
    '- When the user wants to download or try the app, point them to the App Store link.'
  ].join('\n');
  const AI_MAX_HISTORY = 12;

  document.addEventListener('DOMContentLoaded', () => {
    const toggle = document.getElementById('aiToggle');
    const panel = document.getElementById('aiPanel');
    const closeBtn = document.getElementById('aiClose');
    const msgs = document.getElementById('aiMsgs');
    const chipsWrap = document.getElementById('aiChips');
    const form = document.getElementById('aiForm');
    const input = document.getElementById('aiInput');
    const sendBtn = document.getElementById('aiSendBtn');
    if (!toggle || !panel || !msgs || !form || !input) return;

    let history = [];
    let greeted = false;
    let busy = false;

    function addBubble(role, text, i18nKey) {
      const div = document.createElement('div');
      div.className = 'ai-msg ' + (role === 'user' ? 'user' : 'bot');
      if (i18nKey) {
        div.setAttribute('data-i18n', i18nKey); // follows future language switches too
        div.textContent = I18N[currentLang][i18nKey];
      } else {
        div.textContent = text;
      }
      msgs.appendChild(div);
      msgs.scrollTop = msgs.scrollHeight;
      return div;
    }

    function showTyping() {
      const div = document.createElement('div');
      div.className = 'ai-msg bot ai-typing';
      div.innerHTML = '<span></span><span></span><span></span>';
      msgs.appendChild(div);
      msgs.scrollTop = msgs.scrollHeight;
      return div;
    }

    function openPanel() {
      panel.hidden = false;
      toggle.setAttribute('aria-expanded', 'true');
      if (!greeted) { greeted = true; addBubble('bot', '', 'aiGreeting'); }
      input.focus();
    }
    function closePanel() {
      panel.hidden = true;
      toggle.setAttribute('aria-expanded', 'false');
      toggle.focus();
    }

    async function send(text) {
      text = (text || '').trim();
      if (!text || busy) return;
      busy = true;
      if (sendBtn) sendBtn.disabled = true;
      if (chipsWrap) chipsWrap.hidden = true;
      addBubble('user', text);
      history.push({ role: 'user', content: text });
      history = history.slice(-AI_MAX_HISTORY);
      const typing = showTyping();
      try {
        const res = await fetch(AI_PROXY_URL, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            model: 'gpt-4o-mini',
            messages: [{ role: 'system', content: AI_SYSTEM_PROMPT }].concat(history),
            max_tokens: 350
          })
        });
        if (!res.ok) throw new Error('HTTP ' + res.status);
        const data = await res.json();
        let reply = '';
        if (data && data.choices && data.choices[0]) {
          const m = data.choices[0].message;
          reply = (m && m.content) || data.choices[0].text || '';
        }
        if (!reply && data && typeof data.content === 'string') reply = data.content;
        if (!reply && data && typeof data.reply === 'string') reply = data.reply;
        if (!reply && data && typeof data.message === 'string') reply = data.message;
        reply = (reply || '').trim();
        if (!reply) throw new Error('empty reply');
        typing.remove();
        addBubble('bot', reply);
        history.push({ role: 'assistant', content: reply });
        history = history.slice(-AI_MAX_HISTORY);
      } catch (err) {
        typing.remove();
        addBubble('bot', '', 'aiError');
      } finally {
        busy = false;
        if (sendBtn) sendBtn.disabled = false;
      }
    }

    toggle.addEventListener('click', () => (panel.hidden ? openPanel() : closePanel()));
    if (closeBtn) closeBtn.addEventListener('click', closePanel);
    document.addEventListener('keydown', e => { if (e.key === 'Escape' && !panel.hidden) closePanel(); });
    if (chipsWrap) chipsWrap.querySelectorAll('.ai-chip').forEach(chip => {
      chip.addEventListener('click', () => send(chip.textContent));
    });
    form.addEventListener('submit', e => {
      e.preventDefault();
      const v = input.value;
      input.value = '';
      send(v);
    });

    // Dev/verify affordance: ?aichat=open auto-opens; ?aichat=demo also sends chip 1 for real.
    const q = location.search;
    if (q.indexOf('aichat=open') !== -1 || q.indexOf('aichat=demo') !== -1) {
      openPanel();
      if (q.indexOf('aichat=demo') !== -1) {
        setTimeout(() => send(I18N[currentLang].aiChip1), 600);
      }
    }
  });
})();
/* /AI-AVATAR */
