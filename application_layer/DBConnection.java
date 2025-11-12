import java.sql.*;

public class DBConnection {

    // Method to open a connection
    public static Connection openConnection() {
        Connection connection = null;

        try {
            //Load the MySQL JDBC driver
            Class.forName("com.mysql.jdbc.Driver");

            //Database credentials
            String url = "jdbc:mysql://195.251.249.131:3306/ismgroup6";
            String username = "ismgroup6";
            String password = "7#ufdc";

            //Open connection
            connection = DriverManager.getConnection(url, username, password);
        } 
        catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found: " + e.getMessage());
        } 
        catch (SQLException e) {
            System.out.println("Error connecting to database: " + e.getMessage());
        }

        return connection;
    }

    //Method to close the connection
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } 
            catch (SQLException e) {
                System.out.println("Error closing connection: " + e.getMessage());
            }
        }
    }
}
