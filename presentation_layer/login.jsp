<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "application+layer.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Horarium | Login</title>
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/auth.css">
  <link rel="stylesheet" href="css/responsive.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>
<body>
  <div class="login-container">
    <!-- Left Side -->
    <div class="login-left">
       
       <% if(request.getAttribute("error") != null) { %>		
              <div class="alert alert-danger text-center" role="alert"><h1><%=(String)request.getAttribute("error") %></h1></div>
       <% } else { %>
            <h1>Welcome Back !</h1>
            <p><b>Please Enter Your Details</b></p>
        <% } %>
      <form action="loginChecker.jsp" method="post" class="login-form">
        <!--user puts credentials in the form-->
        <div class="input-group">
          <label for="email"><i class="fa-solid fa-envelope"></i> Email address</label>
          <input type="email" id="email" name="email" placeholder="Enter your email" required>
        </div>

        <div class="input-group">
          <label for="password"><i class="fa-solid fa-lock"></i> Password</label>
          <input type="password" id="password" name="password" placeholder="Enter your password" required>
        </div>

       <!--not really needed but staying for appearance reasons-->
        <!-- <div class="options">
          <label><input type="checkbox"> Remember me.       </label><br>
          <a href="#">Forgot password?</a>
        </div> -->


        <button type="submit" class="btn">Sign in</button>

       <!--not real implementation for the register page; just UI-->
        <p class="register-link">
          Don't have an account? <a href="register.jsp">Sign up</a>
        </p>
      </form>
    </div>


    <!-- Right Side -->
    <div class="login-right">
      <div class="illustration">
        <img src="images/calendar-illustration.png" alt="Illustration" />
      </div>
    </div>
  </div>
</body>
</html>
