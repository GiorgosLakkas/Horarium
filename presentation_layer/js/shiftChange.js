document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("shiftChangeForm");
  const dateInput = document.getElementById("newDay");
  const startTimeInput = document.getElementById("startTime");
  const endTimeInput = document.getElementById("endTime");

  const errorMessage = document.getElementById("timeError");


  form.addEventListener("submit", (e) => {
    const selectedDate = dateInput.value; // YYYY-MM-DD
    const startTime = startTimeInput.value;
    const endTime = endTimeInput.value;

    // today's date in ISO format
    const todayISO = new Date().toISOString().split("T")[0];


    if (selectedDate && selectedDate < todayISO) {
      e.preventDefault();
      errorMessage.textContent =
        "You cannot modify shifts for a past date.";
      errorMessage.style.display = "block";
      dateInput.focus();
      return;
    }

    if (!startTime || !endTime) {
      return; // HTML required handles this
    }


    if (startTime >= endTime) {
      e.preventDefault();
      errorMessage.textContent =
        "Start time must be before end time.";
      errorMessage.style.display = "block";
      endTimeInput.focus();
      return;
    }

    // clear messages if valid
    errorMessage.style.display = "none";
  });
});
