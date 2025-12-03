package application_layer;

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
        String sql = "SELECT * FROM Request as r, Employee as e WHERE employee_id = ? AND r.employee_id = e.id";
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
        String sql = "SELECT * FROM Request as r, AbsenceRequest as a, Manager as m WHERE r.manager_id = m.id AND r.request_id = a.request_id AND manager_id = ?";
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
        String sql = "SELECT * FROM Request as r, ShiftChangeRequest as s, Manager as m WHERE r.manager_id = m.id AND r.request_id = s.request_id AND manager_id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int requestId = rs.getInt("request_id");
                int employeeId = rs.getInt("employee_id");
                LocalDate date = rs.getDate("date").toLocalDate();
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
}
