document.addEventListener("DOMContentLoaded", () => {
  const calendar = document.getElementById("weekCalendar");
  const weekRange = document.getElementById("weekRange");

  const shiftsByDay = JSON.parse(document.getElementById("shifts-data").textContent || '{}');

  const today = new Date();
  const monday = new Date(today);
  const day = today.getDay() || 7;
  monday.setDate(today.getDate() - day + 1);

  const days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
  const hasCalendar = Object.keys(shiftsByDay).length > 0;

  if (!hasCalendar) {
    // Show message and exit
    calendar.innerHTML = '<div class="no-calendar">No calendar created yet.</div>';
    weekRange.textContent = '';
    return;
  }

  const sunday = new Date(monday);
  sunday.setDate(monday.getDate() + 6);
  weekRange.textContent = `${monday.toLocaleDateString()} - ${sunday.toLocaleDateString()}`;

  days.forEach(dayName => {
    const col = document.createElement("div");
    col.className = "day-column";

    const header = document.createElement("div");
    header.className = "day-header";
    header.textContent = dayName;
    col.appendChild(header);

    const shifts = shiftsByDay[dayName] || [];
    if (shifts.length === 0) {
      const placeholder = document.createElement("div");
      placeholder.className = "shift-slot off";
      placeholder.textContent = "Day Off";
      col.appendChild(placeholder);
    } else {
      shifts.forEach(shift => {
        const slot = document.createElement("div");
        slot.className = "shift-slot filled";
        slot.innerHTML = `
          <div class="shift-time">${shift.time}</div>
          <div class="shift-employee">${shift.employee}</div>
        `;
        if (shift.time === "OFF") slot.classList.add("off");
        col.appendChild(slot);
      });
    }

    calendar.appendChild(col);
  });
});
