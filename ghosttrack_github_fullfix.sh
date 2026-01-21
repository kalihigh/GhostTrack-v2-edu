#!/bin/bash
set -e

echo "=== GHOSTTRACK · GITHUB FULL FIX ==="

###############################################
# 1) FIX LINK ASSOLUTI → RELATIVI
###############################################
echo "[1] Correzione link assoluti → relativi"

find . -name "*.html" -type f | while read f; do
  # Rimuovi slash iniziale
  sed -i 's|href="/|href="|g' "$f"
  sed -i 's|src="/|src="|g' "$f"

  # Correggi static
  sed -i 's|href="static/|href="webapp/static/|g' "$f"
  sed -i 's|src="static/|src="webapp/static/|g' "$f"
  sed -i 's|href="/static/|href="webapp/static/|g' "$f"
  sed -i 's|src="/static/|src="webapp/static/|g' "$f"

  # Correggi webapp
  sed -i 's|href="/webapp/|href="webapp/|g' "$f"
  sed -i 's|src="/webapp/|src="webapp/|g' "$f"

  # Correggi docs
  sed -i 's|href="/docs/|href="docs/|g' "$f"
  sed -i 's|src="/docs/|src="docs/|g' "$f"
done

###############################################
# 2) FIX PANNELLI (rimuovi SSI)
###############################################
echo "[2] Rimozione SSI → loader JS"

find . -name "*.html" -type f | while read f; do
  sed -i 's|<!--#include file="\(.*\)" -->|<div data-include="\1"></div>|g' "$f"
done

###############################################
# 3) CREAZIONE LOADER JS UNIVERSALE
###############################################
echo "[3] Creazione loader JS"

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

###############################################
# 4) INSERIMENTO LOADER IN index.html
###############################################
echo "[4] Inserimento loader in index.html"

if ! grep -q "panel_loader.js" index.html; then
  echo '<script src="webapp/static/panel_loader.js"></script>' >> index.html
fi

###############################################
# 5) GENERA SNAPSHOT E LOG
###############################################
echo "[5] Generazione snapshot quantico"

bash ghosttrack_quantum_sync.sh

###############################################
# 6) COMMIT & PUSH
###############################################
echo "[6] Commit & Push"

git add .
git commit -m "GitHub Pages full fix: link, pannelli, loader, snapshot"
git push

echo "=== FIX COMPLETATO ==="
echo "Il sito ora è completamente compatibile con GitHub Pages."
