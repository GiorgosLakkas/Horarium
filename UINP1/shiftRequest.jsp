<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>

<!DOCTYPE html>
<html lang="en">
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

      <form id="shiftForm">
        <div class="input-group">
          <label for="chooseDay">Choose Day (Unavailable):</label>
          <input type="date" id="chooseDay" required />
        </div>

        <div class="input-group">
          <label for="newDay">New Day (Available):</label>
          <input type="date" id="newDay" required />
        </div>

        <div class="input-group">
          <label for="startTime">Start Time:</label>
          <input type="time" id="startTime" required />
        </div>

        <div class="input-group">
          <label for="endTime">End Time:</label>
          <input type="time" id="endTime" required />
        </div>

        <button type="submit" class="btn">Submit Request</button>

        <div class="register-link">
          <a href="request.html">← Back to Request Type</a>
        </div>
      </form>
    </div>

    <div class="login-right">
      <div class="illustration">
        <img src="images/calendar-illustration.png" alt="Calendar Illustration" />
      </div>
    </div>
  </div>

  <script>
    document.getElementById("shiftForm").addEventListener("submit", (e) => {
      e.preventDefault();
      alert("Shift Change Request Submitted Successfully!");
      window.location.href = "employeeDashboard.html";
    });

    const today = new Date().toISOString().split("T")[0];
    document.getElementById("chooseDay").min = today;
    document.getElementById("newDay").min = today;
  </script>
</body>
</html>
