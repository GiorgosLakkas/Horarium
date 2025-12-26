document.addEventListener("DOMContentLoaded", () => {
  const calendarEl = document.getElementById("weekCalendar");
  const weekRangeEl = document.getElementById("weekRange");

  const employees = JSON.parse(document.getElementById("employees-data")?.textContent || "[]");


  
  const shiftsByDay = JSON.parse(document.getElementById("shifts-data")?.textContent || "{}");
  const calendarId = (document.getElementById("calendar-id")?.textContent || "-1").trim();
  const absences = JSON.parse(
    document.getElementById("absences-data")?.textContent || "[]"
  );

  

  const employeeSelect = document.getElementById("employeeSelect");
  const daySelect = document.getElementById("daySelect");
  const startTimeInput = document.getElementById("startTime");
  const endTimeInput = document.getElementById("endTime");
  const addShiftBtn = document.getElementById("addShiftBtn");
  const removeShiftSelect = document.getElementById("removeShiftSelect");
  const removeShiftBtn = document.getElementById("removeShiftBtn");
  const submitBtn = document.getElementById("submitChanges");
  const saveStatus = document.getElementById("saveStatus");

  const todayISO = formatISO(new Date());


  const DAYS = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];


  function isPastDate(isoDate) {
    return isoDate < todayISO;
  }

  function getIsoDateForDay(day) {
    const idx = DAYS.indexOf(day);
    if (idx < 0) return null;
    return formatISO(addDays(state.weekMonday, idx));
  }
  
  
  function isEmployeeAbsent(employeeId, isoDate) {
    return absences.some(a =>
      String(a.employee_id) === String(employeeId) &&
      isoDate >= a.startDate &&
      isoDate <= a.endDate
    );
  }

  function updateEmployeeAvailabilityForDate(isoDate) {
    if (!employeeSelect || !isoDate) return;
  
    Array.from(employeeSelect.options).forEach(opt => {
      if (!opt.value) return; // "-- Select Employee --"
  
      const absent = isEmployeeAbsent(opt.value, isoDate);
      opt.disabled = absent;
  
      // optional UX hint
      const baseName = opt.textContent.replace(" (Absent)", "");
      opt.textContent = absent ? `${baseName} (Absent)` : baseName;
      
    });
    // reset selection if currently absent
    if (
      employeeSelect.value &&
      isEmployeeAbsent(employeeSelect.value, isoDate)
    ) {
      employeeSelect.value = "";
    }
  }

  function updateDayDropdownAvailability() {
    if (!daySelect) return;
  
    const todayISO = formatISO(new Date());
  
    Array.from(daySelect.options).forEach(opt => {
      if (!opt.value) return; // "-- Select Day --"
  
      const isoDate = getIsoDateForDay(opt.value);
      if (!isoDate) return;
  
      const isPast = isoDate < todayISO;
  
      opt.disabled = isPast;
  
      // clean label
    });
  
    // reset selection if user had picked a past day
    if (daySelect.value) {
      const iso = getIsoDateForDay(daySelect.value);
      if (iso && iso < todayISO) {
        daySelect.value = "";
      }
    }
  }
  

  // ----- State (what we see on screen & what we will submit) -----
  let state = {
    weekMonday: mondayOf(new Date()),
    shifts: [],       // flat list
    deletedIds: [],   // shiftId list
    nextLocalId: 1
  };

  // populate employee dropdown
  employees.forEach(e => {
    const opt = document.createElement("option");
    opt.value = String(e.id);
    opt.textContent = e.name;
    employeeSelect?.appendChild(opt);
  });

  // init from server JSON
  DAYS.forEach(day => {
    const list = Array.isArray(shiftsByDay[day]) ? shiftsByDay[day] : [];
    list.forEach(s => {
      const normalized = {
        localId: state.nextLocalId++,
        shiftId: String(s.shiftId || ""),
        employeeId: String(s.employeeId || ""),
        employee: String(s.employee || ""),
        start: normalizeTime(s.start),
        end: normalizeTime(s.end),
        date: String(s.date || ""),
        day
      };
      if (!normalized.date) {
        // fallback: compute date from current week
        normalized.date = formatISO(addDays(state.weekMonday, DAYS.indexOf(day)));
      }
      state.shifts.push(normalized);
    });
  });

  // if we have any dates from the server, align weekMonday to that calendar week
  const mondayFromData = guessWeekMondayFromData(state.shifts);
  if (mondayFromData) state.weekMonday = mondayFromData;
  updateDayDropdownAvailability();


  render();

  // keep "remove" dropdown in sync with selected day
  daySelect?.addEventListener("change", () => {
    refreshRemoveDropdown();
  
    const day = daySelect.value;
    if (!day) return;
  
    const isoDate = formatISO(
      addDays(state.weekMonday, DAYS.indexOf(day))
    );

    if (isPastDate(isoDate)) {
      daySelect.value = "";
      employeeSelect.value = "";
      return;
    }
  
    updateEmployeeAvailabilityForDate(isoDate);
  });
  
  // ----- Add shift (local only) -----
  addShiftBtn?.addEventListener("click", (e) => {
    e.preventDefault();

    const day = (daySelect?.value || "").trim();
    const employeeId = (employeeSelect?.value || "").trim();
    const employeeName = employeeSelect?.options[employeeSelect.selectedIndex]?.textContent || "";
    const start = (startTimeInput?.value || "").trim();
    const end = (endTimeInput?.value || "").trim();

    if (!day || !employeeId || !start || !end) {
      flashStatus("Please fill all fields.", true);
      return;
    }

    const date = formatISO(addDays(state.weekMonday, DAYS.indexOf(day)));

    state.shifts.push({
      localId: state.nextLocalId++,
      shiftId: "", // new
      employeeId,
      employee: employeeName,
      start,
      end,
      date,
      day
    });

    flashStatus("Shift added ", false);
    render();
  });

  // ----- Remove shift (ONLY from the side panel) -----
  removeShiftBtn?.addEventListener("click", (e) => {
    e.preventDefault();
    const val = (removeShiftSelect?.value || "").trim();
    if (!val) {
      flashStatus("Select a shift to remove.", true);
      return;
    }

    const target = findShiftByKey(val);
    if (!target) {
      flashStatus("Shift not found.", true);
      return;
    }

    removeShift(target);
  });

  submitBtn?.addEventListener("click", async (e) => {
    e.preventDefault();

    if (calendarId === "-1") {
      flashStatus("No active calendar to edit.", true);
      return;
    }

    try {
      submitBtn.disabled = true;
      flashStatus("Saving...", false);

      const payloadShifts = state.shifts.map(s => ({
        shiftId: s.shiftId,
        employeeId: s.employeeId,
        start: s.start,
        end: s.end,
        date: s.date
      }));

      const form = new URLSearchParams();
      form.set("calendarId", calendarId);
      form.set("shiftsData", JSON.stringify(payloadShifts));
      form.set("deletedIds", JSON.stringify(state.deletedIds));

      const res = await fetch("EditCalendarChecker.jsp", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" },
        body: form.toString()
      });

      const text = await res.text();

      // FIXED: Use includes() to avoid error on hidden characters/newlines
      if (res.ok) {
        state.deletedIds = [];
        //flashStatus("Saved to database", false); // Success (Not red)
        window.location.href = "managerDashboard.jsp";
      } else {
        // If it's not the success message, treat it as an error
        throw new Error(text || "Save failed");
      }

    } catch (err) {
      flashStatus((err?.message || err), true);
    } finally {
      submitBtn.disabled = false;
    }
  });

  // ----- Rendering (same DOM/classes as weeklyCalendar.js) -----
  function render() {
    if (!calendarEl) return;
    calendarEl.innerHTML = "";

    // Week range header (same style as dashboard)
    const start = state.weekMonday;
    const end = addDays(start, 6);
    if (weekRangeEl) {
      weekRangeEl.textContent = `${formatHuman(start)} - ${formatHuman(end)}`;
    }

    const hasCalendar = state.shifts.length > 0;
    if (!hasCalendar) {
      calendarEl.innerHTML = '<div class="no-calendar">No calendar created yet.</div>';
      return;
    }

    DAYS.forEach((dayName, idx) => {
      const col = document.createElement("div");
      col.className = "day-column";      

      const header = document.createElement("div");
      header.className = "day-header";
      header.textContent = dayName;
      col.appendChild(header);

      const dayDate = addDays(state.weekMonday, idx);
      const dayIso = formatISO(dayDate);

      const dayShifts = state.shifts
        .filter(s => (s.day === dayName) || (s.date === dayIso))
        .sort((a, b) => (a.start || "").localeCompare(b.start || ""));

      if (dayShifts.length === 0) {
        const placeholder = document.createElement("div");
        placeholder.className = "shift-slot off";
        placeholder.textContent = "Day Off";
        col.appendChild(placeholder);
      } else {
        dayShifts.forEach(shift => {
          const slot = document.createElement("div");
          slot.className = "shift-slot filled";

          // Use simple hyphen to avoid encoding issues
          const timeText = `${shift.start} - ${shift.end}`;
          slot.innerHTML = `
            <div class="shift-time">${escapeHtml(timeText)}</div>
            <div class="shift-employee">${escapeHtml(shift.employee || "")}</div>
          `;

          col.appendChild(slot);
        });
      }

      calendarEl.appendChild(col);
    });

    // update remove dropdown after every render
    refreshRemoveDropdown();
    updateDayDropdownAvailability();

  }

  function removeShift(shift) {
    if (shift.shiftId) state.deletedIds.push(String(shift.shiftId));
    state.shifts = state.shifts.filter(s => s !== shift);
    flashStatus("Shift removed.", false);
    render();
  }

  function refreshRemoveDropdown() {
    if (!removeShiftSelect) return;
    const selectedDay = (daySelect?.value || "").trim();

    // keep current selection (if possible)
    const prev = removeShiftSelect.value;

    // reset
    removeShiftSelect.innerHTML = '<option value="">-- Select Shift --</option>';

    if (!selectedDay) return;

    const dayIdx = DAYS.indexOf(selectedDay);
    const dayIso = dayIdx >= 0 ? formatISO(addDays(state.weekMonday, dayIdx)) : "";

    const dayShifts = state.shifts
      .filter(s => (s.day === selectedDay) || (dayIso && s.date === dayIso))
      .sort((a, b) => (a.start || "").localeCompare(b.start || ""));

    dayShifts.forEach(s => {
      const opt = document.createElement("option");
      opt.value = shiftKey(s);
      opt.textContent = `${s.start} - ${s.end}  |  ${s.employee}`;
      removeShiftSelect.appendChild(opt);
    });

    // restore selection if still exists
    if (prev) {
      const exists = Array.from(removeShiftSelect.options).some(o => o.value === prev);
      if (exists) removeShiftSelect.value = prev;
    }
  }

  function shiftKey(shift) {
    // prefer DB id, otherwise local id
    if (shift.shiftId) return `id:${shift.shiftId}`;
    return `local:${shift.localId}`;
  }

  function findShiftByKey(key) {
    if (key.startsWith("id:")) {
      const id = key.substring(3);
      return state.shifts.find(s => String(s.shiftId) === id) || null;
    }
    if (key.startsWith("local:")) {
      const lid = Number(key.substring(6));
      return state.shifts.find(s => Number(s.localId) === lid) || null;
    }
    return null;
  }

  // ----- Helpers -----
  function mondayOf(d) {
    const date = new Date(d);
    const day = date.getDay() || 7; // 1..7
    date.setHours(0, 0, 0, 0);
    date.setDate(date.getDate() - day + 1);
    return date;
  }

  function addDays(dateObj, days) {
    const d = new Date(dateObj);
    d.setDate(d.getDate() + days);
    return d;
  }

  function formatISO(dateObj) {
    const y = dateObj.getFullYear();
    const m = String(dateObj.getMonth() + 1).padStart(2, "0");
    const d = String(dateObj.getDate()).padStart(2, "0");
    return `${y}-${m}-${d}`;
  }

  function formatHuman(dateObj) {
    const d = String(dateObj.getDate()).padStart(2, "0");
    const m = String(dateObj.getMonth() + 1).padStart(2, "0");
    const y = dateObj.getFullYear();
    return `${d}/${m}/${y}`;
  }

  function normalizeTime(t) {
    if (!t) return "";
    return String(t).substring(0, 5); // HH:mm
  }

  function guessWeekMondayFromData(flatShifts) {
    for (const s of flatShifts) {
      if (s?.date) {
        const d = new Date(s.date + "T00:00:00");
        return mondayOf(d);
      }
    }
    return null;
  }

  function flashStatus(msg, isError) {
    if (!saveStatus) return;
    saveStatus.textContent = msg;
    saveStatus.style.color = isError ? "#ffb4b4" : "";
  }

  function escapeHtml(str) {
    return String(str).replace(/[&<>"']/g, (m) => ({
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      '"': "&quot;",
      "'": "&#039;"
    }[m]));
  }
});