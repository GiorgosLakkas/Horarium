<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application_layer.*"%>


<%@ page import = "java.util.*"%>
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
  <title>Horarium | Review Shift Change</title>
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
        <li><a href="managerDashboard.jsp"><i class="fa-solid fa-house"></i> Home</a></li>
        <li><a href="CalendarCreation.jsp"><i class="fa-solid fa-calendar-plus"></i> Create Calendar</a></li>
        <li><a href="CalendarEdit.jsp"><i class="fa-solid fa-pen-to-square"></i> Edit Calendar</a></li>
        <li>
          <details open>
            <summary><i class="fa-solid fa-inbox"></i> Review Request</summary>
            <ul class="menu" style="padding-left: 10px;">
              <li><a href="ReviewShiftChange.jsp" class="active"><i class="fa-solid fa-arrows-rotate"></i> Review Shift Change Request</a></li>
              <li><a href="ReviewAbsence.jsp"><i class="fa-solid fa-user-clock"></i> Review Absence Request</a></li>
            </ul>
          </details>
        </li>
        <li><a href="logout.jsp"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
      </ul>
    </aside>

    <main class="main-content">
      <header class="header">
        <div class="profile-section">
          <img src="images/member1.png" alt="Profile" class="profile-icon">
          <h1>Review Shift Change Requests <%=user.getUsername()%></h1>
        </div>
      </header>
      <% RequestDAO rd = new RequestDAO();
      UserDAO ud = new UserDAO();
      List<ShiftChangeRequest> shiftChanges = new ArrayList<>();
      DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm");
      shiftChanges = rd.retrieveManagerShiftChangeRequests(user.getId()); %>
      <h2 class="requests-title">Shift Change Requests</h2>

       <% for (ShiftChangeRequest s : shiftChanges) { %>
        <div class="requests-container">
          <div class="request-card">
            <div class="request-info">
              <div class="employee-avatar"><%=ud.getEmployeeNameDetailsById(s.getEmployeeId()).replaceAll("^\\s*([a-zA-Z]).*\\s+([a-zA-Z])\\S+$", "$1$2").toUpperCase()%></div>
              <div>
                <div class="employee-name"><%=ud.getEmployeeNameDetailsById(s.getEmployeeId())%></div>
                <div class="request-details">
                  From <strong><%=s.getOldShiftDate()%></strong> → <strong><%=s.getNewShiftDate()%></strong><br />
                  Preferred time: <strong><%=s.getStartingTime().format(dtf) + " - " + s.getEndingTime().format(dtf)%></strong>
                </div>
              </div>
            </div>
            <div class="actions">
              <button class="btn-icon btn-accept" title="Accept"><i class="fa-solid fa-check"></i></button>
              <button class="btn-icon btn-decline" title="Decline"><i class="fa-solid fa-xmark"></i></button>
            </div>
          </div>

      </div>
      <% } %>
    </main>
  </div>

  <script src="js/reviewShiftChange.js" defer></script>

  <script src="js/js/clock.js" defer></script>
</body>
</html>