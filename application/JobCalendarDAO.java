package application;

import java.sql.*;
import java.time.LocalDate;

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
            ps.setDate(2, java.sql.Date.valueOf(jobCalendar.getDateCreated()));

            ps.setDate(3, java.sql.Date.valueOf(jobCalendar.getStartingDate()));
            ps.setDate(4, java.sql.Date.valueOf(jobCalendar.getEndingDate()));
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
            throw new Exception("Problem Occured!" + e.getMessage(), e);
        } finally {
            DBConnection.closeConnection(con);
        }
    }
     //method for showing proper calendar in the dashboards
    public JobCalendar fetchCurrentJobCalendar(LocalDate currentDate) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "SELECT * FROM Job_Calendar WHERE starting_date <= ? AND ending_date >= ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1,java.sql.Date.valueOf(currentDate));
            ps.setDate(2,java.sql.Date.valueOf(currentDate));
            ResultSet rs = ps.executeQuery();
            //we suppose that it returns a single calendar for these specific dates 
            if (rs.next()) {
                return new JobCalendar(rs.getInt("calendar_id"),
                rs.getInt("manager_id"),
                rs.getDate("date_created").toLocalDate(),
                rs.getDate("starting_date").toLocalDate(),
                rs.getDate("ending_date").toLocalDate());
            } else {
                throw new Exception("No calendar with this date exists");
            }  
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    } 
        public JobCalendar getCurrentJobCalendar(LocalDate date, int managerId) throws Exception {
        String sql = "SELECT * FROM job_calendar " +
                     "WHERE starting_date <= ? AND ending_date >= ? AND manager_id = ? " +
                     "ORDER BY calendar_id DESC LIMIT 1";
        Connection con = DBConnection.openConnection();
    
        try {

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1, java.sql.Date.valueOf(date));
            ps.setDate(2, java.sql.Date.valueOf(date));
            ps.setInt(3, managerId);
    
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new JobCalendar(
                        rs.getInt("calendar_id"),
                        rs.getInt("manager_id"),
                        rs.getDate("date_created").toLocalDate(),
                        rs.getDate("starting_date").toLocalDate(),
                        rs.getDate("ending_date").toLocalDate()
                    );
                } else {
                    return null; 
                }
            }
    
        } catch (Exception e) {
            throw new Exception("Problem Occurred! " + e.getMessage(), e);
        } finally {
            DBConnection.closeConnection(con);            
        }
    }
    
}
