<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application.*"%>

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
  
  <link rel="stylesheet" href="css/base.css" />
  <link rel="stylesheet" href="css/calendarNikou.css" />
  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>
<body style="display: block; padding: 40px; background-color: var(--bg); color: var(--text);">

  <div style="margin-bottom: 40px;">
    <img src="images/logo.png" alt="Company Logo" style="width: 85px; height: auto;">
  </div>

  <div style="display: flex; gap: 50px; align-items: flex-start;">
    
    <div class="calendar-section" style="flex: 2;">
      <div class="calendar-header" style="justify-content: space-between;">
        <div id="weekRange">15 December - 21 December 2025</div>
        <div class="nav">
          <button class="week-btn">&lt;</button>
          <button class="week-btn">&gt;</button>
        </div>
      </div>

      <div class="calendar-days">
        <div class="day-card"><div class="day-content"><p>15</p></div></div>
        <div class="day-card"><div class="day-content"><p>16</p></div></div>
        <div class="day-card"><div class="day-content"><p>17</p></div></div>
        <div class="day-card"><div class="day-content"><p>18</p></div></div>
        <div class="day-card"><div class="day-content"><p>19</p></div></div>
        <div class="day-card"><div class="day-content"><p>20</p></div></div>
        <div class="day-card today"><div class="day-content"><p>21</p></div></div>
      </div>

      <div style="margin-top: 40px;">
        <h2 style="font-size: 24px; color: var(--text);">Shifts for Selected Day:</h2>
      </div>

      <button class="btn" style="width: auto; margin-top: 150px; background: #c55d5d; box-shadow: none;">
        Clear All Shifts
      </button>
    </div>

    <div style="flex: 1; min-width: 380px;">
      <div style="background-color: #1a2332; padding: 40px 30px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.4);">
        <h2 style="color: var(--accent); text-align: center; margin-bottom: 30px; font-size: 26px;">Create Shift</h2>

        <div style="display: flex; flex-direction: column; gap: 20px;">
          <div>
            <label style="display: block; margin-bottom: 8px; font-weight: 600;">Select Day of Week:</label>
            <select style="width: 100%; padding: 12px; background: #0f1724; color: white; border: 1px solid #334155; border-radius: 10px;">
              <option>-- Select Day --</option>
            </select>
          </div>

          <div>
            <input type="text" placeholder="Select time" style="width: 100%; padding: 12px; background: #0f1724; color: white; border: 1px solid #334155; border-radius: 10px;">
            <button class="week-btn" style="margin-top: 8px; font-size: 12px; font-weight: bold;">Clear</button>
          </div>

          <div>
            <label style="display: block; margin-bottom: 8px; font-weight: 600;">Select Employees to Add:</label>
            <select style="width: 100%; padding: 12px; background: #0f1724; color: white; border: 1px solid #334155; border-radius: 10px;">
              <option>-- Select Employees --</option>
            </select>
          </div>

          <button class="btn">Add Shift</button>
        </div>
      </div>
      
      <button class="btn" id="submitCalendar" style="margin-top: 25px;">
        Submit New Calendar
      </button>
    </div>

  </div>
</body>
</html>