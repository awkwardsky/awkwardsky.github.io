/* ==========================================================
   SVG Icon Map (for KPI cards)
   ========================================================== */
const KPI_ICONS = {
  users:      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>',
  'user-plus':'<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="20" y1="8" x2="20" y2="14"/><line x1="23" y1="11" x2="17" y2="11"/></svg>',
  dollar:     '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>',
  credit:     '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><rect x="1" y="4" width="22" height="16" rx="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>',
  repeat:     '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="17 1 21 5 17 9"/><path d="M3 11V9a4 4 0 0 1 4-4h14"/><polyline points="7 23 3 19 7 15"/><path d="M21 13v2a4 4 0 0 1-4 4H3"/></svg>',
  target:     '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/></svg>',
  alert:      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>',
  check:      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>',
};

/* ==========================================================
   KPI Cards
   ========================================================== */
function renderKPIs() {
  const totalActive  = sum(DATA.ios.active_users, DATA.android.active_users);
  const totalNew     = sum(DATA.ios.new_users, DATA.android.new_users);
  const totalRevenue = sum(DATA.ios.revenue, DATA.android.revenue);
  const totalPaying  = sum(DATA.ios.paying_users, DATA.android.paying_users);
  const avgRet1  = DATA.dates.map((_, i) => +((DATA.ios.ret_d1[i] + DATA.android.ret_d1[i]) / 2).toFixed(1));
  const avgRet7  = DATA.dates.map((_, i) => +((DATA.ios.ret_d7[i] + DATA.android.ret_d7[i]) / 2).toFixed(1));
  const avgCrash = DATA.dates.map((_, i) => +((DATA.ios.crash[i] + DATA.android.crash[i]) / 2).toFixed(2));
  const avgApi   = DATA.dates.map((_, i) => +((DATA.ios.api[i] + DATA.android.api[i]) / 2).toFixed(1));

  const kpis = [
    { label: 'Active Users',  value: last(totalActive),                  fmt: 'num',    trend: delta(totalActive),  spark: totalActive,  icon: 'users',     color: 'var(--accent)', bg: 'var(--accent-dim)' },
    { label: 'New Users (7d)',value: totalNew.reduce((a,b) => a+b, 0),   fmt: 'num',    trend: delta(totalNew),     spark: totalNew,     icon: 'user-plus', color: 'var(--blue)',   bg: 'var(--blue-dim)' },
    { label: 'Revenue',       value: last(totalRevenue),                 fmt: 'dollar', trend: delta(totalRevenue), spark: totalRevenue, icon: 'dollar',    color: 'var(--green)',  bg: 'var(--green-dim)' },
    { label: 'Paying Users',  value: last(totalPaying),                  fmt: 'num',    trend: delta(totalPaying),  spark: totalPaying,  icon: 'credit',    color: 'var(--purple)', bg: 'var(--purple-dim)' },
    { label: 'Retention D1',  value: last(avgRet1),  fmt: 'pct', trend: (last(avgRet1) - prev(avgRet1)).toFixed(1),  spark: avgRet1,  icon: 'repeat', color: 'var(--accent)', bg: 'var(--accent-dim)', trendPP: true },
    { label: 'Retention D7',  value: last(avgRet7),  fmt: 'pct', trend: (last(avgRet7) - prev(avgRet7)).toFixed(1),  spark: avgRet7,  icon: 'target', color: 'var(--blue)',   bg: 'var(--blue-dim)',   trendPP: true },
    { label: 'Crash Rate',    value: last(avgCrash), fmt: 'pct', trend: delta(avgCrash), spark: avgCrash, icon: 'alert', color: 'var(--red)',   bg: 'var(--red-dim)',   invertTrend: true },
    { label: 'API Success',   value: last(avgApi),   fmt: 'pct', trend: delta(avgApi),   spark: avgApi,   icon: 'check', color: 'var(--green)', bg: 'var(--green-dim)' },
  ];

  const grid = document.getElementById('kpiGrid');
  grid.innerHTML = kpis.map((k, idx) => {
    const isUp = +k.trend >= 0;
    const goodUp = k.invertTrend ? !isUp : isUp;
    const fmtVal = k.fmt === 'dollar' ? `$${(k.value / 1000).toFixed(1)}k`
                 : k.fmt === 'pct'    ? `${k.value}%`
                 : k.value.toLocaleString();
    const trendLabel = k.trendPP ? `${Math.abs(k.trend)}pp` : `${Math.abs(k.trend)}%`;
    const arrowSvg = isUp
      ? '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="18 15 12 9 6 15"/></svg>'
      : '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="6 9 12 15 18 9"/></svg>';

    return `
    <div class="kpi-card gradient-border" data-idx="${idx}">
      <div class="kpi-header">
        <span class="kpi-label">${k.label}</span>
        <div class="kpi-icon" style="background:${k.bg};color:${k.color}">${KPI_ICONS[k.icon]}</div>
      </div>
      <div class="kpi-value" data-target="${k.value}" data-fmt="${k.fmt}">0</div>
      <div class="kpi-footer">
        <span class="kpi-trend ${goodUp ? 'up' : 'down'}">${arrowSvg} ${trendLabel}</span>
        <span class="kpi-sub">vs previous day</span>
      </div>
      <div class="kpi-spark-wrap"><canvas id="spark_${idx}"></canvas></div>
    </div>`;
  }).join('');

  // Sparklines
  kpis.forEach((k, idx) => {
    new Chart(document.getElementById(`spark_${idx}`), {
      type: 'line',
      data: { labels: DATA.dates, datasets: [{ data: k.spark, borderColor: k.color, borderWidth: 1.5, pointRadius: 0, tension: 0.4, fill: false }] },
      options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false }, tooltip: { enabled: false } }, scales: { x: { display: false }, y: { display: false } } },
    });
  });

  animateNumbers();
}

/* ==========================================================
   Count-up Animation
   ========================================================== */
function animateNumbers() {
  document.querySelectorAll('.kpi-value[data-target]').forEach(el => {
    const target = parseFloat(el.dataset.target);
    const fmt = el.dataset.fmt;
    const duration = 1200;
    const start = performance.now();

    function tick(now) {
      const progress = Math.min((now - start) / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      const current = target * eased;

      if (fmt === 'dollar')    el.textContent = `$${(current / 1000).toFixed(1)}k`;
      else if (fmt === 'pct')  el.textContent = `${current.toFixed(1)}%`;
      else                     el.textContent = Math.round(current).toLocaleString();

      if (progress < 1) requestAnimationFrame(tick);
    }
    requestAnimationFrame(tick);
  });
}

/* ==========================================================
   Regions
   ========================================================== */
function renderRegions() {
  document.getElementById('regionGrid').innerHTML = DATA.regions.map(r => `
    <div class="region-block">
      <div class="region-name">${r.code}</div>
      <div class="region-value" style="color:${r.color}">${(r.users / 1000).toFixed(1)}k</div>
      <div class="region-sub">${r.name}</div>
      <div style="margin-top:6px;font-size:11px">
        <span style="color:var(--green)">+${r.growth}%</span>
        <span style="color:var(--text-muted);margin-left:4px">$${(r.revenue / 1000).toFixed(1)}k rev</span>
      </div>
      <div class="progress-bar" style="margin-top:8px"><div class="progress-bar-fill accent" style="width:${r.growth * 2.5}%"></div></div>
    </div>
  `).join('');
}

/* ==========================================================
   Data Table (sortable + searchable)
   ========================================================== */
let sortCol = -1;
let sortAsc = true;
let tableData = [...TABLE_DATA];

function renderTable() {
  document.getElementById('tableHead').innerHTML = TABLE_HEADERS.map((h, i) =>
    `<th onclick="sortTable(${i})" class="${sortCol === i ? 'sorted' : ''}">${h} <span class="sort-icon">${sortCol === i ? (sortAsc ? '&#9650;' : '&#9660;') : '&#8693;'}</span></th>`
  ).join('');

  document.getElementById('tableBody').innerHTML = tableData.map(row =>
    '<tr>' + row.map(cell => `<td>${cell}</td>`).join('') + '</tr>'
  ).join('');
}

function sortTable(col) {
  if (sortCol === col) sortAsc = !sortAsc;
  else { sortCol = col; sortAsc = true; }

  tableData.sort((a, b) => {
    let va = a[col], vb = b[col];
    if (typeof va === 'string') { va = va.replace(/[$,%]/g, ''); vb = vb.replace(/[$,%]/g, ''); }
    const na = parseFloat(va), nb = parseFloat(vb);
    if (!isNaN(na) && !isNaN(nb)) return sortAsc ? na - nb : nb - na;
    return sortAsc ? String(va).localeCompare(String(vb)) : String(vb).localeCompare(String(va));
  });
  renderTable();
}

function initTableSearch() {
  document.getElementById('tableSearch').addEventListener('input', function () {
    const q = this.value.toLowerCase();
    tableData = TABLE_DATA.filter(row => row.some(cell => String(cell).toLowerCase().includes(q)));
    renderTable();
  });
}

/* ==========================================================
   Timeline
   ========================================================== */
function renderTimeline() {
  document.getElementById('activityTimeline').innerHTML = DATA.activities.map(a => `
    <div class="timeline-item">
      <div class="timeline-dot ${a.type}"></div>
      <div class="timeline-title">${a.title}</div>
      <div class="timeline-meta">${a.meta}</div>
      <div class="timeline-body">${a.body}</div>
    </div>
  `).join('');
}

/* ==========================================================
   System Status
   ========================================================== */
function renderStatus() {
  document.getElementById('statusGrid').innerHTML = DATA.systems.map(s => `
    <div class="status-card">
      <div class="status-card-header">
        <span class="status-card-title"><span class="status-dot ${s.status === 'ok' ? 'green' : s.status === 'warn' ? 'yellow' : 'red'}"></span>${s.name}</span>
        <span class="status-tag ${s.status === 'ok' ? 'ok' : s.status === 'warn' ? 'warn' : 'err'}">${s.label}</span>
      </div>
      <div style="display:flex;justify-content:space-between;font-size:11px;color:var(--text-muted)">
        <span>Uptime: ${s.uptime}%</span><span>Latency: ${s.latency}</span>
      </div>
      <div class="progress-bar"><div class="progress-bar-fill ${s.uptime >= 99.9 ? 'green' : s.uptime >= 99 ? 'accent' : 'red'}" style="width:${s.uptime}%"></div></div>
    </div>
  `).join('');
}

/* ==========================================================
   Alerts
   ========================================================== */
function renderAlerts() {
  document.getElementById('alertsList').innerHTML = DATA.alerts.map(a => `
    <div class="status-card" style="margin-bottom:10px;border-left:3px solid var(--${a.severity === 'err' ? 'red' : 'accent'})">
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:6px">
        <span style="font-size:13px;font-weight:600">${a.title}</span>
        <span class="status-tag ${a.severity === 'err' ? 'err' : 'warn'}">${a.severity === 'err' ? 'Critical' : 'Warning'}</span>
      </div>
      <div style="font-size:11px;color:var(--text-muted);margin-bottom:4px">${a.time}</div>
      <div style="font-size:12px;color:var(--text-secondary)">${a.body}</div>
    </div>
  `).join('');
}

/* ==========================================================
   Releases
   ========================================================== */
function renderReleases() {
  document.getElementById('releaseList').innerHTML = DATA.releases.map(r => `
    <div class="status-card" style="margin-bottom:10px">
      <div style="display:flex;align-items:center;gap:10px;margin-bottom:10px">
        <span style="font-size:15px;font-weight:700">${r.version}</span>
        <span class="status-tag ${r.type === 'minor' ? 'ok' : 'warn'}">${r.type}</span>
        <span style="font-size:11px;color:var(--text-muted);margin-left:auto">${r.date}</span>
      </div>
      <ul style="padding-left:18px;font-size:12px;color:var(--text-secondary);display:flex;flex-direction:column;gap:4px">
        ${r.notes.map(n => `<li>${n}</li>`).join('')}
      </ul>
    </div>
  `).join('');
}

/* ==========================================================
   Loading Skeleton
   ========================================================== */
function showLoading() {
  document.getElementById('kpiGrid').innerHTML = Array(8).fill(0).map(() =>
    '<div class="kpi-card"><div class="skeleton" style="height:14px;width:80px;margin-bottom:12px"></div><div class="skeleton" style="height:32px;width:120px;margin-bottom:8px"></div><div class="skeleton" style="height:12px;width:100px"></div></div>'
  ).join('');
}
