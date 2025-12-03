<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application_layer.*"%>
<!--in order for the application import to work, we firstly need to organize java classes-->


<!DOCTYPE html>
<html lang="en">
  <%  User user = (User) session.getAttribute("user");
  %>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Horarium | Employee Dashboard</title>
  <link rel="stylesheet" href="css/base.css">
<link rel="stylesheet" href="css/dashboard.css">
<link rel="stylesheet" href="css/calendarNikou.css">
<link rel="stylesheet" href="css/responsive.css">
  <link rel="stylesheet" href="css/calendar-skin.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>

<body class="dashboard-body">
  <div class="dashboard-container">
    <!-- Sidebar -->
    <aside class="sidebar">
      <img src="images/logo.png" alt="Horarium Logo" class="sidebar-logo">
      
    
      <!-- Live Clock -->
      <div class="clock-container">
        <div id="clock" class="clock-time">--:--:--</div>
        <div id="date-line" class="clock-date">Loading...</div>
      </div>
    
      <!-- Menu -->
      <ul class="menu">
        <li><a href="#" class="active"><i class="fa-solid fa-house"></i> Home</a></li>
        <li>
          <details>
            <summary><i class="fa-solid fa-inbox"></i> My Stats</summary>
            <ul class="menu" style="padding-left: 10px;">
              <li><a href="EmployeeInfo.jsp"><i class="fa-solid fa-arrows-rotate"></i> Employee Information</a></li>
              <li><a href="RequestHistory.jsp"><i class="fa-solid fa-user-clock"></i> Request History</a></li>
            </ul>
          </details>
        </li>        <li><a href="logout.jsp"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
      </ul>
    </aside>
    <!-- Main Content -->
    <main class="main-content">
      <!-- Header -->
      <header class="header">
        <div class="profile-section">
          <img src="images/member1.png" alt="Profile" class="profile-icon">
          <h1>Welcome, <%=user.getUsername()%> </h1>
        </div>
        <button class="request-btn" onclick="window.location.href='request.jsp'">
          <i class="fa-solid fa-paper-plane"></i> Make Request
        </button>        
      </header>
      

     
<!-- Calendar Section -->
<section class="calendar-section">
  <div class="calendar-header">
    <button id="prevWeek" class="week-btn"><i class="fa-solid fa-chevron-left"></i></button>
    <h2 id="weekRange"></h2>
    <button id="nextWeek" class="week-btn"><i class="fa-solid fa-chevron-right"></i></button>
  </div>

  <div class="calendar-container">
    <div class="calendar-days" id="calendarDays">
      <!-- Εδώ θα προστίθενται οι μέρες δυναμικά από JS -->
    </div>
  </div>
</section>


  <script src="js/weeklyCalendar.js" defer></script>
  <script src="js/clock.js" defer></script>
