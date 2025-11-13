<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Horarium | Register</title>
  <link rel="stylesheet" href="css/base.css">
<link rel="stylesheet" href="css/auth.css">
<link rel="stylesheet" href="css/responsive.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script src="js/register.js" defer></script>
  <link rel="icon" type="image/png" href="images/tabicon.png" />
</head>

<body>
    <div class="login-container register-page">
    <!-- Left Side -->
    <div class="login-left">
      <div class="logo-box">
        <h1>Create your account</h1>
        <p>Please fill in your details to register</p>
      </div>

      <form onsubmit="redirectAfterSubmit(event)" class="login-form">
        <!-- Position -->
        <div class="input-group">
          <label for="position"><i class="fa-solid fa-briefcase"></i> Position</label>
          <select id="position" name="position" required>
            <option value="">Select position</option>
            <option value="Employee">Employee</option>
            <option value="Manager">Manager</option>
          </select>
        </div>

        <!-- First Name -->
        <div class="input-group">
          <label for="firstName"><i class="fa-solid fa-user"></i> First Name</label>
          <input type="text" id="firstName" name="firstName" placeholder="Enter your first name" required>
        </div>

        <!-- Last Name -->
        <div class="input-group">
          <label for="lastName"><i class="fa-solid fa-user"></i> Last Name</label>
          <input type="text" id="lastName" name="lastName" placeholder="Enter your last name" required>
        </div>

        <!-- Username -->
        <div class="input-group">
          <label for="username"><i class="fa-solid fa-id-badge"></i> Username</label>
          <input type="text" id="username" name="username" placeholder="Choose a username" required>
        </div>

        <!-- Email -->
        <div class="input-group">
          <label for="email"><i class="fa-solid fa-envelope"></i> Email</label>
          <input type="email" id="email" name="email" placeholder="Enter your email" required>
        </div>

        <!-- Password -->
        <div class="input-group">
          <label for="password"><i class="fa-solid fa-lock"></i> Password</label>
          <input type="password" id="password" name="password" placeholder="Create a password" required>
        </div>

        <!-- Company -->
        <div class="input-group">
          <label for="company"><i class="fa-solid fa-building"></i> Company</label>
          <select id="company" name="company" required>
            <option value="">Select company</option>
            <option value="CompanyA">Company A</option>
            <option value="CompanyB">Company B</option>
            <option value="CompanyC">Company C</option>
          </select>
        </div>

        <button type="submit" class="btn">Register</button>

        <p class="register-link">
          Already have an account? <a href="login.html">Sign in</a>
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
