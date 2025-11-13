<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Horarium | Review Absence</title>
  <link rel="stylesheet" href="css/base.css">
<link rel="stylesheet" href="css/manager.css">
<link rel="stylesheet" href="css/responsive.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>
<body class="dashboard-body">
  <div class="dashboard-container">
    <aside class="sidebar">
      <img src="images/logo.png" alt="Horarium Logo" class="sidebar-logo">
      
      <ul class="menu">
        <li><a href="managerDashboard.html"><i class="fa-solid fa-house"></i> Home</a></li>
        <li><a href="CalendarCreation.html"><i class="fa-solid fa-calendar-plus"></i> Create Calendar</a></li>
        <li><a href="#"><i class="fa-solid fa-pen-to-square"></i> Edit Calendar</a></li>
        <li>
          <details open>
            <summary><i class="fa-solid fa-inbox"></i> Review Request</summary>
            <ul class="menu" style="padding-left: 10px;">
              <li><a href="ReviewShiftChange.html"><i class="fa-solid fa-arrows-rotate"></i> Review Shift Change Request</a></li>
              <li><a href="ReviewAbsence.html" class="active"><i class="fa-solid fa-user-clock"></i> Review Absence Request</a></li>
            </ul>
          </details>
        </li>
        <li><a href="login.html"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
      </ul>
    </aside>

    <main class="main-content">
      <header class="header">
        <div class="profile-section">
          <img src="images/profile-icon.png" alt="Profile" class="profile-icon">
          <h1>Review Absence Requests for <span id="employeeName">Manager</span></h1>
        </div>
      </header>

      <div class="requests-container">
        <h2 class="requests-title">Absence Requests</h2>

        <div class="request-card">
          <div class="request-info">
            <div class="employee-avatar">JD</div>
            <div>
              <div class="employee-name">John Doe</div>
              <div class="request-details">
                Reason: <strong>Holiday</strong><br />
                Start: <strong>Nov 6</strong> — End: <strong>Nov 10</strong>
              </div>
            </div>
          </div>
          <div class="actions">
            <button class="btn-icon btn-accept" title="Accept"><i class="fa-solid fa-check"></i></button>
            <button class="btn-icon btn-decline" title="Decline"><i class="fa-solid fa-xmark"></i></button>
          </div>
        </div>

        <div class="request-card">
          <div class="request-info">
            <div class="employee-avatar">MA</div>
            <div>
              <div class="employee-name">Maria Anders</div>
              <div class="request-details">
                Reason: <strong>Sickness</strong><br />
                Start: <strong>Nov 12</strong> — End: <strong>Nov 14</strong>
              </div>
            </div>
          </div>
          <div class="actions">
            <button class="btn-icon btn-accept" title="Accept"><i class="fa-solid fa-check"></i></button>
            <button class="btn-icon btn-decline" title="Decline"><i class="fa-solid fa-xmark"></i></button>
          </div>
        </div>

        <div class="request-card">
          <div class="request-info">
            <div class="employee-avatar">AJ</div>
            <div>
              <div class="employee-name">Alex Johnson</div>
              <div class="request-details">
                Reason: <strong>Maternity Leave</strong><br />
                Start: <strong>Nov 8</strong> — End: <strong>Dec 8</strong>
              </div>
            </div>
          </div>
          <div class="actions">
            <button class="btn-icon btn-accept" title="Accept"><i class="fa-solid fa-check"></i></button>
            <button class="btn-icon btn-decline" title="Decline"><i class="fa-solid fa-xmark"></i></button>
          </div>
        </div>

        <div id="noRequests" class="no-requests" style="display: none;">No pending absence requests.</div>
      </div>
    </main>
  </div>

  <script src="js/reviewAbsence.js" defer></script>

  <script src="js/js/clock.js" defer></script>
</body>
</html>

