// statsPie.js
document.addEventListener('DOMContentLoaded', () => {
    const card = document.getElementById('leavePie');
    if (!card) return;
  
    const rem = parseInt(card.dataset.remaining || '0', 10);
    const total = parseInt(card.dataset.total || '0', 10);
    const used = Math.max(total - rem, 0);
    const pct  = total > 0 ? Math.round((rem / total) * 100) : 0;
  
    // Ενημέρωση legend
    const el = (id) => document.getElementById(id);
    el('remDays').textContent   = rem;
    el('usedDays').textContent  = used;
    el('totalDays').textContent = total;
  
    card.querySelector('.pie-label').textContent = pct + '%';
  
    // SVG progress (100 = πλήρης κύκλος)
    const fill = document.getElementById('pieFill');
    const dash = Math.min(Math.max(pct, 0), 100);
    fill.setAttribute('stroke-dasharray', `${dash}, 100`);
  });


