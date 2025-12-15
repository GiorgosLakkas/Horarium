document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("absenceForm");
  const startDateInput = document.getElementById("startDate");
  const endDateInput = document.getElementById("endDate");
  const errorMessage = document.getElementById("dateError");

  form.addEventListener("submit", (e) => {
    const startDate = startDateInput.value;
    const endDate = endDateInput.value;

    if (startDate > endDate) {
      e.preventDefault(); 
      errorMessage.textContent =
        "Start date cannot be later than end date.";
      errorMessage.style.display = "block";
    }
  });
});
