/* ==========================================================
   Mobile Sidebar
   ========================================================== */
function toggleSidebar() {
  const sb = document.getElementById('sidebar');
  const bd = document.getElementById('sidebarBackdrop');
  const open = sb.classList.toggle('open');
  bd.classList.toggle('visible', open);
}

function closeSidebar() {
  document.getElementById('sidebar').classList.remove('open');
  document.getElementById('sidebarBackdrop').classList.remove('visible');
}

/* ==========================================================
   Toast
   ========================================================== */
function showToast(msg, color = 'accent') {
  const container = document.getElementById('toastContainer');
  const toast = document.createElement('div');
  toast.className = 'toast';
  toast.innerHTML = `
    <svg class="toast-icon" viewBox="0 0 24 24" fill="none" stroke="var(--${color})" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
    <span class="toast-msg">${msg}</span>
    <button class="toast-close" onclick="this.parentElement.remove()">&times;</button>
  `;
  container.appendChild(toast);
  setTimeout(() => { if (toast.parentElement) toast.remove(); }, 4000);
}

/* ==========================================================
   Modal
   ========================================================== */
function openModal(title, body, showExport = false) {
  document.getElementById('modalTitle').textContent = title;

  const bodyEl = document.getElementById('modalBody');
  if (typeof body === 'string' && body.startsWith('<')) {
    bodyEl.innerHTML = body;
  } else {
    bodyEl.textContent = body;
  }

  const actions = document.querySelector('.modal-actions');
  if (showExport) {
    actions.innerHTML = `
      <button class="btn" onclick="closeModal()">Cancel</button>
      <button class="btn" onclick="closeModal(); exportJSON()">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" style="width:14px;height:14px"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
        JSON
      </button>
      <button class="btn btn-primary" onclick="closeModal(); exportCSV()">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" style="width:14px;height:14px"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
        CSV
      </button>
    `;
  } else {
    actions.innerHTML = `<button class="btn btn-primary" onclick="closeModal()">Close</button>`;
  }
  document.getElementById('modalOverlay').classList.add('open');
}

function closeModal() {
  document.getElementById('modalOverlay').classList.remove('open');
}

function getNotificationsHTML() {
  return `<div style="display:flex;flex-direction:column;gap:10px;font-size:12px;max-height:300px;overflow-y:auto">
    <div style="padding:8px 0;border-bottom:1px solid var(--border)"><strong style="color:var(--red)">Critical</strong> — Payment webhook failures detected <span style="color:var(--text-muted);margin-left:8px">1h ago</span></div>
    <div style="padding:8px 0;border-bottom:1px solid var(--border)"><strong style="color:var(--accent)">Warning</strong> — Redis cache hit ratio below threshold <span style="color:var(--text-muted);margin-left:8px">35m ago</span></div>
    <div style="padding:8px 0;border-bottom:1px solid var(--border)"><strong style="color:var(--green)">Success</strong> — v1.2.1 deployed to production <span style="color:var(--text-muted);margin-left:8px">2h ago</span></div>
    <div style="padding:8px 0"><strong style="color:var(--blue)">Info</strong> — Weekly report generated <span style="color:var(--text-muted);margin-left:8px">1d ago</span></div>
  </div>`;
}

/* ==========================================================
   Export (CSV / JSON)
   ========================================================== */
function exportCSV() {
  const header = TABLE_HEADERS.join(',');
  const rows = TABLE_DATA.map(row => row.map(cell => {
    const s = String(cell);
    return s.includes(',') ? `"${s}"` : s;
  }).join(','));
  downloadFile([header, ...rows].join('\n'), 'DashboardLabExport.csv', 'text/csv');
  showToast('CSV file downloaded', 'green');
}

function exportJSON() {
  const json = TABLE_DATA.map(row => {
    const obj = {};
    TABLE_HEADERS.forEach((h, i) => obj[h] = row[i]);
    return obj;
  });
  downloadFile(JSON.stringify({ exported: new Date().toISOString(), data: json }, null, 2), 'DashboardLabExport.json', 'application/json');
  showToast('JSON file downloaded', 'green');
}

function downloadFile(content, filename, mimeType) {
  const blob = new Blob([content], { type: mimeType });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}

/* ==========================================================
   Command Palette
   ========================================================== */
const CMD_ITEMS = [
  { icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>', label: 'Go to Overview', shortcut: 'D', action: () => { location.hash = '#hero'; } },
  { icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>', label: 'View KPI Metrics', shortcut: 'K', action: () => { location.hash = '#kpi-section'; } },
  { icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>', label: 'View Charts', shortcut: 'C', action: () => { location.hash = '#charts-section'; } },
  { icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>', label: 'Export Dataset', shortcut: 'E', action: () => { closeCmd(); openModal('Export Dataset', 'Choose format.', true); } },
  { icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><polyline points="23 4 23 10 17 10"/><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/></svg>', label: 'Refresh Data', shortcut: 'R', action: () => { closeCmd(); refreshData(); } },
  { icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>', label: 'View Activity', shortcut: 'A', action: () => { location.hash = '#timeline-section'; } },
  { icon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/></svg>', label: 'View Alerts', action: () => { location.hash = '#alerts-section'; } },
];

function openCmd() {
  document.getElementById('cmdOverlay').classList.add('open');
  const input = document.getElementById('cmdInput');
  input.value = '';
  input.focus();
  renderCmdList('');
}

function closeCmd() {
  document.getElementById('cmdOverlay').classList.remove('open');
}

function renderCmdList(query) {
  const filtered = CMD_ITEMS.filter(i => i.label.toLowerCase().includes(query.toLowerCase()));
  document.getElementById('cmdList').innerHTML = filtered.map((item, i) =>
    `<div class="cmd-item ${i === 0 ? 'highlight' : ''}" onclick="CMD_ITEMS.find(c=>c.label==='${item.label}').action(); closeCmd();" role="option">
      ${item.icon}<span>${item.label}</span>${item.shortcut ? `<span class="cmd-shortcut">${item.shortcut}</span>` : ''}
    </div>`
  ).join('') || '<div style="padding:16px;text-align:center;color:var(--text-muted);font-size:12px">No results found</div>';
}

/* ==========================================================
   Theme Toggle (Dark / Light)
   ========================================================== */
function toggleTheme() {
  const html = document.documentElement;
  const isLight = html.dataset.theme === 'light';
  const newTheme = isLight ? 'dark' : 'light';
  html.dataset.theme = newTheme;
  localStorage.setItem('DashboardLabTheme', newTheme);
  updateThemeIcon(newTheme);
  updateChartColors(newTheme);
  showToast(`Theme: ${newTheme}`, 'accent');
}

function updateThemeIcon(theme) {
  const moon = document.querySelector('#themeToggle .icon-moon');
  const sun = document.querySelector('#themeToggle .icon-sun');
  if (!moon || !sun) return;
  moon.style.display = theme === 'light' ? 'none' : 'block';
  sun.style.display = theme === 'light' ? 'block' : 'none';
}

function updateChartColors(theme) {
  const color = theme === 'light' ? '#8888a0' : '#55556a';
  const border = theme === 'light' ? 'rgba(0,0,0,0.06)' : 'rgba(255,255,255,0.04)';
  Chart.defaults.color = color;
  Chart.defaults.borderColor = border;
}

function initTheme() {
  const saved = localStorage.getItem('DashboardLabTheme') || 'dark';
  document.documentElement.dataset.theme = saved;
  updateThemeIcon(saved);
  updateChartColors(saved);
}

/* ==========================================================
   Accent Color Switcher
   ========================================================== */
function setAccent(color) {
  document.documentElement.dataset.accent = color;
  document.querySelectorAll('.accent-dot').forEach(d => d.classList.toggle('active', d.dataset.c === color));
  showToast(`Accent: ${color}`, 'accent');
}

/* ==========================================================
   Refresh Data (simulated)
   ========================================================== */
function refreshData() {
  showToast('Refreshing data...', 'accent');
  document.querySelectorAll('.kpi-card').forEach(card => {
    card.style.opacity = '0.5';
    card.style.transition = 'opacity 0.3s';
  });
  setTimeout(() => {
    document.querySelectorAll('.kpi-card').forEach(card => { card.style.opacity = '1'; });
    animateNumbers();
    showToast('Data refreshed successfully', 'green');
  }, 1500);
}

/* ==========================================================
   Collapsible Toggle
   ========================================================== */
function toggleCollapse(btn, id) {
  const body = document.getElementById(id);
  btn.classList.toggle('open');
  body.classList.toggle('collapsed');
  btn.querySelector('span').textContent = body.classList.contains('collapsed') ? 'Expand' : 'Collapse';
}

/* ==========================================================
   Bind All Event Listeners
   ========================================================== */
function initEventListeners() {
  // Close sidebar on nav click (mobile)
  document.addEventListener('click', (e) => {
    if (e.target.closest('.nav-item') && window.innerWidth <= 860) closeSidebar();
  });

  // Tabs — lazy chart rendering
  document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const parent = btn.closest('.section');
      parent.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
      parent.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
      btn.classList.add('active');
      const tabId = btn.dataset.tab;
      document.getElementById(tabId).classList.add('active');
      if (tabRenderers[tabId]) {
        requestAnimationFrame(() => tabRenderers[tabId]());
      }
    });
  });

  // Filter buttons
  document.querySelectorAll('.filter-group').forEach(group => {
    group.querySelectorAll('.filter-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        group.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        showToast(`Filter applied: ${btn.textContent}`, 'accent');
      });
    });
  });
  document.getElementById('regionFilter').addEventListener('change', function () {
    showToast(`Region: ${this.options[this.selectedIndex].text}`, 'accent');
  });

  // Sidebar nav highlight on scroll
  const sections = document.querySelectorAll('.section[id]');
  const navItems = document.querySelectorAll('.nav-item[data-section]');
  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        navItems.forEach(n => n.classList.remove('active'));
        const target = document.querySelector(`.nav-item[data-section="${entry.target.id}"]`);
        if (target) target.classList.add('active');
      }
    });
  }, { rootMargin: '-20% 0px -60% 0px' });
  sections.forEach(s => observer.observe(s));

  // Scroll reveal
  const revealObserver = new IntersectionObserver(entries => {
    entries.forEach(entry => { if (entry.isIntersecting) entry.target.classList.add('visible'); });
  }, { threshold: 0.08 });
  document.querySelectorAll('.section').forEach(s => revealObserver.observe(s));

  // KPI card hover glow
  document.addEventListener('mousemove', (e) => {
    const card = e.target.closest('.kpi-card');
    if (!card) return;
    const rect = card.getBoundingClientRect();
    card.style.setProperty('--mx', ((e.clientX - rect.left) / rect.width * 100) + '%');
    card.style.setProperty('--my', ((e.clientY - rect.top) / rect.height * 100) + '%');
  });

  // Modal overlay click-to-close
  document.getElementById('modalOverlay').addEventListener('click', e => {
    if (e.target === document.getElementById('modalOverlay')) closeModal();
  });

  // Command palette input & keyboard
  document.getElementById('cmdInput').addEventListener('input', e => renderCmdList(e.target.value));
  document.getElementById('cmdInput').addEventListener('keydown', e => {
    if (e.key === 'Escape') closeCmd();
    if (e.key === 'Enter') {
      const first = document.querySelector('.cmd-item.highlight');
      if (first) first.click();
    }
  });
  document.getElementById('cmdOverlay').addEventListener('click', e => {
    if (e.target === document.getElementById('cmdOverlay')) closeCmd();
  });

  // Global keyboard shortcuts
  document.addEventListener('keydown', e => {
    if ((e.metaKey || e.ctrlKey) && e.key === 'k') { e.preventDefault(); openCmd(); }
    if (e.key === 'Escape') { closeCmd(); closeModal(); }
  });

  // Table search
  initTableSearch();
}
