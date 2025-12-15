document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("shiftChangeForm");
    const startTimeInput = document.getElementById("startTime");
    const endTimeInput = document.getElementById("endTime");
  
    // Create / reuse an error message element
    const errorMessage = document.getElementById("timeError");
  
    form.addEventListener("submit", (e) => {
      const startTime = startTimeInput.value;
      const endTime = endTimeInput.value;
  
      if (!startTime || !endTime) {
        return; // HTML required handles this
      }
      // Compare times (HH:MM format compares lexicographically)
      if (startTime >= endTime) {
        e.preventDefault();
  
        errorMessage.textContent =
          "Start time must be before end time.";
        errorMessage.style.display = "block";
  
        endTimeInput.focus();
      }
    });
  });
  