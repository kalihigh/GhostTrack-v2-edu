async function loadConfig() {
  const res = await fetch('config.json');
  if (!res.ok) throw new Error('Config non accessibile');
  return res.json();
}

let CONFIG = null;
let CURRENT_PANEL = null;
let API_STATUS_INTERVAL = null;

async function checkApiStatus() {
  const indicator = document.getElementById('api-status-indicator');
  const text = document.getElementById('api-status-text');
  try {
    const res = await fetch(CONFIG.api.base_url + '/api/status', {
      method: 'GET',
      headers: { 'Accept': 'application/json' }
    });
    if (!res.ok) throw new Error('HTTP ' + res.status);
    const data = await res.json();
    indicator.classList.remove('offline');
    indicator.classList.add('online');
    text.textContent = `API: online (${data.version || 'v3'})`;
  } catch (err) {
    indicator.classList.remove('online');
    indicator.classList.add('offline');
    text.textContent = 'API: offline';
  }
}

function setActiveMenu(panelId) {
  document.querySelectorAll('.menu-item').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.panel === panelId);
  });
  CURRENT_PANEL = panelId;
}

async function loadPanel(panelId) {
  const container = document.getElementById('panel-container');
  setActiveMenu(panelId);

  const panelPath = `panels/${panelId}.html`;
  try {
    const res = await fetch(panelPath);
    if (!res.ok) throw new Error('Pannello non trovato');
    const html = await res.text();
    container.innerHTML = html;
    if (panelId === 'starlink_control') {
      initStarlinkPanel();
    } else if (panelId === 'podcast_liberi') {
      initPodcastPanel();
    }
  } catch (err) {
    container.innerHTML = `
      <div class="panel">
        <div class="panel-header">
          <div class="panel-title">Errore</div>
        </div>
        <p>Impossibile caricare il pannello <code>${panelId}</code>.</p>
      </div>`;
  }
}

function initMenu() {
  document.querySelectorAll('.menu-item').forEach(btn => {
    btn.addEventListener('click', () => {
      const target = btn.dataset.panel;
      loadPanel(target);
    });
  });
}

function initPodcastPanel() {
  const container = document.querySelector('.podcast-list');
  const audio = document.getElementById('podcast-player');
  const currentLabel = document.getElementById('podcast-current');

  container.innerHTML = '';

  CONFIG.podcast.default_streams.forEach(stream => {
    const item = document.createElement('div');
    item.className = 'podcast-item';
    item.innerHTML = `
      <div class="podcast-meta">
        <div class="podcast-name">${stream.name}</div>
        <div class="podcast-url">${stream.url}</div>
      </div>
      <div class="podcast-actions">
        <button data-url="${stream.url}">Ascolta</button>
      </div>
    `;
    item.querySelector('button').addEventListener('click', () => {
      audio.src = stream.url;
      audio.play().catch(() => {});
      currentLabel.textContent = stream.name;
    });
    container.appendChild(item);
  });
}

function initStarlinkPanel() {
  const refreshBtn = document.getElementById('starlink-refresh');
  const modeBoostBtn = document.getElementById('starlink-mode-boost');
  const modeSaveBtn = document.getElementById('starlink-mode-save');

  refreshBtn.addEventListener('click', () => {
    fetchStarlinkStatus();
  });

  modeBoostBtn.addEventListener('click', () => {
    // Chiamata reale: endpoint da implementare lato API
    // fetch(CONFIG.api.base_url + '/api/starlink/boost', { method: 'POST' });
  });

  modeSaveBtn.addEventListener('click', () => {
    // Chiamata reale: endpoint da implementare lato API
    // fetch(CONFIG.api.base_url + '/api/starlink/power_save', { method: 'POST' });
  });

  fetchStarlinkStatus();
}

async function fetchStarlinkStatus() {
  const latencyEl = document.getElementById('starlink-latency');
  const dlEl = document.getElementById('starlink-download');
  const ulEl = document.getElementById('starlink-upload');
  const uptimeEl = document.getElementById('starlink-uptime');
  const creditsEl = document.getElementById('starlink-credits');
  const modeEl = document.getElementById('starlink-mode');

  try {
    const res = await fetch(CONFIG.api.base_url + '/api/starlink/status', {
      headers: { 'Accept': 'application/json' }
    });
    if (!res.ok) throw new Error('HTTP ' + res.status);
    const data = await res.json();
    latencyEl.textContent = (data.latency_ms ?? '-') + ' ms';
    dlEl.textContent = (data.download_mbps ?? '-') + ' Mbps';
    ulEl.textContent = (data.upload_mbps ?? '-') + ' Mbps';
    uptimeEl.textContent = (data.uptime_h ?? '-') + ' h';
    creditsEl.textContent = data.credits ?? '-';
    modeEl.textContent = data.mode ?? 'unknown';
  } catch {
    latencyEl.textContent = '-';
    dlEl.textContent = '-';
    ulEl.textContent = '-';
    uptimeEl.textContent = '-';
    creditsEl.textContent = '-';
    modeEl.textContent = 'offline';
  }
}

async function main() {
  CONFIG = await loadConfig();
  initMenu();
  if (API_STATUS_INTERVAL) clearInterval(API_STATUS_INTERVAL);
  await checkApiStatus();
  API_STATUS_INTERVAL = setInterval(checkApiStatus, 8000);
  loadPanel('dashboard');
}

main().catch(err => {
  const container = document.getElementById('panel-container');
  container.innerHTML = `
    <div class="panel">
      <div class="panel-header">
        <div class="panel-title">Errore critico</div>
      </div>
      <p>Impossibile inizializzare la console: ${err.message}</p>
    </div>`;
});
