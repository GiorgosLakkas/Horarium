package application_layer;

import java.time.LocalDate;

public class Request {
    enum Status {
        PENDING, ACCEPTED, REJECTED
    }

    private int requestId;
    private int employeeId;
    private int managerId; 
    private LocalDate date;
    private Status status;

    public Request() {}
    public Request(int requestId,int employeeId,int managerId, LocalDate date, Status status) {
        this.requestId = requestId;
        this.employeeId = employeeId;
        this.managerId = managerId;
        this.date = date;
        this.status = status;
    }

    public int getRequestId() {return this.requestId;}
    public void setRequestId(int requestId) {this.requestId = requestId;}
    public int getEmployeeId() {return this.employeeId;}
    public void setEmployeeId(int employeeId) {this.employeeId = employeeId;}
    public int getManagerId() {return this.managerId;}
    public void setManagerId(int managerId) {this.managerId = managerId;}
    public LocalDate getDate() {return this.date;}
    public void setDate(LocalDate date) {this.date = date;}
    public Status getStatus() {return this.status;}
    public void setStatus(Status status) {this.status = status;}

    @Override 
    public String toString() {
        return "Request Id: " + requestId + ", Employee Id:" + employeeId + ", Manager Id:" + managerId + ", Date:" + date
         + ", Status:" + status;
    }
    
}
