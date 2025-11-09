package application_layer;

import java.time.*;
import java.util.*;

public class JobCalendar {
    private int calendarId;
    private int managerId;
    private LocalDate dateCreated;
    private LocalDate startingDate;
    private LocalDate endingDate;
    private List<Employee> employees; 

    public JobCalendar() {}
    public JobCalendar(int calendarId, int managerId, LocalDate dateCreated, LocalDate startingDate, LocalDate endingDate, List<Employee> employees) {
        this.calendarId = calendarId;
        this.managerId = managerId;
        this.dateCreated = dateCreated;
        this.startingDate = startingDate;
        this.endingDate = endingDate;
        this.employees = employees;
    }

    public int getCalendarId() {return this.calendarId;}
    public void setCalendarId(int calendarId) {this.calendarId = calendarId;}
    public int getManagerId() {return this.managerId;}
    public void setManagerId(int managerId) {this.managerId = managerId;}
    public LocalDate getDateCreated() {return this.dateCreated;}
    public void setDateCreated(LocalDate dateCreated) {this.dateCreated = dateCreated;}
    public LocalDate getStartingTime() {return this.startingDate;}
    public void setStartingTime(LocalDate startingDate) {this.startingDate = startingDate;}
    public LocalDate getEndingDate() {return this.endingDate;}
    public void setEndingDate(LocalDate endingDate) {this.endingDate = endingDate;}
    public List<Employee> getEmployees() {return this.employees;}
    public void setEmployees(List<Employee> employees) {this.employees = employees;}

    @Override 
    public String toString() {
        return "Calendar Id:" + calendarId + ", Manager Id:" + managerId + ", Date Created:" + dateCreated
         + ", Starting Date:" + startingDate + ", Ending Date:" + endingDate ;
    }

    
}
