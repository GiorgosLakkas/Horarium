<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application.*"%>

<!DOCTYPE html>
<html lang="en">
  <%  User user = (User) session.getAttribute("user");
      if (user == null) {
  %>
    <jsp:forward page="forcedLogin.jsp"/>
  <% } %>
<head>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Make a Request | Horarium</title>
  <link rel="stylesheet" href="css/base.css">
<link rel="stylesheet" href="css/auth.css">
<link rel="stylesheet" href="css/responsive.css">
  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>
<body class="login-page">
  <div class="login-container">
    <div class="login-left">
      <img src="images/logo.png" alt="Horarium Logo" class="logo" />
      <h1>Make a Request</h1>
      <p>Select the type of request you want to make:</p>

      <div class="request-type-buttons">
        <button class="btn" onclick="window.location.href='shiftRequest.jsp'">Shift Change Request</button>
        <button class="btn" onclick="window.location.href='absenceRequest.jsp'">Absence Request</button>
        
      </div>

      <div class="register-link">
        <button type="button" class="btn" onclick="window.location.href='employeeDashboard.jsp'">
          ← Back to Dashboard 
        </button>
        
      </div>
    </div>

    <div class="login-right">
       <div class="illustration">
        <a href = "employeeDashboard.jsp">
          <img src="images/calendar-illustration.png" alt="Calendar Illustration" />
        </a>
      </div>
    </div>
  </div>
</body>
</html>
