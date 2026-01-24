const star = document.getElementById("rza-star");
const panel = document.getElementById("rza-bot-panel");

if (star && panel) {
  star.addEventListener("click", () => {
    panel.classList.remove("hidden");
  });

  panel.addEventListener("click", (e) => {
    if (e.target === panel) {
      panel.classList.add("hidden");
    }
  });
}
