// Weekly calendar that always shows Monday–Sunday of current week
document.addEventListener("DOMContentLoaded", () => {
    const calendarGrid = document.getElementById("calendarGrid");
    const weekRange = document.getElementById("weekRange");
    const prevWeekBtn = document.getElementById("prevWeek");
    const nextWeekBtn = document.getElementById("nextWeek");
  
    let currentDate = new Date();
  
    function getWeekDates(date) {
      const monday = new Date(date);
      const day = monday.getDay();
      const diff = (day === 0 ? -6 : 1) - day;
      monday.setDate(date.getDate() + diff);
  
      const week = [];
      for (let i = 0; i < 7; i++) {
        const d = new Date(monday);
        d.setDate(monday.getDate() + i);
        week.push(d);
      }
      return week;
    }
  
    function updateCalendar() {
      const week = getWeekDates(currentDate);
      calendarGrid.innerHTML = "";
  
      const options = { weekday: "short", day: "numeric", month: "short" };
      week.forEach((d) => {
        const cell = document.createElement("div");
        cell.className = "week-cell";
        cell.textContent = d.toLocaleDateString("en-GB", options);
        calendarGrid.appendChild(cell);
      });
  
      const start = week[0].toLocaleDateString("en-GB", { day: "numeric", month: "short" });
      const end = week[6].toLocaleDateString("en-GB", { day: "numeric", month: "short", year: "numeric" });
      weekRange.textContent = `${start} - ${end}`;
    }
  
    prevWeekBtn.addEventListener("click", () => {
      currentDate.setDate(currentDate.getDate() - 7);
      updateCalendar();
    });
  
    nextWeekBtn.addEventListener("click", () => {
      currentDate.setDate(currentDate.getDate() + 7);
      updateCalendar();
    });
  
    updateCalendar();
  });
  