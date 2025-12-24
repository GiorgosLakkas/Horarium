document.addEventListener("DOMContentLoaded", () => {
    // Calendar elements
    const monthTitle = document.getElementById("monthTitle");
    const calendarGrid = document.getElementById("calendarGrid");
    const prevBtn = document.getElementById("prevMonth");
    const nextBtn = document.getElementById("nextMonth");
    // -----------------------------
// Accepted absences (from JSP)
// -----------------------------
    const acceptedAbsences = JSON.parse(
        document.getElementById("absences-data").textContent
    );
  

    let currentDate = new Date();
    const today = new Date();
    const realWeekStart = new Date(today);
    realWeekStart.setDate(today.getDate() - today.getDay()); // Monday=0 if adjusted
    //realWeekStart.setDate(today.getDate() - ((today.getDay() + 6) % 7));


    // RENDER WEEKLY CALENDAR
    function renderCalendar() {
        const year = currentDate.getFullYear();
        const month = currentDate.getMonth();
        const date = currentDate.getDate();
    
        const dayOfWeek = currentDate.getDay(); // 0 = Sunday, 1 = Monday, ...
        // Shift to Monday: if Sunday (0), go back 6 days, else go back (dayOfWeek - 1)
        const diffToMonday = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
        const startOfWeek = new Date(year, month, date + diffToMonday);
    
        const endOfWeek = new Date(startOfWeek);
        endOfWeek.setDate(endOfWeek.getDate() + 6);
    
        // Update monthTitle to show week range
        monthTitle.textContent =
            startOfWeek.toLocaleDateString("default", { month: "long", day: "numeric" }) +
            " - " +
            endOfWeek.toLocaleDateString("default", { month: "long", day: "numeric", year: "numeric" });
    
        calendarGrid.innerHTML = "";
    
        const weekdayNames = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];
    
        for (let i = 0; i < 7; i++) {
            const day = new Date(startOfWeek);
            day.setDate(startOfWeek.getDate() + i);
    
            const dayName = weekdayNames[i];
    
            const dayCell = document.createElement("div");
            dayCell.classList.add("day");
            dayCell.id = "day-" + dayName;
            dayCell.textContent = day.getDate();
    
            if (day.toDateString() === new Date().toDateString()) {
                dayCell.classList.add("today");
            }
    
            // On click set selected day
            dayCell.addEventListener("click", () => {
                currentDayName = dayName;
            
                document.querySelectorAll(".day").forEach(d => d.classList.remove("selected"));
                dayCell.classList.add("selected");
        
            
                renderShifts(dayName);
            });
            
    
            calendarGrid.appendChild(dayCell);
        }
    }

    function updateEmployeeAvailabilityForDate(selectedDate) {
        const checkboxes = document.querySelectorAll(
            "#employeeAddDropdown input[type='checkbox']"
        );
    
        checkboxes.forEach(cb => {
            const employeeId = parseInt(cb.dataset.id, 10);
            const label = cb.parentElement;
    
            const unavailable = acceptedAbsences.some(a => {
                if (a.employee_id !== employeeId) return false;
    
                const start = new Date(a.startDate);
                const end = new Date(a.endDate);
    
                // Normalize times
                start.setHours(0, 0, 0, 0);
                end.setHours(23, 59, 59, 999);
    
                return selectedDate >= start && selectedDate <= end;
            });
    
            cb.disabled = unavailable;
    
            if (unavailable) {
                label.classList.add("unavailable");
                label.title = "Unavailable (approved absence)";
                cb.checked = false; // safety
            } else {
                label.classList.remove("unavailable");
                label.title = "";
            }
        });
    }
    
    
    document.getElementById("clearShiftsBtn").addEventListener("click", () => {
        if (!confirm("Are you sure you want to delete ALL shifts?")) return;
    
        // Clear all shifts
        Object.keys(scheduleData).forEach(day => {
            scheduleData[day] = [];
        });
    
        // Clear UI
        shiftList.innerHTML = "";
    
        alert("All shifts have been removed.");
    });
    
    

    // Highlight selected day


    // Navigation buttons now move by WEEK (not month)
    prevBtn.addEventListener("click", () => {
        currentDate.setDate(currentDate.getDate() - 7);

        if (currentDate < realWeekStart) {
            return; // Do nothing
        }

        clearAllShifts();
        renderCalendar();
        updatePrevButtonState();
    });

    nextBtn.addEventListener("click", () => {
        currentDate.setDate(currentDate.getDate() + 7);

        clearAllShifts();
        renderCalendar();
        updatePrevButtonState();
    });

    // -----------------------------
    // Employee dropdown (unchanged)
    // -----------------------------
    const employeeDropdown = document.getElementById('employeeAddDropdown');
    const display = employeeDropdown.querySelector('.select-display');
    const options = employeeDropdown.querySelector('.options');
    const checkboxes = options.querySelectorAll('input[type="checkbox"]');

    // Toggle dropdown
    display.addEventListener('click', () => {
        options.style.display = options.style.display === 'block' ? 'none' : 'block';
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (!employeeDropdown.contains(e.target)) {
            options.style.display = 'none';
        }
    });

    // Update display when selecting employees
    checkboxes.forEach(cb => {
        cb.addEventListener('change', () => {
            const selected = Array.from(checkboxes)
                .filter(chk => chk.checked)
                .map(chk => chk.value);

            //display.textContent = selected.length ? selected.join(', ') : '-- Select Employees --';
            //display.classList.toggle('placeholder', selected.length === 0);
        });
    });

    // -----------------------------
    // Time picker (unchanged)
    // -----------------------------
    const timeInput = document.getElementById("timeInput");
    const timePopup = document.getElementById("timePopup");
    const hourSelect = document.getElementById("hourSelect");
    const minuteSelect = document.getElementById("minuteSelect");
    const applyBtn = document.getElementById("applyTime");
    const clearBtn = document.getElementById("clearTime");

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
        }

        timePopup.classList.add("hidden");
    };

    // Clear time
    clearBtn.onclick = () => {
        timeInput.value = "";
        hourSelect.value = "";
        minuteSelect.value = "";
    };

    // Close popup when clicking outside
    document.addEventListener("click", (e) => {
        if (!timePopup.contains(e.target) && e.target !== timeInput) {
            timePopup.classList.add("hidden");
        }
    });

    const timeInput2 = document.getElementById("timeInput2");
    const timePopup2 = document.getElementById("timePopup2");
    const hourSelect2 = document.getElementById("hourSelect2");
    const minuteSelect2 = document.getElementById("minuteSelect2");
    const applyBtn2 = document.getElementById("applyTime2");
    const clearBtn2 = document.getElementById("clearTime2");

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
        }

        timePopup2.classList.add("hidden");
    };

    // Clear time
    clearBtn2.onclick = () => {
        timeInput2.value = "";
        hourSelect2.value = "";
        minuteSelect2.value = "";
    };

    // Close popup when clicking outside
    document.addEventListener("click", (e) => {
        if (!timePopup2.contains(e.target) && e.target !== timeInput2) {
            timePopup2.classList.add("hidden");
        }
    });

    function isStartBeforeEnd() {
        const startTime = document.getElementById("timeInput").value;
        const endTime = document.getElementById("timeInput2").value;
    
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
            alert("Start time must be earlier than End time!");
            document.getElementById("timeInput2").value = ""; // optional: clear invalid input
        }
    });



 

// Store shifts per day
const scheduleData = {};

// DOM elements
const daySelect = document.getElementById("daySelect"); // still used for shift creation
const timeInp = document.getElementById("timeInput");
const timeInp2 = document.getElementById("timeInput2");
const addShiftBtn = document.getElementById("addShiftBtn");
const shiftList = document.getElementById("shiftList");
const employeeCheckboxes = document.querySelectorAll("#employeeAddDropdown input[type=checkbox]");

// Current day clicked on the calendar
let currentDayName = null;


// When day is selected from the dropdown
daySelect.addEventListener("change", () => {
    const selectedDayName = daySelect.value;
    if (!selectedDayName) return;

    currentDayName = selectedDayName;

    // Compute the exact date of the selected day in the current week
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth();
    const date = currentDate.getDate();

    const dayOfWeek = currentDate.getDay(); // 0=Sunday
    const diffToMonday = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
    const startOfWeek = new Date(year, month, date + diffToMonday);

    const weekdayNames = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];
    const dayIndex = weekdayNames.indexOf(selectedDayName);
    if (dayIndex === -1) return;

    const selectedDate = new Date(startOfWeek);
    selectedDate.setDate(startOfWeek.getDate() + dayIndex);

    // Update employee availability for this day
    updateEmployeeAvailabilityForDate(selectedDate);

});


// Add shift button
addShiftBtn.addEventListener("click", () => {
    const day = daySelect.value;
    if (!day) {
        alert("Please select a day!");
        return;
    }

    const startTime = timeInp.value;
    const endTime = timeInp2.value;
    if (!startTime || !endTime) {
        alert("Please select start and end time!");
        return;
    }

    const selectedEmployees = Array.from(employeeCheckboxes)
        .filter(cb => cb.checked)
        .map(cb => cb.value);

    if (selectedEmployees.length === 0) {
        alert("Please select at least one employee!");
        return;
    }

    // Initialize array if first shift for the day
    if (!scheduleData[day]) scheduleData[day] = [];

    selectedEmployees.forEach(emp => {

        const newShift = {
            employee: emp,
            startTime,
            endTime
        };

        // ------------------------------
        // -------------------------------
        const alreadyExists = scheduleData[day].some(s =>
            s.employee === newShift.employee &&
            s.startTime === newShift.startTime &&
            s.endTime === newShift.endTime
        );

        if (alreadyExists) {
            console.log(`Duplicate shift skipped: ${emp} ${startTime}-${endTime}`);
            return; // Skip adding
        }

        // Add shift only if NOT duplicate
        scheduleData[day].push(newShift);
    });

    // If the selected day is currently displayed, refresh it
    if (currentDayName === day) {
        renderShifts(currentDayName);
    }

    // Reset inputs
    timeInp.value = "";
    timeInp2.value = "";
    employeeCheckboxes.forEach(cb => cb.checked = false);
});

// Select all calendar day elements

// Add click listeners to each day
// Render shifts for a given day
function renderShifts(day) {
    shiftList.innerHTML = "";
    if (!scheduleData[day]) return;

    scheduleData[day].forEach(shift => {
        const li = document.createElement("li");
        li.textContent = `${shift.employee}: ${shift.startTime} - ${shift.endTime}`;
        shiftList.appendChild(li);
    });
}

function clearAllShifts() {
    // Reset all shift arrays
    Object.keys(scheduleData).forEach(day => {
        scheduleData[day] = [];
    });

    // Clear shift list in UI
    shiftList.innerHTML = "";
}

function updatePrevButtonState() {
    const testDate = new Date(currentDate);
    testDate.setDate(testDate.getDate() - 7);

    if (testDate < realWeekStart) {
        prevBtn.disabled = true;
        prevBtn.style.opacity = "0.5";
        prevBtn.style.cursor = "not-allowed";
    } else {
        prevBtn.disabled = false;
        prevBtn.style.opacity = "1";
        prevBtn.style.cursor = "pointer";
    }
}
    // Initial weekly render
    renderCalendar();
    updatePrevButtonState();
});
