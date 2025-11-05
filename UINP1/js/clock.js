// Live Clock + Username
document.addEventListener("DOMContentLoaded", () => {
    const clockEl = document.getElementById("clock");
    const dateEl = document.getElementById("date-line");
    const nameEl = document.getElementById("employeeName");
  
    // προσωρινό όνομα (π.χ. από login)
    const username = localStorage.getItem("employeeName") || "Employee";
    nameEl.textContent = username;
  
    function updateClock() {
      const now = new Date();
      const time = now.toLocaleTimeString([], { hour12: false });
      const date = now.toLocaleDateString([], {
        weekday: "long",
        day: "numeric",
        month: "long",
        year: "numeric",
      });
      clockEl.textContent = time;
      dateEl.textContent = date;
    }
  
    updateClock();
    setInterval(updateClock, 1000);
  });
  