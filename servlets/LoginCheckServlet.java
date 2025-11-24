package servlets;

import application_layer.*;
import java.io.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/loginCheck")
public class LoginCheckServlet extends HttpServlet {

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException ,IOException {
        String email = request.getParameter("email");
        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Email is required");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        String password = request.getParameter("password");
         if (password == null || password.isEmpty()) {
            request.setAttribute("error", "Password is required");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
         }
        String pattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$";
        Pattern p = Pattern.compile(pattern);
        Matcher matcher = p.matcher(email);
        //checking credentials; passing only if the email is valid AND the user exists in the database
        UserDAO userdao = new UserDAO();
        if (!matcher.matches()) {
            request.setAttribute("error", "Email should be valid");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else if (userdao.loginCheck(email, password) == null) {
            request.setAttribute("error", "User Does Not Exist");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {  // validation success case
            User user = userdao.loginCheck(email, password);
            //valid user => create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            if (user.getUserType(user.getId()) == "employee") {
                request.getRequestDispatcher("employeeDashboard.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("managerDashboard.jsp").forward(request, response);
            }

        }
    }
    
}
