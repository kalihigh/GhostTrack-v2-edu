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
