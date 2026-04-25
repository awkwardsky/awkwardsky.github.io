/* ==========================================================
   Application Bootstrap
   ========================================================== */
document.addEventListener('DOMContentLoaded', () => {
  initTheme();
  showLoading();

  setTimeout(() => {
    renderKPIs();
    renderCharts();
    renderRegions();
    renderTable();
    renderTimeline();
    renderStatus();
    renderAlerts();
    renderReleases();

    // Hero visible immediately
    document.getElementById('hero').classList.add('visible');
  }, 800);

  initEventListeners();
});
