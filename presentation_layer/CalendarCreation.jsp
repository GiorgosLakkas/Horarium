<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import = "application.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.util.stream.Collectors"%>
<%@ page import="com.google.gson.Gson" %>


<!DOCTYPE html>
<html lang="en">
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
%>
    <jsp:forward page="forcedLogin.jsp"/>
<%
    }
%>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Manager Calendar</title>
  <link rel="stylesheet" href="css/calendar.css" />
  <link rel="stylesheet" href="css/CreateCalendar.css" />
  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>

<body>
  <div style="margin-bottom: 30px;">
    <a href="managerDashboard.jsp">
      <img src="images/logo.png" alt="Company Logo" style="width: 150px; height: auto;">
    </a>
  </div>



  <div class="container">

    <div class="calendar-side">
      <div class="calendar-card" style="width: 100%; max-width: 800px; min-height: 420px;">
        <div class="main">


          <div class="header">
            <div class="month-title" id="monthTitle">Month Year</div>

            <div class="nav">
              <button id="prevMonth" class="nav-btn">‹</button>
              <button id="nextMonth" class="nav-btn">›</button>
            </div>
          </div>

          <div id="calendarGrid" class="calendar-grid"></div>

        </div>



        <h3>Shifts for Selected Day:</h3>
        <ul id="shiftList"></ul>


      
      </div>

      <%
  String errorMessage = (String) request.getAttribute("error");
  if (errorMessage != null && !errorMessage.isEmpty()) {
%>
    <div class="error-message" style="color:red; margin-bottom:10px; font-weight:bold;">
        <%= errorMessage %>
    </div>
<%
  }
%> 

      <button id="clearShiftsBtn" 
      style="background:#d9534f;
             color:white;
             margin-top:10px;
             padding:10px 10px;
             font-size:12px;
             width:110px;   /* adjust this */
             border:none;
             border-radius:6px;
             cursor:pointer;">
        Clear All Shifts
      </button>


    </div>

    <form action = "CreationChecker.jsp" method="post" class="Vrexei">
    <div class="form-side">
      <h2>Create Shift</h2>


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


      <div class="time-container">
        <input type="text" id="timeInput" placeholder="Select time" readonly>
        <button type="button" id="clearTime">Clear</button>
    
        <div id="timePopup" class="popup hidden">
          <label>Hour:</label>
          <select id="hourSelect">
            <option value="">--</option>
          </select>
    
          <label>Minute:</label>
          <select id="minuteSelect">
            <option value="">--</option>
          </select>
    
          <button type="button" id="applyTime">Apply</button>
        </div>
      </div>
      <div class="time-container2">
        <input type="text" id="timeInput2" placeholder="Select time" readonly>
        <button type="button" id="clearTime2">Clear</button>
    
        <div id="timePopup2" class="popup hidden">
          <label>Hour:</label>
          <select id="hourSelect2">
            <option value="">--</option>
          </select>
    
          <label>Minute:</label>
          <select id="minuteSelect2">
            <option value="">--</option>
          </select>
    
          <button type="button" id="applyTime2">Apply</button>
        </div>
      </div>
    
<%
UserDAO ud = new UserDAO();
RequestDAO rd = new RequestDAO();
List<Employee> employees = new ArrayList<>();
List<AbsenceRequest> arequests = new ArrayList<>();

employees = ud.fetchEmployeesByManagerId(user.getId());
arequests = rd.retrieveManagerAbsenceRequests(user.getId());

//Only the accepted requests
arequests = arequests.stream()
                     .filter(r -> r.getStatus() == Request.Status.ACCEPTED)
                     .collect(Collectors.toList());

List<AbsenceDTO> absenceDTOs = new ArrayList<>();
//Creates the data transfer object for all the accepted requests
for (AbsenceRequest r : arequests) {
    AbsenceDTO adto = rd.fetchAcceptedAbsenceCrucialDetails(r.getRequestId(), r.getEmployeeId());
    if (adto != null) {
      absenceDTOs.add(adto);
    }
}

String absencesJson = new Gson().toJson(absenceDTOs);
%>

      <label>Select Employees to Add:</label>
      <div class="custom-select" id="employeeAddDropdown">
        <div class="select-display placeholder">-- Select Employees --</div>
        <div class="options">

<% for (Employee e: employees){  
%>  
    <label><input type="checkbox" value="<%= e.getSurname() %>" data-id ="<%= e.getId() %>" /><%= ud.getEmployeeNameDetailsById(e.getId()) %></label>        
<%
}
%>
        </div>
      </div>

      <button type="button" id="addShiftBtn">Add Shift</button>

    </div>

    <input type="hidden" id="startDate" name="startDate">
    <input type="hidden" id="endDate" name="endDate">
    <input type="hidden" id="shiftsData" name="shiftsData">
    <input type="hidden" id="dateSubmitted" name="dateSubmitted">


    <div class="submit-section">
      <button type="button" id="submitCalendar"
        style="
        font-size:16px;
        padding:12px 100px;
        border:none;
        border-radius:8px;
        cursor:pointer;"> 
        Submit New Calendar</button>
    </div>

    </form>
  </div>



  <script id="absences-data" type="application/json">
    <%= absencesJson %>
  </script>
  <script src="js/CreateCalendar.js" defer></script>
  <script>
    let shiftList = [];

    function updateHiddenShifts() {
      document.getElementById("shiftsData").value = JSON.stringify(shiftList);
    }


    function getWeekStart(date) {
      const day = date.getDay(); // 0 = Sunday, 1 = Monday, ...
      const diffToMonday = day === 0 ? -6 : 1 - day; // shift so Monday is start
      const monday = new Date(date);
      monday.setDate(date.getDate() + diffToMonday);
      return monday;
    }

    let currentDate = new Date(); 

    let currentWeekStart = getWeekStart(currentDate); 
    const weekdayNames = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"];
  
    document.getElementById("addShiftBtn").addEventListener("click", () => {
    
        const selectedDay = document.getElementById("daySelect").value;
        const startTime = document.getElementById("timeInput").value;
        const endTime = document.getElementById("timeInput2").value;
    
        const selectedEmployees = [...document.querySelectorAll("#employeeAddDropdown input:checked")]
            .map(e => e.dataset.id);

        const dayIndex = weekdayNames.indexOf(selectedDay);

        const shiftDate = new Date(currentWeekStart);
        shiftDate.setDate(currentWeekStart.getDate() + dayIndex );
    
        // Add a separate shift for each employee and append to the list
        selectedEmployees.forEach(employee => {
            const shift = {
                day: shiftDate,
                start: startTime,
                end: endTime,
                employee: employee
            };

            const alreadyExists = shiftList.some(s =>
            s.day === shift.day &&
            s.start === shift.start &&
            s.end === shift.end &&
            s.employee === shift.employee
            );

            if (!alreadyExists) {
              shiftList.push(shift);
            }

        });
        updateHiddenShifts();
    });

    document.getElementById("clearShiftsBtn").addEventListener("click", () => {
      shiftList = [];
      updateHiddenShifts();
    });
    document.getElementById("prevMonth").addEventListener("click", () => {

      shiftList = [];
      updateHiddenShifts();
   
    
    });
    document.getElementById("nextMonth").addEventListener("click", () => {

      shiftList = [];
      updateHiddenShifts();

    });

    document.getElementById("submitCalendar").addEventListener("click", () => {
      const year = currentDate.getFullYear();
      const month = currentDate.getMonth();
      const date = currentDate.getDate();
    
      const dayOfWeek = currentDate.getDay(); 
      const diffToMonday = dayOfWeek === 0 ? -6 : 1 - dayOfWeek;
      const startOfWeek = new Date(year, month, date + diffToMonday);
      const endOfWeek = new Date(startOfWeek);
      endOfWeek.setDate(endOfWeek.getDate() + 6);

      startOfWeek.setDate(startOfWeek.getDate() + 1);
      endOfWeek.setDate(endOfWeek.getDate() + 1);
  
      document.getElementById("startDate").value = startOfWeek.toISOString().split('T')[0];
      document.getElementById("endDate").value = endOfWeek.toISOString().split('T')[0];
  
      document.getElementById("shiftsData").value = JSON.stringify(shiftList);
      document.getElementById("dateSubmitted").value = currentDate.toISOString().split('T')[0];

  
      document.querySelector(".Vrexei").submit();
    });
  </script>

</body>
</html>
