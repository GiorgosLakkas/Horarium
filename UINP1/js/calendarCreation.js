// Name to header
document.addEventListener('DOMContentLoaded', function(){
  var nameEl = document.getElementById('employeeName');
  var stored = localStorage.getItem('employeeName');
  if (stored && stored.trim()) { nameEl.textContent = stored; }
});

// Blank weekly calendar (navigation only)
(function(){
  const calendarDays = document.getElementById('calendarDays');
  const weekRange = document.getElementById('weekRange');
  const prevWeekBtn = document.getElementById('prevWeek');
  const nextWeekBtn = document.getElementById('nextWeek');
  let currentDate = new Date();

  function getWeekDates(date){
    const monday = new Date(date);
    const day = monday.getDay();
    const diff = (day === 0 ? -6 : 1) - day;
    monday.setDate(date.getDate() + diff);
    const week = [];
    for (let i=0;i<7;i++){ const d=new Date(monday); d.setDate(monday.getDate()+i); week.push(d); }
    return week;
  }

  function updateCalendar(){
    const week = getWeekDates(currentDate);
    calendarDays.innerHTML = '';
    const start = week[0].toLocaleDateString('en-GB',{ day:'numeric', month:'short' });
    const end = week[6].toLocaleDateString('en-GB',{ day:'numeric', month:'short', year:'numeric' });
    weekRange.textContent = `${start} - ${end}`;
    const options = { weekday:'short', day:'numeric', month:'short' };
    week.forEach((date)=>{
      const card = document.createElement('div'); card.className='day-card';
      const header = document.createElement('div'); header.className='day-header'; header.textContent = date.toLocaleDateString('en-GB', options);
      const content = document.createElement('div'); content.className='day-content';
      const p = document.createElement('p'); p.textContent = '—';
      content.appendChild(p);
      card.appendChild(header); card.appendChild(content);
      calendarDays.appendChild(card);
    });
  }

  prevWeekBtn.addEventListener('click', ()=>{ currentDate.setDate(currentDate.getDate()-7); updateCalendar(); });
  nextWeekBtn.addEventListener('click', ()=>{ currentDate.setDate(currentDate.getDate()+7); updateCalendar(); });
  updateCalendar();
})();

// Custom multi-select for employees + assign/submit
(function(){
  const dropdown = document.getElementById('employeeDropdown');
  if (!dropdown) return;
  const display = dropdown.querySelector('.select-display');
  const checkboxes = dropdown.querySelectorAll("input[type='checkbox']");

  function refresh(){
    const selected = Array.from(checkboxes).filter(cb=>cb.checked).map(cb=>cb.value);
    if (selected.length===0){ display.textContent='-- Select Employees --'; display.classList.add('placeholder'); }
    else { display.textContent=selected.join(', '); display.classList.remove('placeholder'); }
  }
  display.addEventListener('click', ()=>{ dropdown.classList.toggle('open'); });
  checkboxes.forEach(cb=>cb.addEventListener('change', refresh));
  document.addEventListener('click', (e)=>{ if(!dropdown.contains(e.target)) dropdown.classList.remove('open'); });
  refresh();

  const daySel = document.getElementById('daySelect');
  const timeSel = document.getElementById('timeSelect');
  const assignBtn = document.getElementById('assignBtn');
  const submitBtn = document.getElementById('submitCalendar');
  const LS_KEY = 'manager_assignments';

  function getSelectedEmployees(){ return Array.from(checkboxes).filter(c=>c.checked).map(c=>c.value); }

  assignBtn?.addEventListener('click', ()=>{
    const day = daySel.value; const time = timeSel.value; const employees = getSelectedEmployees();
    if(!day || !time || employees.length===0){ alert('Please select day, time and at least one employee.'); return; }
    const list = JSON.parse(localStorage.getItem(LS_KEY) || '[]');
    list.push({ day, time, employees });
    localStorage.setItem(LS_KEY, JSON.stringify(list));
    alert(`Assigned ${employees.join(', ')} to ${day} (${time}).`);
    dropdown.classList.remove('open');
  });

  submitBtn?.addEventListener('click', ()=>{
    const data = localStorage.getItem(LS_KEY);
    if(!data || data==='[]'){ alert('No assignments to submit.'); return; }
    console.log('Submitted calendar:', data);
    alert('Calendar submitted successfully!');
  });
})();


