function copyToClipboard(el, label) {
  navigator.clipboard
    .writeText(el.textContent.trim())
    .then(() => {
      if (typeof umami !== "undefined") {
        umami.track("copy-command", { command: label });
      }
      el.style.color = "var(--accent)";
      setTimeout(() => {
        el.style.color = "";
      }, 1500);
    })
    .catch(() => {});
}

async function fetchCharts() {
  try {
    const res = await fetch("index.yaml");
    const text = await res.text();
    const entries = {};
    let current = null;
    for (const line of text.split("\n")) {
      const nameMatch = line.match(/^  (\w[\w-]*):$/);
      const versionMatch = line.match(/^\s+version:\s*(.+)/);
      const descMatch = line.match(/^\s+description:\s*(.+)/);
      if (nameMatch && !line.startsWith("    ")) {
        current = nameMatch[1];
        entries[current] = { name: current, version: "", description: "" };
      } else if (current && versionMatch) {
        if (!entries[current].version) entries[current].version = versionMatch[1];
      } else if (current && descMatch) {
        if (!entries[current].description) entries[current].description = descMatch[1];
      }
    }

    const list = document.getElementById("chart-list");
    if (!list) return;

    for (const [name, data] of Object.entries(entries)) {
      const div = document.createElement("div");
      div.className = "chart";
      div.innerHTML = `
        <div>
          <div class="chart-name">${name}</div>
          <div class="chart-desc">${data.description || "No description"}</div>
        </div>
        <span class="chart-ver">v${data.version}</span>
      `;
      list.appendChild(div);
    }

    if (typeof umami !== "undefined") {
      umami.track("charts-loaded", { count: Object.keys(entries).length });
    }
  } catch (e) {
    console.warn("Could not load chart list:", e);
  }
}

fetchCharts();
