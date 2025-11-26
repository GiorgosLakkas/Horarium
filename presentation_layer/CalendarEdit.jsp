<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application_layer.*"%>


<!DOCTYPE html>
<html lang="en">
  
<head>
  <%  User user = (User) session.getAttribute("user");
      if (user == null) {
  %>
    <jsp:forward page="forcedLogin.jsp"/>
  <% } %>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Manager Calendar</title>
  <link rel="stylesheet" href="css/calendar.css" />
  <link rel="stylesheet" href="css/calendar-edit-create.css" />
  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>
<body>
  <img src="images/logo.png" alt="Company Logo" class="logo">

  <div class="container">
    <!-- Left: Calendar -->
    <div class="calendar-side">
      <div
        class="calendar-card"
        style="width: 100%; max-width: 800px; min-height: 420px"
      >
        <div class="main">
          <div class="header">
            <div class="month-title" id="monthTitle">Month Year</div>
            <div class="nav"><select id="viewSelect"></select></div>
          </div>

          <div class="grid" id="calendarGrid">
            <div class="weekdays" id="weekdays"></div>
            <div class="days" id="days"></div>
          </div>
        </div>
      </div>
      <div class="submit-section">
        <button id="submitCalendar">Submit Edited Calendar</button>
      </div>
    </div>

    <!-- Right: Manager Controls -->
    <div class="form-side">
      <h2>Edit Work Schedule</h2>

      <!-- Day + Time selection -->
      <label for="daySelect">Select Day of Week:</label>
      <select id="daySelect">
        <option value="">-- Select Day --</option>
        <option>Monday</option>
        <option>Tuesday</option>
        <option>Wednesday</option>
        <option>Thursday</option>
        <option>Friday</option>
        <option>Saturday</option>
        <option>Sunday</option>
      </select>

      <label for="timeSelect">Select Time Period:</label>
      <select id="timeSelect">
        <option value="">-- Select Time --</option>
        <option>08:00 - 12:00</option>
        <option>12:00 - 16:00</option>
        <option>16:00 - 20:00</option>
        <option>20:00 - 00:00</option>
      </select>

      <!-- Add Employees Section -->
      <label>Select Employees to Add:</label>
      <div class="custom-select" id="employeeAddDropdown">
        <div class="select-display placeholder">-- Select Employees --</div>
        <div class="options">
          <label><input type="checkbox" value="John Doe" /> John Doe</label>
          <label><input type="checkbox" value="Maria Anders" /> Maria Anders</label>
          <label><input type="checkbox" value="Robert Fox" /> Robert Fox</label>
          <label><input type="checkbox" value="Jane Smith" /> Jane Smith</label>
          <label><input type="checkbox" value="Alex Johnson" /> Alex Johnson</label>
        </div>
      </div>

      <button id="addEmployeesBtn">Add Employees</button>

      <!-- Remove Employees Section -->
      <label>Select Employees to Remove:</label>
      <div class="custom-select" id="employeeRemoveDropdown">
        <div class="select-display placeholder">-- Select Employees --</div>
        <div class="options">
          <label><input type="checkbox" value="John Doe" /> John Doe</label>
          <label><input type="checkbox" value="Maria Anders" /> Maria Anders</label>
          <label><input type="checkbox" value="Robert Fox" /> Robert Fox</label>
          <label><input type="checkbox" value="Jane Smith" /> Jane Smith</label>
          <label><input type="checkbox" value="Alex Johnson" /> Alex Johnson</label>
        </div>
      </div>

      <button id="removeEmployeesBtn">Remove Employees</button>
    </div>
  </div>
</body>
</html>
