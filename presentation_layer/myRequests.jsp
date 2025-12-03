<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application_layer.*"%>
<%@ page import = "java.util.*" %>
<%@ page import="java.util.regex.*" %>

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
    <title>Horarium | My Requests</title>
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/dashboard.css">
  <link rel="stylesheet" href="css/calendarNikou.css">
  <link rel="stylesheet" href="css/responsive.css">
  <link rel="stylesheet" href="css/manager.css">
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
          <li><a href="employeeDashboard.jsp" class="active"><i class="fa-solid fa-house"></i> Home</a></li>
          <li><a href="myStats.jsp"><i class="fa-solid fa-calendar"></i> My Stats</a></li>
          <li><a href="logout.jsp"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
        </ul>
      </aside>
      <!-- Main Content -->
      <main class="main-content">
        <!-- Header -->
        <header class="header">
          <div class="profile-section">
            <img src="images/member1.png" alt="Profile" class="profile-icon">
            <h1><%=user.getName() + " " + user.getSurname()%> 's Requests</h1>
          </div>      
        </header>

      <div class="requests-container">
        <h2 class="requests-title">Requests Done</h2>
        
          <div class="request-card">
            <% RequestDAO rd = new RequestDAO();
            List<Request> requests = new ArrayList<>();
            String s = user.getName() + " " + user.getSurname();
            requests = rd.retriveEmployeeRequests(user.getId());
            boolean flag = (requests.size()>0) ? false : true;
            if (flag) { %>
              <strong>No Requests Made Yet</strong>
            <% } else {
            for (Request r : requests) {
            %>
              <div class="request-info">
                <!--string pattern for the initials in name,surname; found at stackoverflow-->
                <div class="employee-avatar"><%=s.replaceAll("^\\s*([a-zA-Z]).*\\s+([a-zA-Z])\\S+$", "$1$2").toUpperCase()%></div>
                <div>
                  <!-- <div class="employee-name"><%=user.getName() + " " + user.getSurname()%></div> -->
                  <div class="request-details">
                    Date: <strong><a href="requestDetails.jsp?rid=<%=r.getRequestId()%>"><%=r.getDate()%></strong><br />
                  </div>
                </div>
              </div>
            </div>
          <% } 
            } %>

       
      </div>
    </main>
  </div>
        
    
    <script src="js/reviewAbsence.js" defer></script>
    <script src="js/clock.js" defer></script>

  </body>
</html>
