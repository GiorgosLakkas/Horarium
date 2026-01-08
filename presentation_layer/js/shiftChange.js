document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("shiftChangeForm");
  const dateInput = document.getElementById("newDay");
  const errorMessage = document.getElementById("timeError");

//up until line 120 for the custom time pickers
  const timeInput = document.getElementById("startTime");
  const timePopup = document.getElementById("timePopup");
  const hourSelect = document.getElementById("hourSelect");
  const minuteSelect = document.getElementById("minuteSelect");
  const applyBtn = document.getElementById("applyTime");


  const timeInput2 = document.getElementById("endTime");
  const timePopup2 = document.getElementById("timePopup2");
  const hourSelect2 = document.getElementById("hourSelect2");
  const minuteSelect2 = document.getElementById("minuteSelect2");
  const applyBtn2 = document.getElementById("applyTime2");

  // Generate hours
  for (let h = 0; h < 24; h++) {
      hourSelect.innerHTML += `<option value="${String(h).padStart(2, '0')}">${String(h).padStart(2, '0')}</option>`;
  }

  // Generate minutes (00, 05, 10, ...)
  for (let m = 0; m < 60; m += 5) {
      minuteSelect.innerHTML += `<option value="${String(m).padStart(2, '0')}">${String(m).padStart(2, '0')}</option>`;
  }

  // Show popup
  timeInput.onclick = () => {
      timePopup.classList.toggle("hidden");
  };

  // Apply time
  applyBtn.onclick = () => {
      const hour = hourSelect.value;
      const minute = minuteSelect.value;

      if (hour && minute) {
          timeInput.value = `${hour}:${minute}`;
          document.getElementById("startTime").value = `${hour}:${minute}`;
      }

      timePopup.classList.add("hidden");
  }

  document.addEventListener("click", (e) => {
      if (!timePopup.contains(e.target) && e.target !== timeInput) {
          timePopup.classList.add("hidden");
      }
  });


  // Generate hours
  for (let h = 0; h < 24; h++) {
      hourSelect2.innerHTML += `<option value="${String(h).padStart(2, '0')}">${String(h).padStart(2, '0')}</option>`;
  }

  // Generate minutes (00, 05, 10, ...)
  for (let m = 0; m < 60; m += 5) {
      minuteSelect2.innerHTML += `<option value="${String(m).padStart(2, '0')}">${String(m).padStart(2, '0')}</option>`;
  }

  // Show popup
  timeInput2.onclick = () => {
      timePopup2.classList.toggle("hidden");
  };

  // Apply time
  applyBtn2.onclick = () => {
      const hour = hourSelect2.value;
      const minute = minuteSelect2.value;

      if (hour && minute) {
          timeInput2.value = `${hour}:${minute}`;
          document.getElementById("endTime").value = `${hour}:${minute}`;

      }

      timePopup2.classList.add("hidden");
  };

  // Close popup when clicking outside
  document.addEventListener("click", (e) => {
      if (!timePopup2.contains(e.target) && e.target !== timeInput2) {
          timePopup2.classList.add("hidden");
      }
  });

  function isStartBeforeEnd() {
      const startTime = document.getElementById("startTime").value;
      const endTime = document.getElementById("endTime").value;
  
      if (!startTime || !endTime) return true; // allow empty inputs
  
      // Convert HH:MM to minutes
      const [startH, startM] = startTime.split(":").map(Number);
      const [endH, endM] = endTime.split(":").map(Number);
  
      const startMinutes = startH * 60 + startM;
      const endMinutes = endH * 60 + endM;
  
      return startMinutes < endMinutes;
  }
  
  // Example: check when Apply buttons are clicked
  document.getElementById("applyTime2").addEventListener("click", () => {
      if (!isStartBeforeEnd()) {
          alert("End time cannot be before Start time");
          document.getElementById("endTime").value = ""; // optional: clear invalid input
      }
  });

  document.getElementById("applyTime").addEventListener("click", () => {
    if (!isStartBeforeEnd()) {
        alert("Start time cannot be after End time");
        document.getElementById("startTime").value = ""; // optional: clear invalid input
    }
  });

//This is in order to check that the screquests are before the next week
  function getSundayOfCurrentWeek(d) {
    const day = d.getDay(); // 0 = Sunday, 1 = Monday, ...
    d.setDate(d.getDate() - day);
    return d;
  }
  function getSundayOfCurrentWeek(date = new Date()) {
    const d = new Date(date);
    const day = d.getDay(); // 0 = Sunday
    d.setDate(d.getDate() + (7 - day) % 7);
    d.setHours(23, 59, 59, 999);
    return d;
  }
  



 form.addEventListener("submit", (e) => {
  const selectedDateStr = dateInput.value; // YYYY-MM-DD
  if (!selectedDateStr) return;

  const selectedDate = new Date(selectedDateStr + "T00:00:00");
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const sunday = getSundayOfCurrentWeek(today);


  if (selectedDate < today) {
      e.preventDefault();
      errorMessage.textContent =
          "You cannot modify shifts for a past date.";
      errorMessage.style.display = "block";
      dateInput.focus();
      return;
  }

  if (selectedDate > sunday) {
      e.preventDefault();
      errorMessage.textContent =
          "You can only request for a shift change this week.";
      errorMessage.style.display = "block";
      dateInput.focus();
      return;
  }

  // clear messages if valid
  errorMessage.style.display = "none";
 });
});
