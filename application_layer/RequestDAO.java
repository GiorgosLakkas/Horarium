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
        String sql = "SELECT * FROM Request as r, Employee as e WHERE employee_id = ? AND r.employeeId = e.employeeId";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1,employeeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int requestId = rs.getInt("request_id");
                int managerId = rs.getInt("manager_id");
                LocalDate date = rs.getObject("date",LocalDate.class);
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
        String requestType = "absence";
        String sql = "SELECT * FROM Request as r WHERE r.request_id IN (SELECT request_id FROM AbsenceRequest)";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                requestType = "shiftChange";
            }
            return requestType;
        } catch (Exception e) {
            e.getMessage();
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
                LocalDate date = rs.getObject("date",LocalDate.class);
                String stringStatus = rs.getString("status");
                Request.Status status = Request.Status.valueOf(stringStatus.toUpperCase());
                LocalDate starDate = rs.getObject("start_date",LocalDate.class);
                LocalDate endDate = rs.getObject("end_date",LocalDate.class);
                String type = rs.getString("absence_type");
                AbsenceRequest.AbsenceType absenceType = AbsenceRequest.AbsenceType.valueOf(type.toUpperCase());
                requests.add(new AbsenceRequest(requestId,employeeId,managerId,date,status,starDate,endDate,absenceType));   
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
                LocalDate date = rs.getObject("date",LocalDate.class);
                String stringStatus = rs.getString("status");
                Request.Status status = Request.Status.valueOf(stringStatus.toUpperCase());
                LocalDate oldShiftDate = rs.getObject("old_shift_type",LocalDate.class);
                LocalDate newShiftDate = rs.getObject("new_shift_date",LocalDate.class);
                LocalDateTime startingTime = rs.getObject("starting_time", LocalDateTime.class);
                LocalDateTime endingTime = rs.getObject("ending_time",LocalDateTime.class);
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


}
