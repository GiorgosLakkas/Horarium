<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Absence Request | Horarium</title>
  <link rel="stylesheet" href="css/base.css">
<link rel="stylesheet" href="css/auth.css">
<link rel="stylesheet" href="css/responsive.css">
  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>
<body class="login-page">
  <div class="login-container">
    <div class="login-left">
      <h1>Absence Request</h1>

      <form id="absenceForm">
        <div class="input-group">
          <label for="absenceType">Absence Type:</label>
          <select id="absenceType" required>
            <option value="">-- Select Type --</option>
            <option value="Holiday">Holiday</option>
            <option value="Sickness">Sickness</option>
            <option value="Maternity Leave">Maternity Leave</option>
          </select>
        </div>

        <div class="input-group">
          <label for="startDate">Start Date:</label>
          <input type="date" id="startDate" required />
        </div>

        <div class="input-group">
          <label for="endDate">End Date:</label>
          <input type="date" id="endDate" required />
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
    document.getElementById("absenceForm").addEventListener("submit", (e) => {
      e.preventDefault();
      alert("Absence Request Submitted Successfully!");
      window.location.href = "employeeDashboard.html";
    });

    const today = new Date().toISOString().split("T")[0];
    document.getElementById("startDate").min = today;
    document.getElementById("endDate").min = today;
  </script>
</body>
</html>
