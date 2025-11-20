package application_layer;

import java.time.*;
import java.time.format.*;

public class Shift {
    private int shiftId;
    private int employeeId;
    private int managerId;
    private int calendarId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private LocalDate date; 
    
    
    public Shift() {}
    public Shift(int shiftId, int employeeId, int managerId, int calendarId, LocalDateTime startTime, LocalDateTime endTime, LocalDate date) {
        this.shiftId = shiftId;
        this.employeeId = employeeId;
        this.managerId = managerId;
        this.calendarId = calendarId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.date = date;
    }
    public int getShiftId() {return this.shiftId;}
    public void setShiftId(int shiftId) {this.shiftId = shiftId;}
    public int getEmployeeId() {return this.employeeId;}
    public void setEmployeeId(int employeeId) {this.employeeId = employeeId;}
    public int getManagerId() {return this.managerId;}
    public void setManagerId(int managerId) {this.managerId = managerId;}
    public int getCalendarId() {return this.calendarId;}
    public void setCalendarId(int calendarId) {this.calendarId = calendarId;}
    public LocalDateTime getStartTime() {return this.startTime;}
    public void setStartTime(LocalDateTime startTime) {this.startTime = startTime;}
    public LocalDateTime getEndTime() {return this.endTime;}
    public void setEndTime(LocalDateTime endTime) {this.endTime = endTime;}
    public LocalDate getDate() {return this.date;}
    public void setDate(LocalDate date) {this.date = date;}


    @Override
    public String toString() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
           return String.format(
           "Shift %s, employeeId %s, managerId %s, caledarId %s, (%s → %s),  date %s",
           shiftId,
           employeeId,
           managerId,
           calendarId,
           startTime.format(formatter),
           endTime.format(formatter),
           date
         
       );
    }
}