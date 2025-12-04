<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application.*"%>
<%@ page import = "java.util.*"%>


<!DOCTYPE html>
<html lang="en">
  <%User user = (User)session.getAttribute("user");
    if (user == null) { %> 
      <jsp:forward page = "forcedLogin.jsp"/>
  <% } %>
<head>
  <meta charset="UTF-8" />
  <title>Horarium | Employee Info</title>

  <!-- Κοινά styles + theme -->
  <link rel="stylesheet" href="css/global.css" />
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/dashboard.css">
  <link rel="stylesheet" href="css/calendarNikou.css">
  <link rel="stylesheet" href="css/responsive.css">
  <link rel="stylesheet" href="css/calendar-skin.css" />
  
  <!-- ΝΕΟ: CSS layer για τα στατιστικά -->
  <link rel="stylesheet" href="css/employeeinfo.css" />

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
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
        <li><a href="employeeDashboard.jsp"><i class="fa-solid fa-house"></i> Home</a></li>
        <li><a href="MyStats.jsp" class="active"><i class="fa-solid fa-chart-pie"></i> My stats</a></li>
        <li><a href="logout.jsp"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
      </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-content">

      <!-- Header -->
      <header class="header">
        <div class="profile-section">
          <img src="images/member1.png" alt="Profile" class="profile-icon">
          <h1>Welcome, <%=user.getName() + " " + user.getSurname()%></h1>
        </div>
      </header>

      <!-- =======================
           My Stats Content
      ========================== -->
      <section class="stats-section">

  <div class="panel">

    <div class="panel-header">
      <h2><i class="fa-solid fa-calendar-day"></i> Remaining Leave Days</h2>
    </div>

    <!-- PIE (LEFT) + STATS (RIGHT) -->
    <div class="pie-wrap">

      <!-- ========================
           PIE CHART — LEFT
      ========================= -->
      <div class="pie-card" id="leavePie" data-remaining="12" data-total="20">
        <svg viewBox="0 0 36 36" class="pie" aria-label="Remaining leave pie chart">
          <defs>
            <linearGradient id="gradPie" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" stop-color="#22d3ee"/>
              <stop offset="100%" stop-color="#0ea5e9"/>
            </linearGradient>
          </defs>

          <!-- background circle -->
          <path class="bg"
            d="M18 2
               a 16 16 0 0 1 0 32
               a 16 16 0 0 1 0 -32" />

          <!-- progress circle -->
          <path class="fill"
            id="pieFill"
            stroke-dasharray="0,100"
            d="M18 2
               a 16 16 0 0 1 0 32
               a 16 16 0 0 1 0 -32" />

          <text x="18" y="20.5" class="pie-label">--%</text>
        </svg>
        <% UserDAO ud = new UserDAO();
        Employee employee = ud.fetchEmployeeDetails(user);
        %>
        <div class="pie-legend">
          <div class="legend-item">
            <span class="dot dot-rem"></span>
            Remaining <strong><%=employee.getDaysOffRemaining()%></strong>
          </div>
          <div class="legend-item">
            <span class="dot dot-used"></span>
            Used <strong id="usedDays">--</strong>
          </div>
          <div class="legend-item">
            <span class="dot dot-total"></span>
            Total <strong id="totalDays">--</strong>
          </div>
        </div>
      </div>
      <!-- END PIE -->
       

      <!-- ==============================
           STATS RIGHT COLUMN
           (Requests + Workload stacked)
      =============================== -->
      <!-- replace data-* with backend values -->
      <div class="stats-tabs" id="statsTabs"
           data-approved="8"
           data-declined="3"
           data-managers="Alex Smith, Maria Georgiou"
           data-shift7="10"
           data-shift30="27">

        <!-- SECTION 1: REQUESTS -->
        <div class="stats-section-box">
          <div class="stats-section-title">
            <i class="fa-solid fa-list-check"></i>
            Requests
          </div>
  
          <% RequestDAO rd = new RequestDAO();
          List<Request> requests = new ArrayList<>();
          requests = rd.retriveEmployeeRequests(user.getId());
          int approved = 0, declined = 0;
          for (Request r : requests) {
            if (Request.Status.ACCEPTED == r.getStatus()) {
              approved++;
            } else if (Request.Status.REJECTED == r.getStatus()) {
              declined++;
            }
          }
          %>

          <div class="stat-grid">
            <div class="stat-card">
              <span class="stat-label">Approved </span>
              <span class="stat-value"><%=approved%></span> 
            </div>

            <div class="stat-card">
              <span class="stat-label">Declined</span>
              <span class="stat-value negative"><%=declined%></span>
            </div>

            <div class="stat-card span-2">
              <span class="stat-label">Total Requests</span>
              <span class="stat-value"><%=requests.size()%></span>
            </div>
          </div>
        </div>

        <!-- SECTION 2: WORKLOAD & MANAGERS -->
        <div class="stats-section-box">
          <div class="stats-section-title">
            <i class="fa-solid fa-briefcase-clock"></i>
            Workload & Managers
          </div>

          <div class="stat-grid">
            <div class="stat-card span-2">
              <span class="stat-label">Assigned managers</span>
              <span class="stat-value"><%=ud.getManagerNameDetailsById(employee.getManagerId())%></span>
            </div>

            <!-- Shifts next 7 days: LONGER (full width) -->
            <div class="stat-card span-2">
              <span class="stat-label">Shifts this week</span>
              <span class="stat-value" id="shift7">--</span>
            </div>

            <!-- No 14 days; only 30-day overview -->
            <div class="stat-card span-2">
              <span class="stat-label">Shifts this month</span>
              <div class="stat-inline">
                <span class="stat-value" id="shift30">--</span>
                <span class="badge" id="workloadLevel">--</span>
              </div>
            </div>
          </div>
        </div>

      </div>
      <!-- END STATS COLUMN -->

    </div> <!-- END pie-wrap -->

  </div>
</section>



    </main>
  </div>

  <!-- Scripts -->
  <script src="js/clock.js" defer></script>
  <script src="js/dashboardGreeting.js" defer></script>
  <script src="js/statsPie.js" defer></script>
  <script src="js/statsDonut.js" defer></script>

</body>
</html>
