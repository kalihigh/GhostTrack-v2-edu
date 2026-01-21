#!/bin/bash
set -e

echo "=== GHOSTTRACK · GITHUB PAGES FIX ==="

# 1) Correggi percorsi statici in index.html e dashboard.html
for f in index.html dashboard.html; do
  if [ -f "$f" ]; then
    sed -i 's|/static/|webapp/static/|g' "$f"
    sed -i 's|/webapp/static/|webapp/static/|g' "$f"
    sed -i 's|static/panels|webapp/static/panels|g' "$f"
  fi
done

# 2) Rimuovi SSI e sostituisci con loader JS
for f in index.html dashboard.html; do
  if [ -f "$f" ]; then
    sed -i 's|<!--#include file="\(.*\)" -->|<div data-include="\1"></div>|g' "$f"
  fi
done

# 3) Loader JS universale
cat > webapp/static/panel_loader.js << 'JS'
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-include]").forEach(async el => {
    const file = el.getAttribute("data-include")
    try {
      const res = await fetch(file)
      const html = await res.text()
      el.innerHTML = html
    } catch (e) {
      el.innerHTML = "<pre>Errore caricamento pannello: " + file + "</pre>"
    }
  })
})
JS

# 4) Inserisci loader JS in index.html
if ! grep -q "panel_loader.js" index.html; then
  echo '<script src="webapp/static/panel_loader.js"></script>' >> index.html
fi

# 5) Genera snapshot e log
bash ghosttrack_quantum_sync.sh

# 6) Commit e push
git add .
git commit -m "GitHub Pages fix: percorsi, loader, snapshot"
git push

echo "=== FIX COMPLETATO ==="
echo "Il sito è ora compatibile con GitHub Pages."
