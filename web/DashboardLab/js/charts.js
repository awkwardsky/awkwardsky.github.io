/* ==========================================================
   Chart.js Global Defaults
   ========================================================== */
Chart.defaults.color = '#55556a';
Chart.defaults.borderColor = 'rgba(255,255,255,0.04)';
Chart.defaults.font.family = "'Inter', sans-serif";
Chart.defaults.font.size = 11;

const gridStyle   = { color: 'rgba(255,255,255,0.04)' };
const noGrid      = { display: false };
const legendStyle = { position: 'top', labels: { usePointStyle: true, padding: 14, boxWidth: 6, font: { size: 11 } } };
const O1 = '#f59e0b';
const O2 = '#fb923c';

const chartOpt = (extra = {}) => ({ responsive: true, maintainAspectRatio: false, ...extra });

/* ==========================================================
   Tab Lazy-Rendering State
   ========================================================== */
const renderedTabs = new Set();

const tabRenderers = {
  'tab-overview':     renderOverviewCharts,
  'tab-revenue':      renderRevenueCharts,
  'tab-engagement':   renderEngagementCharts,
  'tab-performance':  renderPerformanceCharts,
};

/* ==========================================================
   Overview Charts
   ========================================================== */
function renderOverviewCharts() {
  if (renderedTabs.has('overview')) return;
  renderedTabs.add('overview');
  const D = DATA.dates;

  new Chart(document.getElementById('c_active'), {
    type: 'line',
    data: { labels: D, datasets: [
      { label: 'iOS',     data: DATA.ios.active_users,     borderColor: O1, backgroundColor: 'rgba(245,158,11,.08)', fill: true, tension: .35, pointRadius: 3, borderWidth: 2 },
      { label: 'Android', data: DATA.android.active_users, borderColor: O2, backgroundColor: 'rgba(251,146,60,.05)', fill: true, tension: .35, pointRadius: 3, borderWidth: 2 },
    ]},
    options: chartOpt({ plugins: { legend: legendStyle, tooltip: { mode: 'index', intersect: false } }, scales: { y: { grid: gridStyle, ticks: { callback: v => v.toLocaleString() } }, x: { grid: noGrid } } }),
  });

  new Chart(document.getElementById('c_new'), {
    type: 'bar',
    data: { labels: D, datasets: [
      { label: 'iOS',     data: DATA.ios.new_users,     backgroundColor: 'rgba(245,158,11,.85)', borderRadius: 4 },
      { label: 'Android', data: DATA.android.new_users, backgroundColor: 'rgba(251,146,60,.55)', borderRadius: 4 },
    ]},
    options: chartOpt({ plugins: { legend: legendStyle }, scales: { x: { stacked: true, grid: noGrid }, y: { stacked: true, grid: gridStyle } } }),
  });

  const iosTotal = DATA.ios.new_users.reduce((a, b) => a + b, 0);
  const andTotal = DATA.android.new_users.reduce((a, b) => a + b, 0);
  new Chart(document.getElementById('c_platform'), {
    type: 'doughnut',
    data: { labels: ['iOS','Android'], datasets: [{ data: [iosTotal, andTotal], backgroundColor: [O1, O2], borderWidth: 0, hoverOffset: 8 }] },
    options: chartOpt({ cutout: '65%', plugins: { legend: legendStyle } }),
  });

  const ret1Avg = D.map((_, i) => +((DATA.ios.ret_d1[i] + DATA.android.ret_d1[i]) / 2).toFixed(1));
  const ret7Avg = D.map((_, i) => +((DATA.ios.ret_d7[i] + DATA.android.ret_d7[i]) / 2).toFixed(1));
  const ctx = document.getElementById('c_retention').getContext('2d');
  const g1 = ctx.createLinearGradient(0, 0, 0, 220); g1.addColorStop(0, 'rgba(245,158,11,.25)'); g1.addColorStop(1, 'rgba(245,158,11,0)');
  const g2 = ctx.createLinearGradient(0, 0, 0, 220); g2.addColorStop(0, 'rgba(59,130,246,.2)');  g2.addColorStop(1, 'rgba(59,130,246,0)');
  new Chart(ctx, {
    type: 'line',
    data: { labels: D, datasets: [
      { label: 'D1', data: ret1Avg, borderColor: O1,        backgroundColor: g1, fill: true, tension: .3, pointRadius: 3, borderWidth: 2 },
      { label: 'D7', data: ret7Avg, borderColor: '#3b82f6', backgroundColor: g2, fill: true, tension: .3, pointRadius: 3, borderWidth: 2 },
    ]},
    options: chartOpt({ plugins: { legend: legendStyle }, scales: { y: { grid: gridStyle, ticks: { callback: v => v + '%' } }, x: { grid: noGrid } } }),
  });
}

/* ==========================================================
   Revenue Charts
   ========================================================== */
function renderRevenueCharts() {
  if (renderedTabs.has('revenue')) return;
  renderedTabs.add('revenue');
  const D = DATA.dates;

  new Chart(document.getElementById('c_revenue'), {
    type: 'line',
    data: { labels: D, datasets: [
      { label: 'iOS',     data: DATA.ios.revenue,     borderColor: O1, stepped: 'middle', pointRadius: 3, pointBackgroundColor: O1, borderWidth: 2, fill: false },
      { label: 'Android', data: DATA.android.revenue, borderColor: O2, stepped: 'middle', pointRadius: 3, pointBackgroundColor: O2, borderWidth: 2, fill: false },
    ]},
    options: chartOpt({ plugins: { legend: legendStyle }, scales: { y: { grid: gridStyle, ticks: { callback: v => '$' + v.toLocaleString() } }, x: { grid: noGrid } } }),
  });

  new Chart(document.getElementById('c_arpu'), {
    type: 'line',
    data: { labels: D, datasets: [
      { label: 'ARPU (iOS)',     data: DATA.ios.arpu,     borderColor: O1,        borderWidth: 2, pointRadius: 3, tension: .3, yAxisID: 'y' },
      { label: 'ARPU (Android)', data: DATA.android.arpu, borderColor: O2,        borderWidth: 2, pointRadius: 3, tension: .3, yAxisID: 'y' },
      { label: 'ARPPU (iOS)',    data: DATA.ios.arppu,    borderColor: '#3b82f6', borderWidth: 2, pointRadius: 3, tension: .3, borderDash: [4,4], yAxisID: 'y1' },
      { label: 'ARPPU (Android)',data: DATA.android.arppu,borderColor: '#8b5cf6', borderWidth: 2, pointRadius: 3, tension: .3, borderDash: [4,4], yAxisID: 'y1' },
    ]},
    options: chartOpt({ plugins: { legend: legendStyle }, scales: { y: { position: 'left', grid: gridStyle, ticks: { callback: v => '$' + v } }, y1: { position: 'right', grid: { drawOnChartArea: false }, ticks: { callback: v => '$' + v } }, x: { grid: noGrid } } }),
  });

  const ctx = document.getElementById('c_paying').getContext('2d');
  const g  = ctx.createLinearGradient(0, 0, 0, 220); g.addColorStop(0, 'rgba(245,158,11,.2)');  g.addColorStop(1, 'rgba(245,158,11,0)');
  const g2 = ctx.createLinearGradient(0, 0, 0, 220); g2.addColorStop(0, 'rgba(251,146,60,.15)'); g2.addColorStop(1, 'rgba(251,146,60,0)');
  new Chart(ctx, {
    type: 'line',
    data: { labels: D, datasets: [
      { label: 'iOS',     data: DATA.ios.paying_users,     borderColor: O1, backgroundColor: g,  fill: 'origin', tension: .4, pointRadius: 0, borderWidth: 2 },
      { label: 'Android', data: DATA.android.paying_users, borderColor: O2, backgroundColor: g2, fill: 'origin', tension: .4, pointRadius: 0, borderWidth: 2 },
    ]},
    options: chartOpt({ plugins: { legend: legendStyle }, scales: { y: { grid: gridStyle }, x: { grid: noGrid } } }),
  });

  new Chart(document.getElementById('c_revRegion'), {
    type: 'bar',
    data: { labels: DATA.regions.map(r => r.code), datasets: [{
      data: DATA.regions.map(r => r.revenue),
      backgroundColor: DATA.regions.map(r => r.color + 'cc'),
      borderRadius: 4,
    }]},
    options: chartOpt({ indexAxis: 'y', plugins: { legend: { display: false }, tooltip: { callbacks: { label: ctx => '$' + ctx.parsed.x.toLocaleString() } } }, scales: { x: { grid: gridStyle, ticks: { callback: v => '$' + (v / 1000).toFixed(0) + 'k' } }, y: { grid: noGrid } } }),
  });
}

/* ==========================================================
   Engagement Charts
   ========================================================== */
function renderEngagementCharts() {
  if (renderedTabs.has('engagement')) return;
  renderedTabs.add('engagement');
  const D = DATA.dates;

  new Chart(document.getElementById('c_session'), {
    type: 'radar',
    data: { labels: D, datasets: [
      { label: 'iOS',     data: DATA.ios.session,     borderColor: O1, backgroundColor: 'rgba(245,158,11,.1)', pointBackgroundColor: O1, borderWidth: 2 },
      { label: 'Android', data: DATA.android.session, borderColor: O2, backgroundColor: 'rgba(251,146,60,.08)', pointBackgroundColor: O2, borderWidth: 2 },
    ]},
    options: chartOpt({ plugins: { legend: legendStyle }, scales: { r: { grid: { color: 'rgba(255,255,255,0.05)' }, angleLines: { color: 'rgba(255,255,255,0.05)' }, pointLabels: { color: '#666' }, ticks: { display: false }, suggestedMin: 10 } } }),
  });

  new Chart(document.getElementById('c_funnel'), {
    type: 'bar',
    data: { labels: ['Install','Day 1','Day 7','Day 14','Day 30'], datasets: [{
      data: [100, 42.4, 18.2, 11.5, 7.3],
      backgroundColor: ['rgba(245,158,11,.9)','rgba(245,158,11,.7)','rgba(245,158,11,.5)','rgba(245,158,11,.35)','rgba(245,158,11,.2)'],
      borderRadius: 4,
    }]},
    options: chartOpt({ indexAxis: 'y', plugins: { legend: { display: false }, tooltip: { callbacks: { label: ctx => ctx.parsed.x + '%' } } }, scales: { x: { grid: gridStyle, max: 100, ticks: { callback: v => v + '%' } }, y: { grid: noGrid } } }),
  });
}

/* ==========================================================
   Performance Charts
   ========================================================== */
function renderPerformanceCharts() {
  if (renderedTabs.has('performance')) return;
  renderedTabs.add('performance');
  const D = DATA.dates;

  new Chart(document.getElementById('c_crash'), {
    type: 'line',
    data: { labels: D, datasets: [
      { label: 'iOS',     data: DATA.ios.crash,     borderColor: O1, pointBackgroundColor: O1, pointRadius: 5, pointHoverRadius: 7, borderWidth: 2, tension: .2, fill: false },
      { label: 'Android', data: DATA.android.crash, borderColor: O2, pointBackgroundColor: O2, pointRadius: 5, pointHoverRadius: 7, borderWidth: 2, tension: .2, fill: false },
    ]},
    options: chartOpt({ plugins: { legend: legendStyle, tooltip: { callbacks: { label: ctx => `${ctx.dataset.label}: ${ctx.parsed.y}%` } } }, scales: { y: { grid: gridStyle, ticks: { callback: v => v + '%' } }, x: { grid: noGrid } } }),
  });

  const avgApiLast = +((DATA.ios.api[6] + DATA.android.api[6]) / 2).toFixed(1);
  new Chart(document.getElementById('c_api'), {
    type: 'doughnut',
    data: { labels: ['Success','Failure'], datasets: [{
      data: [avgApiLast, 100 - avgApiLast],
      backgroundColor: [O1, 'rgba(255,255,255,0.04)'],
      borderWidth: 0,
    }]},
    options: chartOpt({ cutout: '75%', rotation: -90, circumference: 180, plugins: { legend: { display: false }, tooltip: { callbacks: { label: ctx => ctx.label + ': ' + ctx.parsed.toFixed(1) + '%' } } } }),
  });

  new Chart(document.getElementById('c_fps'), {
    type: 'polarArea',
    data: { labels: D.map(d => 'iOS ' + d).concat(D.map(d => 'And ' + d)), datasets: [{
      data: DATA.ios.fps.concat(DATA.android.fps),
      backgroundColor: [
        ...D.map((_, i) => `rgba(245,158,11,${.25 + i * .1})`),
        ...D.map((_, i) => `rgba(251,146,60,${.2 + i * .09})`),
      ],
    }]},
    options: chartOpt({ plugins: { legend: { display: false } }, scales: { r: { grid: { color: 'rgba(255,255,255,0.04)' }, ticks: { display: false }, suggestedMin: 50 } } }),
  });

  new Chart(document.getElementById('c_latency'), {
    type: 'bar',
    data: { labels: D, datasets: [
      { type: 'line', label: 'P50', data: DATA.latency.p50, borderColor: '#10b981', borderWidth: 2, pointRadius: 3, tension: .3, order: 0, fill: false },
      { type: 'bar',  label: 'P95', data: DATA.latency.p95, backgroundColor: 'rgba(245,158,11,.5)', borderRadius: 3, order: 1 },
      { type: 'bar',  label: 'P99', data: DATA.latency.p99, backgroundColor: 'rgba(239,68,68,.35)', borderRadius: 3, order: 2 },
    ]},
    options: chartOpt({ plugins: { legend: legendStyle, tooltip: { callbacks: { label: ctx => `${ctx.dataset.label}: ${ctx.parsed.y}ms` } } }, scales: { y: { grid: gridStyle, ticks: { callback: v => v + 'ms' } }, x: { grid: noGrid } } }),
  });
}

/* ==========================================================
   Team Activity Chart
   ========================================================== */
function renderTeamChart() {
  new Chart(document.getElementById('c_team'), {
    type: 'bar',
    data: { labels: DATA.teamActivity.labels, datasets: [
      { label: 'Commits', data: DATA.teamActivity.commits, backgroundColor: 'rgba(245,158,11,.7)',  borderRadius: 3 },
      { label: 'PRs',     data: DATA.teamActivity.prs,     backgroundColor: 'rgba(59,130,246,.6)',  borderRadius: 3 },
      { label: 'Deploys', data: DATA.teamActivity.deploys, backgroundColor: 'rgba(16,185,129,.6)',  borderRadius: 3 },
    ]},
    options: chartOpt({ plugins: { legend: legendStyle }, scales: { x: { grid: noGrid }, y: { grid: gridStyle } } }),
  });
}

/* ==========================================================
   Render Entry Point
   ========================================================== */
function renderCharts() {
  renderOverviewCharts();
  renderTeamChart();
}
