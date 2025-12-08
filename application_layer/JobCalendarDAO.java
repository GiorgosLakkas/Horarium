package application_layer;

import java.sql.*;

public class JobCalendarDAO {

    //method for new calendar insetion in database
    public int insertJobCalendarReturnMaxId(JobCalendar jobCalendar) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "INSERT INTO Job_Calendar(manager_id,date_created,starting_date,ending_date) VALUES(?,?,?,?)";
        String query = "SELECT max(calendar_id) as maximum FROM Job_Calendar where manager_id = ?";
        int maximum = 0 ;
        try { 
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,jobCalendar.getManagerId());
            ps.setObject(2,jobCalendar.getDateCreated());
            ps.setObject(3,jobCalendar.getStartingDate());
            ps.setObject(4,jobCalendar.getEndingDate());
            int row = ps.executeUpdate();
            if (row == 0) {
                throw new Exception("Problem: No insertion was performed");
            }
            PreparedStatement stm = con.prepareStatement(query);
            stm.setInt(1,jobCalendar.getManagerId());
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
              maximum = rs.getInt("maximum");
            }
            return maximum;
        } catch (Exception e) {
            e.getMessage();
            throw new Exception("Problem Occured!");
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
