package application;

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
            ps.setTime(1,java.sql.Time.valueOf(shift.getStartTime()));
            ps.setTime(2,java.sql.Time.valueOf(shift.getEndTime()));
            ps.setDate(3,java.sql.Date.valueOf(shift.getDate()));
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
    public void removeShift(Shift shift) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "DELETE FROM Shift WHERE shift_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,shift.getShiftId());
            int row = ps.executeUpdate();
            if (row == 0) {
                throw new Exception("No shift was removed");
            } 
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }

    //method for shifts retriever based on manager id
    public List<Shift> retrieveShifts(int managerId) {
        List<Shift> shifts = new ArrayList<>();
        Connection con = DBConnection.openConnection();
        String sql = "SELECT * FROM Shift as s, User as u WHERE s.employee_id =u.id and manager_id = ? ORDER BY start_time,surname";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int shiftId = rs.getInt("shift_id");
                int employeeId = rs.getInt("employee_id");
                int jobCalendarId = rs.getInt("job_calendar_id");
                LocalTime startTime = rs.getTime("start_time").toLocalTime();
                LocalTime endTime = rs.getTime("end_time").toLocalTime();
                LocalDate date = rs.getDate("date").toLocalDate();
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
    public void putShiftsToDatabase(List<Shift> shifts) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "INSERT INTO Shift(employee_id, manager_id, job_calendar_id, start_time, end_time, date) VALUES(?,?,?,?,?,?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            for (Shift s : shifts) {
                ps.setInt(1, s.getEmployeeId());
                ps.setInt(2,s.getManagerId());
                ps.setInt(3,s.getCalendarId());
                ps.setTime(4, java.sql.Time.valueOf(s.getStartTime()));
                ps.setTime(5, java.sql.Time.valueOf(s.getEndTime()));
                ps.setDate(6, java.sql.Date.valueOf(s.getDate()));

                ps.executeUpdate();
            }
        } catch (Exception e) {
            throw new Exception("Problem Occured!" + e.getMessage(), e);
        } finally {
            DBConnection.closeConnection(con);
        }   
    }
    //method for fetching all crucial data about a shift to be changed, based on an accepted shift change request
    public Shift fetchShiftDataFromRequestByEmployeeId(LocalDate date, int employeeId) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "SELECT * FROM Shift as s,Request as r WHERE s.employee_id = r.employee_id and s.employee_id = ? AND s.date = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,employeeId);
            ps.setDate(2,java.sql.Date.valueOf(date));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Shift(rs.getInt("s.shift_id"),
                employeeId,
                rs.getInt("s.manager_id"),
                rs.getInt("s.job_calendar_id"),
                rs.getTime("s.start_time").toLocalTime(),
                rs.getTime("s.end_time").toLocalTime(), date);
            } else {
                throw new Exception("No shift at this date exists");
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
    //method for putting a shift in a the Shift table
    public void insertShift(Shift shift) throws Exception { 
        Connection con = DBConnection.openConnection();
        String sql = "INSERT INTO Shift(employee_id,manager_id,job_calendar_id,start_time,end_time,date) VALUES(?,?,?,?,?,?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, shift.getEmployeeId());
            ps.setInt(2,shift.getManagerId());
            ps.setInt(3,shift.getCalendarId());
            ps.setTime(4, java.sql.Time.valueOf(shift.getStartTime()));
            ps.setTime(5, java.sql.Time.valueOf(shift.getEndTime()));
            ps.setDate(6, java.sql.Date.valueOf(shift.getDate()));
            int row = ps.executeUpdate();
            if (row == 0) {
                throw new Exception("No shift was inserted");
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
    //method for retrieving remaining shifts of an employee from current date until the job calendar's end date
    public List<Shift> fetchRemainingWeeklyShiftsByEmployeeId(int employeeId) throws Exception {
        List<Shift> shifts = new ArrayList<>();
        Connection con = DBConnection.openConnection();
        String sql = "SELECT * FROM Shift AS s WHERE employee_id = ? AND date >= CURDATE() AND date <= (SELECT ending_date FROM Job_Calendar AS j WHERE j.calendar_id = s.job_calendar_id) ORDER BY date";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                shifts.add(new Shift(
                    rs.getInt("shift_id"),
                    employeeId,
                    rs.getInt("manager_id"),
                    rs.getInt("job_calendar_id"),
                    rs.getTime("start_time").toLocalTime(),
                    rs.getTime("end_time").toLocalTime(),
                    rs.getDate("date").toLocalDate()
                ));
            }
            return shifts;
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
    //method for retrieving a shift based on the shift_id
    public Shift fetchShiftById(int shiftId) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "SELECT * FROM Shift WHERE shift_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,shiftId);
            ResultSet rs =ps.executeQuery();
            if (!rs.next()) {
                throw new Exception("No shift exists with this id");
            } else {
                return new Shift(shiftId, rs.getInt("employee_id"),
                  rs.getInt("manager_id"),
                  rs.getInt("job_calendar_id"), 
                  rs.getTime("start_time").toLocalTime(),
                  rs.getTime("end_time").toLocalTime(),
                  rs.getDate("date").toLocalDate());
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
    //method for removing a list of shifts => utilized in edit 
    public void removeShiftsInEdit(List<Shift> shifts) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "DELETE FROM Shift WHERE shift_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            for (Shift s : shifts) {
                ps.setInt(1,s.getShiftId());
                ps.executeUpdate();
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
        //method for fetching all weekly shifts of an employee, based on the current job_calendar and employee_id
    public List<Shift> fetchAllWeeklyShiftsByEmployeeId(JobCalendar jobCalendar, int employeeId) throws Exception {
        List<Shift> shifts = new ArrayList<>();
        Connection con = DBConnection.openConnection();
        String sql = "SELECT * FROM Shift AS s, Job_Calendar AS j WHERE J.calendar_id = s.job_calendar_id AND s.employee_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                shifts.add(new Shift(rs.getInt("shift_id"),
                employeeId,
                rs.getInt("manager_id"),
                rs.getInt("job_calendar_id"),
                rs.getTime("start_time").toLocalTime(),
                rs.getTime("end_time").toLocalTime(),
                rs.getDate("date").toLocalDate()));
            }
            return shifts;
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
