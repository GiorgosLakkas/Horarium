// statsDonut.js (now: stats for requests + workload)
document.addEventListener('DOMContentLoaded', () => {
  const container = document.getElementById('statsTabs');
  if (!container) return;

  // ========================
  // READ DATA ATTRIBUTES
  // ========================
  const approved = parseInt(container.dataset.approved || '0', 10);
  const declined = parseInt(container.dataset.declined || '0', 10);
  const totalRequests = Math.max(approved + declined, 0);

  const shift7  = parseInt(container.dataset.shift7  || '0', 10);
  const shift30 = parseInt(container.dataset.shift30 || '0', 10);

  const managersRaw = container.dataset.managers || '';
  const managers = managersRaw
    .split(',')
    .map(m => m.trim())
    .filter(Boolean);

  const byId = (id) => document.getElementById(id);

  // ========================
  // REQUESTS SECTION
  // ========================
  const elApproved = byId('totalApproved');
  const elDeclined = byId('totalDeclined');
  const elTotalReq = byId('totalRequests');

  if (elApproved) elApproved.textContent = approved;
  if (elDeclined) elDeclined.textContent = declined;
  if (elTotalReq) elTotalReq.textContent = totalRequests;

  // ========================
  // WORKLOAD & MANAGERS
  // ========================
  const elManagers = byId('assignedManagers');
  if (elManagers) {
    elManagers.textContent = managers.length
      ? managers.join(' • ')
      : 'No manager assigned';
  }

  const elShift7  = byId('shift7');
  const elShift30 = byId('shift30');

  if (elShift7)  elShift7.textContent  = shift7;
  if (elShift30) elShift30.textContent = shift30;

  // Simple workload classification based on 30-day shifts
  const elWorkloadLevel = byId('workloadLevel');
  if (elWorkloadLevel) {
    let level = 'Balanced';

    if (shift30 <= 5) {
      level = 'Light';
    } else if (shift30 >= 20) {
      level = 'Heavy';
    }

    elWorkloadLevel.textContent = level;
  }
});

