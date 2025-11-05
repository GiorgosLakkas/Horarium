// Weekly calendar with day cards showing shift & team
document.addEventListener("DOMContentLoaded", () => {
  const calendarDays = document.getElementById("calendarDays");
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
    calendarDays.innerHTML = "";

    const start = week[0].toLocaleDateString("en-GB", { day: "numeric", month: "short" });
    const end = week[6].toLocaleDateString("en-GB", { day: "numeric", month: "short", year: "numeric" });
    weekRange.textContent = `${start} - ${end}`;

    // Dummy data (θα αντικατασταθεί αργότερα με δεδομένα από DB)
    const shifts = [
      "09:00 - 17:00",
      "10:00 - 18:00",
      "08:30 - 16:30",
      "09:30 - 17:30",
      "09:00 - 17:00",
      "Day Off",
      "Day Off"
    ];

    const teams = [
      ["Maria", "John"],
      ["Nick", "Eleni"],
      ["Alex", "Chris"],
      ["George", "Maria"],
      ["John", "Eleni"],
      ["—"],
      ["—"]
    ];

    const options = { weekday: "short", day: "numeric", month: "short" };
    week.forEach((date, i) => {
      const card = document.createElement("div");
      card.classList.add("day-card");

      const dayHeader = document.createElement("div");
      dayHeader.classList.add("day-header");
      dayHeader.textContent = date.toLocaleDateString("en-GB", options);

      const dayContent = document.createElement("div");
      dayContent.classList.add("day-content");

      const shiftText = document.createElement("p");
      shiftText.innerHTML = `<strong>Shift:</strong> ${shifts[i]}`;

      const teamText = document.createElement("p");
      teamText.innerHTML = `<strong>Team:</strong> ${teams[i].join(", ")}`;

      dayContent.appendChild(shiftText);
      dayContent.appendChild(teamText);

      card.appendChild(dayHeader);
      card.appendChild(dayContent);
      calendarDays.appendChild(card);
    });
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
