<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application.*"%>
<%@ page import = "java.util.*" %>
<%@ page import="java.util.regex.*" %>
<%@ page import = "java.time.format.*" %>

<!DOCTYPE html>
<html lang="en">
   <%  User user = (User) session.getAttribute("user");
      if (user == null) {
   %>
    <jsp:forward page="forcedLogin.jsp"/>
   <% } %>

  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Horarium | Request Details</title>

    <!-- Common styles -->
    <link rel="stylesheet" href="css/base.css">
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="css/calendarNikou.css">
    <link rel="stylesheet" href="css/responsive.css">
    <link rel="stylesheet" href="css/manager.css">
    <link rel="stylesheet" href="css/calendar-skin.css" />

    <!-- Reuse stats / tabs styling from Employee Info -->
    <link rel="stylesheet" href="css/employeeinfo.css" />
    <!-- Small page-specific tweaks -->
    <link rel="stylesheet" href="css/requestDetails.css" />

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
          <li><a href="employeeDashboard.jsp"><i class="fa-solid fa-house"></i> Home</a></li>
          <li>
            <details open>
              <summary><i class="fa-solid fa-chart-pie"></i> My Stats</summary>
              <ul class="menu" style="padding-left: 10px;">
                <li><a href="EmployeeInfo.jsp"><i class="fa-solid fa-user"></i> Employee Information</a></li>
                <li><a href="myRequests.jsp" class="active"><i class="fa-solid fa-file-lines"></i> Request History</a></li>
              </ul>
            </details>
          </li>
          <li><a href="logout.jsp"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
        </ul>
      </aside>

      <!-- Main Content -->
      <main class="main-content">
        <!-- Header -->
        <header class="header">
          <div class="profile-section">
            <img src="images/member1.png" alt="Profile" class="profile-icon">
            <h1><%=user.getName() + " " + user.getSurname()%> - Request Details</h1> 
          </div>      
        </header>

        <section class="stats-section">
          <%
            RequestDAO rd = new RequestDAO();
            List<Request> requests = new ArrayList<>();
            String s = user.getName() + " " + user.getSurname();
            requests = rd.retriveEmployeeRequests(user.getId());

            int requestId = Integer.parseInt(request.getParameter("rid"));
            Request req = null;
            for (Request r : requests) {
              if (requestId == r.getRequestId()) {
                req = r;
                break;
              }
            }

            String type = rd.defineRequestType(req.getRequestId());
            String prettyType = "absence".equals(type) ? "Absence Request" : "Shift Change Request";
          %>

          <!-- CENTERED DETAILS PANEL -->
          <div class="stats-tabs request-details-panel">

            <!-- SECTION 1: GENERAL INFO -->
            <div class="stats-section-box">
              <div class="stats-section-title">
                <i class="fa-solid fa-circle-info"></i>
                Request Summary
              </div>

              <div class="stat-grid">
                <div class="stat-card">
                  <span class="stat-label">Employee</span>
                  <span class="stat-value"><%= s %></span>
                </div>

                <div class="stat-card">
                  <span class="stat-label">Date Created</span>
                  <span class="stat-value"><%= req.getDate() %></span>
                </div>

                <div class="stat-card">
                  <span class="stat-label">Manager in Charge</span>
                  <span class="stat-value"><%= UserDAO.getManagerNameDetailsById(req.getManagerId()) %></span>
                </div>

                <div class="stat-card span-2">
                  <span class="stat-label">Status</span>
                  <span class="stat-value <%= (Request.Status.REJECTED == req.getStatus()) ? "negative" : ((Request.Status.ACCEPTED == req.getStatus()) ? "positive" : "") %>">
                    <%= req.getStatus() %>
                  </span>
                </div>
              </div>
            </div>

            <!-- SECTION 2: REQUEST TYPE (OWN TAB) -->
            <div class="stats-section-box">
              <div class="stats-section-title">
                <i class="fa-solid fa-tag"></i>
                Request Type
              </div>

              <div class="stat-grid">
                <div class="stat-card span-2">
                  <span class="stat-label">Type</span>
                  <span class="stat-value"><%= prettyType %></span>
                </div>
              </div>
            </div>

            <!-- SECTION 3: TYPE-SPECIFIC DETAILS -->
            <div class="stats-section-box">
              <div class="stats-section-title">
                <i class="fa-solid fa-list-ul"></i>
                Detailed Information
              </div>

              <div class="stat-grid">
                <% if ("absence".equals(type)) {
                    AbsenceRequest ar = (AbsenceRequest)rd.fetchRemainingAttributes(req,"absence"); %>

                    <div class="stat-card">
                      <span class="stat-label">Start Date</span>
                      <span class="stat-value"><%= ar.getStartDate() %></span>
                    </div>

                    <div class="stat-card">
                      <span class="stat-label">End Date</span>
                      <span class="stat-value"><%= ar.getEndDate() %></span>
                    </div>

                    <div class="stat-card span-2">
                      <span class="stat-label">Absence Type</span>
                      <span class="stat-value"><%= ar.getAbsenceType() %></span>
                    </div>

                <% } else { 
                    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                    ShiftChangeRequest scr = (ShiftChangeRequest)rd.fetchRemainingAttributes(req,"shiftChange"); %>

                    <div class="stat-card">
                      <span class="stat-label">Old Shift Date</span>
                      <span class="stat-value"><%= scr.getOldShiftDate() %></span>
                    </div>

                    <div class="stat-card">
                      <span class="stat-label">New Shift Date</span>
                      <span class="stat-value"><%= scr.getNewShiftDate() %></span>
                    </div>

                    <div class="stat-card">
                      <span class="stat-label">Starting Time</span>
                      <span class="stat-value"><%= scr.getStartingTime().format(dtf) %></span>
                    </div>

                    <div class="stat-card">
                      <span class="stat-label">Ending Time</span>
                      <span class="stat-value"><%= scr.getEndingTime().format(dtf) %></span>
                    </div>

                <% } %>
              </div>
            </div>

          </div>
          <!-- END DETAILS PANEL -->
        </section>

      </main>
    </div>
    <script src="js/clock.js" defer></script>

  </body>
</html>
