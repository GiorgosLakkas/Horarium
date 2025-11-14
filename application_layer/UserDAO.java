import java.sql.*; 


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

}