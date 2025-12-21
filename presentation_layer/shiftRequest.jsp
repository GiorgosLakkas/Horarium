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
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Shift Change Request | Horarium</title>
  <link rel="stylesheet" href="css/base.css">
<link rel="stylesheet" href="css/auth.css">
<link rel="stylesheet" href="css/responsive.css">
  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>
<body class="login-page">
  <div class="login-container">
    <div class="login-left">
      <h1>Shift Change Request</h1>

      <p id="timeError" class="error-message" style="display:none;"></p>

      <form form action = "requestChecker.jsp" id="shiftChangeForm" method="post">
        <div class="input-group">
          <label for="chooseDay">Choose Day (Unavailable):</label>
          <input type="date" id="chooseDay" name="oldDay" required />
        </div>

        <div class="input-group">
          <label for="newDay">New Day (Available):</label>
          <input type="date" id="newDay" name="newDay" required />
        </div>

        <div class="input-group">
          <label for="startTime">Start Time:</label>
          <input type="time" id="startTime" name="startTime" required />
        </div>

        <div class="input-group">
          <label for="endTime">End Time:</label>
          <input type="time" id="endTime" name="endTime" required />
        </div>

        <!-- this shows the controller that this is a shiftChangeRequest -->
        <input type="hidden" name="source" value="2">

        <button type="submit" class="btn" style="margin-bottom: 50px;">Submit Request</button>

        <button type="button" class="btn" onclick="window.location.href='request.jsp'">
          ← Back to Request Type
        </button>

      </form>
    </div>

    <div class="login-right">
      <div class="illustration">
        <img src="images/calendar-illustration.png" alt="Calendar Illustration" />
      </div>
    </div>
  </div>

  <script src="js/shiftChange.js"></script> 
</body>
</html>
