package application;

import java.sql.*; 
import java.util.*;

public class UserDAO {
     

  public User loginCheck(String email, String password) {
    User user = null;
    final String query = "SELECT * FROM USER WHERE email = ? and password = ?";
    Connection connection = DBConnection.openConnection();

    try {
        PreparedStatement ps = connection.prepareStatement(query);
        ps.setString(1, email);
        ps.setString(2, PasswordHashing.hashPassword(password));
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {  
            int id = rs.getInt("id");
            String name = rs.getString("name");
            String surname = rs.getString("surname");
            String username = rs.getString("username");
            int companyId = rs.getInt("company_id");

            user = new User(id, name, surname, username, PasswordHashing.hashPassword(password), email, companyId);
        }

        rs.close();
        ps.close();
    } catch (Exception e) {
        System.out.println("Problem during execution of query: " + e.getMessage());
    } finally {
        DBConnection.closeConnection(connection);
    }

    return user;
  }
    public static String defineUserType(int userId) {
        String userType = "employee";
        //query for checking whether the user is an employee or a manager; using Employee table to check if it is in; 
        // if yes => employee instance , else : manager instance
        final String query = "SELECT * FROM User AS U WHERE U.id = ? AND U.id IN (SELECT id FROM Employee)";
        Connection connection = DBConnection.openConnection();
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1,userId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                userType = "manager";
            }
        } catch (Exception e) {
            System.out.println("Problem during execution of query: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(connection);
        }
        return userType;

        }

    public static String getManagerNameDetailsById(int managerId) {
        Connection con = DBConnection.openConnection();
        String sql = "SELECT Name,Surname FROM User WHERE id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,managerId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return "";
            } else {
                return rs.getString("name") + " " +  rs.getString("surname");
            }

        } catch (Exception e) {
            e.getMessage();
            return "";
        } finally {
            DBConnection.closeConnection(con);
        }
    }

    //method for fetching details of an employee object, in order to downcast it from user
    public Employee fetchEmployeeDetails(User user) {
        Connection con = DBConnection.openConnection();
        String sql = "SELECT manager_id,days_off_remaining FROM Employee WHERE id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,user.getId());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                 return new Employee(user.getId(), user.getName(), user.getSurname(), user.getUsername(), user.getPassword(), user.getEmail()
                ,user.getCompanyId(), rs.getInt("days_off_remaining"), rs.getInt("manager_id"));
            } else {
                return null;
            } 
        } catch (Exception e) {
            e.getMessage();
            return null;
        } finally {
            DBConnection.closeConnection(con);
        }
    }

    public static String getEmployeeNameDetailsById(int employeeId) {
        Connection con = DBConnection.openConnection();
        String sql = "SELECT Name,Surname FROM User WHERE id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,employeeId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return "";
            } else {
                return rs.getString("name") + " " +  rs.getString("surname");
            }

        } catch (Exception e) {
            e.getMessage();
            return "";
        } finally {
            DBConnection.closeConnection(con);
        }
    }

    //method for retrieving employees based on a manager id
    public List<Employee> fetchEmployeesByManagerId(int managerId) {
        List<Employee> employees = new ArrayList<>();
        Connection con = DBConnection.openConnection();
        String sql = " select u.id, u.name, u.surname, u.password, u.email, u.company_id, e.manager_id, e.days_off_remaining from User as u , employee as e where u.id = e.id and manager_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name =  rs.getString("name");
                String surname = rs.getString("surname");
                String password = rs.getString("password");
                String email = rs.getString("email");
                int companyId = rs.getInt("company_id");
                int daysOffRemaining = rs.getInt("days_off_remaining");
                employees.add(new Employee(id, name, surname, surname, password, email, companyId, daysOffRemaining, managerId));
            }
            return employees;
        } catch(Exception e) {
            e.getMessage();
            return employees;
        } finally {
            DBConnection.closeConnection(con);
        }
    }

}