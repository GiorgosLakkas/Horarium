package application;

import java.sql.*;
import java.util.*;
import java.time.LocalDate;
import java.time.LocalDateTime;


public class RequestDAO {
    
    //method for changing the status of pending requests based on managers' decision
    public boolean updateRequestStatus(int requestId, String newStatus) {
        Connection con = DBConnection.openConnection();
        String sql = "UPDATE Request SET status = ? WHERE request_id = ? AND status = 'pending'";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newStatus.toUpperCase());
            ps.setInt(2,requestId);
            int result = ps.executeUpdate();
            if (result == 0) {
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

    //method for requests retrieval, based on the employee_id (usage: myStats.jsp)
    public List<Request> retriveEmployeeRequests(int employeeId) {
        List<Request> requests = new ArrayList<>();
        Connection con = DBConnection.openConnection();
        String sql = "SELECT * FROM Request as r, Employee as e WHERE employee_id = ? AND r.employee_id = e.id ORDER BY r.date_created DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int requestId = rs.getInt("request_id");
                int managerId = rs.getInt("manager_id");
                //using this because of old mysql driver
                LocalDate date = rs.getDate("date_created").toLocalDate();
                String stringStatus = rs.getString("status");
                Request.Status status = Request.Status.valueOf(stringStatus.toUpperCase());
                requests.add(new Request(requestId,employeeId,managerId,date,status));
            }
            return requests;

        } catch(Exception e) {
            e.getMessage();
            return requests;
        } finally {
            DBConnection.closeConnection(con);
        }
    }

    //method for defining subclass of a request stored in the Request table
    public String defineRequestType(int requestId) {
        Connection con = DBConnection.openConnection();
        String requestType = "shiftChange"; 
        String sql = "SELECT request_id FROM AbsenceRequest WHERE request_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                requestType = "absence"; 
            }
            return requestType;
        } catch (Exception e) {
            e.printStackTrace();
            return requestType; 
        } finally {
            DBConnection.closeConnection(con);
        }
    }

     //method for absence request retrieval 
    public List<AbsenceRequest> retrieveManagerAbsenceRequests(int managerId) {
        List<AbsenceRequest> requests = new ArrayList<>();
        Connection con = DBConnection.openConnection();
        String sql = "SELECT a.request_id,employee_id,manager_id,date_created,status,start_date,end_date,absence_type FROM Request as r, AbsenceRequest as a, Manager as m WHERE r.manager_id = m.id AND r.request_id = a.request_id AND manager_id = ? ORDER BY r.date_created DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int requestId = rs.getInt("request_id");
                int employeeId = rs.getInt("employee_id");
                LocalDate date = rs.getDate("date_created").toLocalDate();
                String stringStatus = rs.getString("status");
                Request.Status status = Request.Status.valueOf(stringStatus.toUpperCase());
                LocalDate startDate = rs.getDate("start_date").toLocalDate();
                LocalDate endDate = rs.getDate("end_date").toLocalDate();
                String type = rs.getString("absence_type");
                AbsenceRequest.AbsenceType absenceType = AbsenceRequest.AbsenceType.valueOf(type.toUpperCase());
                requests.add(new AbsenceRequest(requestId,employeeId,managerId,date,status,startDate,endDate,absenceType));   
            }
            return requests;   
        } catch (Exception e) {
            e.getMessage();
            return requests;
        } finally {
            DBConnection.closeConnection(con);
        }
    }

    //method for shift change request retrieval 
    public List<ShiftChangeRequest> retrieveManagerShiftChangeRequests(int managerId) {
        List<ShiftChangeRequest> requests = new ArrayList<>();
        Connection con = DBConnection.openConnection();
        String sql = "SELECT s.request_id,employee_id,manager_id,date_created,status,old_shift_date,new_shift_date, starting_time, ending_time FROM Request as r, ShiftChangeRequest as s, Manager as m WHERE r.manager_id = m.id AND r.request_id = s.request_id AND manager_id = ? ORDER BY r.date_created DESC";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int requestId = rs.getInt("request_id");
                int employeeId = rs.getInt("employee_id");
                LocalDate date = rs.getDate("date_created").toLocalDate();
                String stringStatus = rs.getString("status");
                Request.Status status = Request.Status.valueOf(stringStatus.toUpperCase());
                LocalDate oldShiftDate = rs.getDate("old_shift_date").toLocalDate();
                LocalDate newShiftDate = rs.getDate("new_shift_date").toLocalDate();
                LocalDateTime startingTime = rs.getTimestamp("starting_time").toLocalDateTime();
                LocalDateTime endingTime = rs.getTimestamp("ending_time").toLocalDateTime();
                requests.add(new ShiftChangeRequest(requestId,employeeId,managerId,date,status,oldShiftDate,newShiftDate,startingTime,endingTime));   
            }
            return requests;   
        } catch (Exception e) {
            e.getMessage();
            return requests;
        } finally {
            DBConnection.closeConnection(con);
        }
    }

    //method for fetching remaining data based on the subclass type
    public Request fetchRemainingAttributes(Request request, String type) {
        Connection con = DBConnection.openConnection();
        String sql;
        if (type.equalsIgnoreCase("absence")) {
            sql = "SELECT start_date, end_date, absence_type FROM AbsenceRequest WHERE request_id = ?";
        } else if (type.equalsIgnoreCase("shiftChange")) {
            sql = "SELECT old_shift_date, new_shift_date, starting_time, ending_time FROM ShiftChangeRequest WHERE request_id = ?";
        } else {
            throw new IllegalArgumentException("Unknown request type: " + type);
        }
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, request.getRequestId());
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                return null;
            }
            if (type.equalsIgnoreCase("absence")) {
                return new AbsenceRequest(
                    request.getRequestId(),
                    request.getEmployeeId(),
                    request.getManagerId(),
                    request.getDate(),
                    request.getStatus(),
                    rs.getDate("start_date").toLocalDate(),
                    rs.getDate("end_date").toLocalDate(),
                    AbsenceRequest.AbsenceType.valueOf(rs.getString("absence_type").toUpperCase()));
            } else {
                return new ShiftChangeRequest(
                    request.getRequestId(),
                    request.getEmployeeId(),
                    request.getManagerId(),
                    request.getDate(),
                    request.getStatus(),
                    rs.getDate("old_shift_date").toLocalDate(),
                    rs.getDate("new_shift_date").toLocalDate(),
                    rs.getTimestamp("starting_time").toLocalDateTime(),
                    rs.getTimestamp("ending_time").toLocalDateTime());
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;

        } finally {
            DBConnection.closeConnection(con);
        }
    }
    //method for inserting new shift change requests in database tables 
    public void insertShiftChangeRequest(ShiftChangeRequest shiftChangeRequest) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "INSERT INTO ShiftChangeRequest(old_shift_date,new_shift_date,starting_time,ending_time) VALUES (?,?,?,?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1,java.sql.Date.valueOf(shiftChangeRequest.getOldShiftDate()));
            ps.setDate(2,java.sql.Date.valueOf(shiftChangeRequest.getNewShiftDate()));
            ps.setTimestamp(3, java.sql.Timestamp.valueOf(shiftChangeRequest.getStartingTime()));
            ps.setTimestamp(4, java.sql.Timestamp.valueOf(shiftChangeRequest.getEndingTime()));
            int row = ps.executeUpdate();
            if (row == 0) {
                throw new Exception("Shift Change Request was not inserted");
            }
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
    //method for inserting new absence requests in database tables 
    public void insertAbsenceRequest(AbsenceRequest absenceRequest) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "INSERT INTO AbsenceRequest(start_date,end_date,absence_type) VALUES (?,?,?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDate(1,java.sql.Date.valueOf(absenceRequest.getStartDate()));
            ps.setDate(2,java.sql.Date.valueOf(absenceRequest.getEndDate()));
            ps.setString(3,absenceRequest.getAbsenceType().toString().toLowerCase());
            int row = ps.executeUpdate();
            if (row == 0) {
                throw new Exception("Absence Request was not inserted");
            }
        } catch(Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
     //method for fetching shift change request data based on a request id
    public ShiftChangeRequest fetchShiftChangeDataByRequestId(int requestId) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "SELECT * FROM Request as r, ShiftChangeRequest as s WHERE r.request_id = s.request_id AND s.request_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new ShiftChangeRequest(requestId, rs.getInt("employee_id"), rs.getInt("manager_id"),
                rs.getDate("date_created").toLocalDate(),Request.Status.valueOf(rs.getString("status").toUpperCase()),
                rs.getDate("old_shift_date").toLocalDate(),rs.getDate("new_shift_date").toLocalDate(),
                rs.getTimestamp("starting_time").toLocalDateTime(),rs.getTimestamp("ending_time").toLocalDateTime());
            } else {
                throw new Exception("No shift change request exists in this id");
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
    //method for fetching absence request data based on a request id
    public AbsenceRequest fetchAbsenceDataByRequestId(int requestId) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "SELECT * FROM Request AS r, AbsenceRequest AS a WHERE r.request_id = a.request_id AND a.request_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,requestId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                throw new Exception("No absence request exists in this id");
            } else {
                return new AbsenceRequest(requestId, rs.getInt("employee_id"), 
                rs.getInt("manager_id"),
                rs.getDate("date_created").toLocalDate(),
                Request.Status.valueOf(rs.getString("status").toUpperCase()),
                rs.getDate("start_date").toLocalDate(), 
                rs.getDate("end_date").toLocalDate(),
                AbsenceRequest.AbsenceType.valueOf(rs.getString("absence_type").toUpperCase()));
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
    //method for filling Days_Off table, based on calculated absence interval, after an absence request is accepted
    public void insertDaysOff(int requestId, LocalDate starDate, LocalDate endDate) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "INSERT INTO Days_Off(request_id,days_off) VALUES (?,?)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,requestId);
            ps.setInt(2,AbsenceRequest.countWeekdays(starDate, endDate));
            int row = ps.executeUpdate();
            if (row == 0) {
                throw new Exception("No days off were inserted");
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
    //method for retrieving startDate, endDate and days off for an accepted absence request 
    public AbsenceDTO fetchAcceptedAbsenceCrucialDetails(int requestId) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "SELECT start_date,end_date,days_off FROM AbsenceRequest AS a, Days_Off AS d WHERE a.request_id = d.request_id AND a.request_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,requestId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                throw new Exception("No accepted absence request with this id");
            } else {
                return new AbsenceDTO(rs.getDate("start_date").toLocalDate(),rs.getDate("end_date").toLocalDate(),rs.getInt("days_off"));
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
    //method for inserting a request in the general Request table and returning its id for further usage
    public int insertRequest(Request request) throws Exception {
        Connection con = DBConnection.openConnection();
        String sql = "INSERT INTO Request(employee_id,manager_id,date_created,status) VALUES(?,?,?,?)";
        String query = "SELECT max(request_id) AS last_request_id FROM Request";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,request.getEmployeeId());
            ps.setInt(2,request.getManagerId());
            ps.setDate(3,java.sql.Date.valueOf(request.getDate()));
            ps.setString(4,request.getStatus().toString().toLowerCase());
            int row = ps.executeUpdate();
            if (row == 0) {
                throw new Exception("Request was not inserted");
            } else {
                //request was successfully inserted in database
                PreparedStatement ps2 = con.prepareStatement(query);
                ResultSet rs = ps2.executeQuery();
                if (rs.next()) {
                    int max = rs.getInt("last_request_id");
                    return max;
                } else {
                    throw new Exception("No maximum was inserted");
                }
            }
        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            DBConnection.closeConnection(con);
        }
    }
}
