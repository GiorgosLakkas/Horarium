package application_layer;

import java.sql.*;
import java.util.*;
import java.time.LocalTime;
import java.time.LocalDate;

public class ShiftDAO {

    //method for updating an already created shift
    public boolean updateShift(Shift shift) {
        Connection con = DBConnection.openConnection();
        String sql = "UPDATE Shift SET start_time = ? , end_time = ?, date = ? WHERE shift_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setObject(1,shift.getStartTime());
            ps.setObject(2,shift.getEndTime());
            ps.setObject(3,shift.getDate());
            ps.setInt(4,shift.getShiftId());
            int row = ps.executeUpdate();
            if (row == 0) {
                return false ;
            }
            return true;

        } catch (Exception e) {
            e.getMessage();
            return false;
        } finally {
            DBConnection.closeConnection(con);
        }
    }

    //method for deleting non fulfilled shifts
    public boolean removeShift(Shift shift) {
        Connection con = DBConnection.openConnection();
        String sql = "DELETE FROM Shift WHERE shift_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,shift.getShiftId());
            int row = ps.executeUpdate();
            if (row > 0) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.getMessage();
            return false;
        } finally {
            DBConnection.closeConnection(con);
        }
    }

    //method for shifts retriever based on manager id
    public List<Shift> retrieveShifts(int managerId) {
        List<Shift> shifts = new ArrayList<>();
        Connection con = DBConnection.openConnection();
        String sql = "SELECT * FROM Shift WHERE manager_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int shiftId = rs.getInt("shift_id");
                int employeeId = rs.getInt("employee_id");
                int jobCalendarId = rs.getInt("job_calendar_id");
                LocalTime startTime = rs.getObject("start_time",LocalTime.class);
                LocalTime endTime = rs.getObject("end_time",LocalTime.class);
                LocalDate date = rs.getObject("date",LocalDate.class);
                shifts.add(new Shift(shiftId, employeeId, managerId, jobCalendarId, startTime, endTime, date));
            }
            return shifts;
        } catch (Exception e) {
            e.getMessage();
            return shifts;
        } finally {
            DBConnection.closeConnection(con);
        }
    }

    //method for putting a created shift list in the Shift table (database)
    public void putShiftsToDatabase(List<Shift> shifts) {
        Connection con = DBConnection.openConnection();
        String sql = "INSERT INTO Shift VALUES(?,?,?,?,?,?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            for (Shift s : shifts) {
                ps.setInt(1, s.getEmployeeId());
                ps.setInt(2,s.getManagerId());
                ps.setInt(3,s.getCalendarId());
                ps.setObject(4,s.getStartTime());
                ps.setObject(5,s.getEndTime());
                ps.setObject(6, s.getDay());
            }
        } catch (Exception e) {
            e.getMessage();
        } finally {
            DBConnection.closeConnection(con);
        }
        
        
    }


}
