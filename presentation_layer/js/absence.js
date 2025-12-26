document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("absenceForm");
  const startDateInput = document.getElementById("startDate");
  const endDateInput = document.getElementById("endDate");
  const errorMessage = document.getElementById("dateError");
  const errorMessage2 = document.getElementById("timeError");

  form.addEventListener("submit", (e) => {
    const startDate = startDateInput.value;
    const endDate = endDateInput.value;
    const todayISO = new Date().toISOString().split("T")[0];

    if (startDate && startDate < todayISO || endDate && endDate < todayISO) {
      e.preventDefault();
      errorMessage2.textContent =
        "You cannot be absent in the past";
      errorMessage2.style.display = "block";
      dateInput.focus();
      return;
    }

    if (startDate > endDate) {
      e.preventDefault(); 
      errorMessage.textContent =
        "Start date cannot be later than end date.";
      errorMessage.style.display = "block";
    }

  });
});
