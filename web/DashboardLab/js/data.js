/* ==========================================================
   Mock Data
   ========================================================== */
const DATA = {
  dates: ['03-01','03-02','03-03','03-04','03-05','03-06','03-07'],

  ios: {
    new_users:    [320, 305, 342, 355, 360, 372, 380],
    active_users: [4200,4155,4318,4402,4475,4550,4628],
    paying_users: [168, 159, 176, 182, 188, 194, 199],
    revenue:      [4520.5,4380,4695.9,4815.3,4950,5092.8,5210.6],
    arpu:         [1.08,1.05,1.09,1.09,1.11,1.12,1.13],
    arppu:        [26.91,27.55,26.68,26.46,26.33,26.25,26.18],
    ret_d1:       [42.3,41.9,43.1,43.8,44.0,44.5,44.8],
    ret_d7:       [18.4,18.0,18.7,19.1,19.3,19.7,20.0],
    crash:        [0.42,0.40,0.39,0.36,0.35,0.34,0.33],
    session:      [12.6,12.8,13.0,13.2,13.4,13.5,13.7],
    fps:          [58.4,58.1,58.6,58.9,59.0,59.2,59.3],
    api:          [99.2,99.3,99.4,99.5,99.5,99.6,99.6],
  },

  android: {
    new_users:    [410, 398, 425, 438, 445, 452, 460],
    active_users: [5100,5032,5195,5288,5366,5439,5518],
    paying_users: [201, 194, 209, 216, 221, 226, 231],
    revenue:      [4988.2,4876.6,5120.4,5268.1,5388.4,5486.2,5599.9],
    arpu:         [0.98,0.97,0.99,1.00,1.00,1.01,1.01],
    arppu:        [24.82,25.14,24.50,24.39,24.38,24.28,24.24],
    ret_d1:       [39.8,39.2,40.1,40.5,40.9,41.2,41.6],
    ret_d7:       [16.1,15.8,16.3,16.8,17.0,17.3,17.5],
    crash:        [0.67,0.64,0.66,0.61,0.59,0.57,0.56],
    session:      [11.9,11.7,12.0,12.2,12.3,12.4,12.6],
    fps:          [54.7,54.4,54.9,55.1,55.4,55.6,55.8],
    api:          [98.8,98.7,98.9,99.0,99.1,99.1,99.2],
  },

  regions: [
    { code: 'NA',    name: 'North America',       users: 38420, revenue: 28950, growth: 12.3, color: '#f59e0b' },
    { code: 'EU',    name: 'Europe',               users: 27180, revenue: 19840, growth: 8.7,  color: '#3b82f6' },
    { code: 'APAC',  name: 'Asia Pacific',         users: 41200, revenue: 15620, growth: 22.1, color: '#10b981' },
    { code: 'LATAM', name: 'Latin America',         users: 12850, revenue: 6240,  growth: 15.4, color: '#8b5cf6' },
    { code: 'MEA',   name: 'Middle East & Africa',  users: 8760,  revenue: 3890,  growth: 31.2, color: '#f43f5e' },
    { code: 'OCE',   name: 'Oceania',               users: 4210,  revenue: 3180,  growth: 5.8,  color: '#06b6d4' },
  ],

  latency: {
    p50: [42,44,41,39,38,40,37],
    p95: [120,135,118,112,108,115,105],
    p99: [280,310,265,248,240,255,230],
  },

  activities: [
    { type: 'deploy', title: 'v1.2.1 deployed to production',   meta: '2 hours ago — by CI/CD',      body: 'All health checks passed. Zero-downtime deployment.' },
    { type: 'alert',  title: 'Crash rate spike on Android',      meta: '5 hours ago — auto-detected',  body: 'Crash rate reached 0.67% on Android 14 devices. Auto-resolved after hotfix.' },
    { type: 'update', title: 'Database migration completed',     meta: '8 hours ago — by Haru',        body: 'Schema v42 applied. Added index on user_events.created_at.' },
    { type: 'info',   title: 'Weekly retention report generated', meta: '1 day ago — scheduled',        body: 'D7 retention improved +1.6pp week-over-week across all platforms.' },
    { type: 'deploy', title: 'v1.2.0 deployed to staging',      meta: '2 days ago — by CI/CD',        body: 'New onboarding flow A/B test enabled for 20% of new users.' },
    { type: 'alert',  title: 'API latency warning',              meta: '3 days ago — monitoring',      body: 'P99 latency exceeded 300ms for 12 minutes. Root cause: cache cold start.' },
  ],

  systems: [
    { name: 'API Gateway',      status: 'ok',   uptime: 99.98, latency: '38ms',  label: 'Operational' },
    { name: 'Database Primary', status: 'ok',   uptime: 99.99, latency: '4ms',   label: 'Operational' },
    { name: 'Redis Cache',      status: 'warn', uptime: 99.85, latency: '12ms',  label: 'Degraded' },
    { name: 'CDN Edge',         status: 'ok',   uptime: 100,   latency: '8ms',   label: 'Operational' },
    { name: 'Search Service',   status: 'ok',   uptime: 99.94, latency: '65ms',  label: 'Operational' },
    { name: 'ML Pipeline',      status: 'warn', uptime: 98.5,  latency: '340ms', label: 'Slow' },
  ],

  alerts: [
    { severity: 'warn', title: 'Redis cache hit ratio dropped to 82%',  time: '35 min ago',  body: 'Expected >95%. Investigate key eviction policy.' },
    { severity: 'err',  title: 'Payment webhook failures (3 events)',    time: '1 hour ago',  body: 'Stripe webhook endpoint returning 503. Retry queue active.' },
    { severity: 'warn', title: 'ML inference latency >500ms',           time: '2 hours ago', body: 'Recommendation model serving above SLA. Consider scaling replicas.' },
  ],

  releases: [
    { version: 'v1.2.1', date: '2026-03-04', type: 'patch', notes: ['Fixed Android 14 crash in onboarding flow','Improved API response caching','Updated push notification SDK'] },
    { version: 'v1.2.0', date: '2026-03-01', type: 'minor', notes: ['New A/B testing framework','Dark mode for settings page','Regional pricing support','Performance: 15% faster cold start'] },
    { version: 'v1.1.9', date: '2026-02-22', type: 'patch', notes: ['Security patch for session handling','Fixed timezone bug in analytics'] },
  ],

  teamActivity: {
    labels: ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'],
    commits: [24,31,28,35,22,8,5],
    prs: [6,8,5,9,7,2,1],
    deploys: [2,3,2,4,2,1,0],
  },
};

/* ==========================================================
   Table Data
   ========================================================== */
const TABLE_HEADERS = ['Date','Platform','Version','New Users','Active','Paying','Revenue','ARPU','ARPPU','Ret D1','Ret D7','Crash','Session','FPS','API %'];

const TABLE_DATA = [
  ['2026-03-01','iOS','1.2.0',320,4200,168,'$4,520',1.08,26.91,'42.3%','18.4%','0.42%',12.6,58.4,'99.2%'],
  ['2026-03-01','Android','1.2.0',410,5100,201,'$4,988',0.98,24.82,'39.8%','16.1%','0.67%',11.9,54.7,'98.8%'],
  ['2026-03-02','iOS','1.2.0',305,4155,159,'$4,380',1.05,27.55,'41.9%','18.0%','0.40%',12.8,58.1,'99.3%'],
  ['2026-03-02','Android','1.2.0',398,5032,194,'$4,877',0.97,25.14,'39.2%','15.8%','0.64%',11.7,54.4,'98.7%'],
  ['2026-03-03','iOS','1.2.0',342,4318,176,'$4,696',1.09,26.68,'43.1%','18.7%','0.39%',13.0,58.6,'99.4%'],
  ['2026-03-03','Android','1.2.0',425,5195,209,'$5,120',0.99,24.50,'40.1%','16.3%','0.66%',12.0,54.9,'98.9%'],
  ['2026-03-04','iOS','1.2.1',355,4402,182,'$4,815',1.09,26.46,'43.8%','19.1%','0.36%',13.2,58.9,'99.5%'],
  ['2026-03-04','Android','1.2.1',438,5288,216,'$5,268',1.00,24.39,'40.5%','16.8%','0.61%',12.2,55.1,'99.0%'],
  ['2026-03-05','iOS','1.2.1',360,4475,188,'$4,950',1.11,26.33,'44.0%','19.3%','0.35%',13.4,59.0,'99.5%'],
  ['2026-03-05','Android','1.2.1',445,5366,221,'$5,388',1.00,24.38,'40.9%','17.0%','0.59%',12.3,55.4,'99.1%'],
  ['2026-03-06','iOS','1.2.1',372,4550,194,'$5,093',1.12,26.25,'44.5%','19.7%','0.34%',13.5,59.2,'99.6%'],
  ['2026-03-06','Android','1.2.1',452,5439,226,'$5,486',1.01,24.28,'41.2%','17.3%','0.57%',12.4,55.6,'99.1%'],
  ['2026-03-07','iOS','1.2.1',380,4628,199,'$5,211',1.13,26.18,'44.8%','20.0%','0.33%',13.7,59.3,'99.6%'],
  ['2026-03-07','Android','1.2.1',460,5518,231,'$5,600',1.01,24.24,'41.6%','17.5%','0.56%',12.6,55.8,'99.2%'],
];

/* ==========================================================
   Utility Helpers
   ========================================================== */
const sum   = (a, b) => a.map((v, i) => v + b[i]);
const last  = (arr) => arr[arr.length - 1];
const prev  = (arr) => arr[arr.length - 2];
const delta = (arr) => (((last(arr) - prev(arr)) / prev(arr)) * 100).toFixed(1);
