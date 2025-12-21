package application;

import java.time.*;
import java.time.format.DateTimeFormatter;



//This implementation allows for the employee to have multiple shifts in a day without any problems. I suggest we avoid creating double shifts for now 
//and later, if we decide that double shifts ought to be disallowd we can discuss possible solutions later. Nevertheless the flow of the programm is not affected by this.
public class Shift {
    private int shiftId;
    private int employeeId;
    private int managerId;
    private int calendarId;            
    private LocalTime startTime; 
    private LocalTime endTime;
    private LocalDate date; 

    public Shift() {}

    public Shift(int shiftId, int employeeId, int managerId, int calendarId, LocalTime startTime, LocalTime endTime,  LocalDate date) {


        // I'm not sure if the validity of the date inputs will be checked here
        if (!endTime.isAfter(startTime)) {
            throw new IllegalArgumentException("End time must be after start time.");
        }

        this.employeeId = employeeId;
        this.managerId = managerId;
        this.shiftId = shiftId;
        this.calendarId = calendarId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.date = date;
    }

    public Shift(int employeeId, int managerId, int calendarId, LocalTime startTime, LocalTime endTime,  LocalDate date) {


        // I'm not sure if the validity of the date inputs will be checked here
        if (!endTime.isAfter(startTime)) {
            throw new IllegalArgumentException("End time must be after start time.");
        }

        this.employeeId = employeeId;
        this.managerId = managerId;
        this.calendarId = calendarId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.date = date;
    }

 
    public int getEmployeeId() {return employeeId;}
    public int getShiftId() {return shiftId;}
    public int getManagerId() {return managerId;}
    public int getCalendarId() {return calendarId;}
    public LocalDate getDate() {return date;}
    public LocalTime getStartTime() {return startTime;}
    public LocalTime getEndTime() {return endTime;}
    public void setEmployeeId(Integer employeeId) {this.employeeId = employeeId;}
    public void setShiftId(Integer shiftId) {this.shiftId = shiftId;}
    public void setManagerId(Integer managerId) {this.managerId = managerId;}
    public void setCalendarId(int calendarId) {this.calendarId = calendarId;}
    public void setDate(LocalDate date) {this.date = date;}
    public void setStartTime(LocalTime startTime) {this.startTime = startTime;}
    public void setEndTime(LocalTime endTime) {this.endTime = endTime;}
    

    public String getDay() {
        return this.date.getDayOfWeek().name();

    }


    public Duration getDuration() {
        return Duration.between(startTime, endTime);
    }
    

    //This could be implemented with the set methods, I thought it makes more sense to get all the info that needs to change as a single method
    public void editShift(LocalDate newDate, LocalTime newStart, LocalTime newEnd){

        this.date = newDate;
        this.startTime = newStart;
        this.endTime = newStart;

    }

    @Override
    public String toString() {
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
        

        return String.format(
            "Shift %s, employeeId %s, managerId %s, caledarId %s, (%s → %s),  date %s",
            shiftId,
            employeeId,
            managerId,
            calendarId,
            startTime.format(timeFormatter),
            endTime.format(timeFormatter), 
            date
           
        );
    }
}  