<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="application_layer.*" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>

<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    if (email == null || email.isEmpty()) {
        request.setAttribute("error", "Email is required");
%>
        <jsp:forward page="login.jsp" />
<%
        return;
    }

    if (password == null || password.isEmpty()) {
        request.setAttribute("error", "Password is required");
%>
        <jsp:forward page="login.jsp" />
<%
        return;
    }

    String pattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$";
    Pattern p = Pattern.compile(pattern);
    Matcher matcher = p.matcher(email);

    if (!matcher.matches()) {
        request.setAttribute("error", "Email should be valid");
%>
        <jsp:forward page="login.jsp" />
<%
        return;
    }

    UserDAO userdao = new UserDAO();
    User user = userdao.loginCheck(email, password);

    if (user == null) {
        request.setAttribute("error", "User Does Not Exist");
%>
        <jsp:forward page="login.jsp" />
<%
        return;
    }

    session.setAttribute("user", user);
    
    if ("employee".equals(user.getUserType(user.getId()))) {
%>
        <jsp:forward page="employeeDashboard.jsp" />
<%
    } else {
%>
        <jsp:forward page="managerDashboard.jsp" />
<%
    }
%>
