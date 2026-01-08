<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application.*"%>
<%@ page import = "java.util.*"%>

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
  <link rel="stylesheet" href="css/calendarEdit.css"> 
  <link rel="stylesheet" href="css/responsive.css">

  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>
<body class="login-page">
  <div class="login-container">
    <div class="login-left">
      <h1>Shift Change Request</h1>

      <p id="timeError" class="error-message" style="display:none;"></p>

      <form form action = "shiftChangeFormChecker.jsp" id="shiftChangeForm" method="post">

        <div class="input-group">
          <label for="chooseOldShift">Choose Shift (Unavailable):</label>
        
          <details class="shift-dropdown">
            <summary>Select shifts</summary>
        
            <div class="shift-list">
              <%
                ShiftDAO sdao = new ShiftDAO();
                List<Shift> shifts = sdao.fetchRemainingWeeklyShiftsByEmployeeId(user.getId());
        
                for (Shift s: shifts) {
              %>
                <label class="shift-item">
                  <input type="radio" name="shiftId" value="<%=s.getShiftId()%>"  />
                  <span style="width:100%; text-align:center;">
                    <%= s.getDate() + "  |" 
                        + s.getStartTime() + "-"
                        + s.getEndTime() %>
                  </span>
                </label>
              <%
                }
              %>
            </div>
          </details>
        </div>
        
        

        <div class="input-group">
          <label for="newDay">New Day (Available):</label>
          <input type="date" id="newDay" name="newDay" required />
        </div>
<!-- custom time selectors -->
        <div class="time-container">
          <div style="display:flex; align-items:center; gap:50px;">
            <input type="text" name ="startTime" id="startTime"
                   style="width:100%; padding:12px; background:#0f1724; color:var(--text); border:1px solid #334155; border-radius:10px;"
                   placeholder="Select start time" readonly>
        
          </div>
      
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

        <div class="time-container">
            <div style="display:flex; align-items:center; gap:50px;">
              <input type="text" name="endTime" id="endTime"
                     style="width:100%; padding:12px; background:#0f1724; color:var(--text); border:1px solid #334155; border-radius:10px;"
                     placeholder="Select end time" readonly>
        
            </div>
          
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
        <a>
          <img src="images/calendar-illustration.png" alt="Calendar Illustration" />
        </a>
      </div>
    </div>
  </div>

  <script src="js/shiftChange.js"></script> 
</body>
</html>
