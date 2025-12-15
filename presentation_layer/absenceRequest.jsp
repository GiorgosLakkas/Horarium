<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="application_layer.*" %>

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

        <!-- Error message shown by JavaScript -->
        <p id="dateError" class="error-message" style="display:none;"></p>
        


        <form action = "requestChecker.jsp" id="absenceForm" method="post">
            
            <div class="input-group">
                <label for="absenceType">Absence Type:</label>
                <select id="absenceType" name="absenceType" required>
                    <option value="">-- Select Type --</option>
                    <option value="Holiday">Holiday</option>
                    <option value="Sickness">Sickness</option>
                    <option value="Maternity Leave">Maternity Leave</option>
                </select>
            </div>

            <div class="input-group">
                <label for="startDate">Start Date:</label>
                <input type="date" id="startDate" name="startDate" required />
            </div>

            <div class="input-group">
                <label for="endDate">End Date:</label>
                <input type="date" id="endDate" name="endDate" required />
            </div>

            <!-- this shows the controller that this is an absence request -->
            <input type="hidden" name="source" value="1">



            <!-- Error message shown by JavaScript -->


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

<!-- External JavaScript for date validation -->
<script src="js/absence.js"></script> 

</body>
</html>
