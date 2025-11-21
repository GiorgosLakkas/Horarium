package application_layer;

import java.time.*;
import java.time.format.DateTimeFormatter;



//This implementation allows for the employee to have multiple shifts in a day without any problems. I suggest we avoid creating double shifts for now 
//and later, if we decide that double shifts ought to be disallowd we can discuss possible solutions later. Nevertheless the flow of the programm is not affected by this.
public class Shift {
    private int shiftId;
    private int employeeId;
    private int managerId;
    private int calendarId;
    private LocalDate date;             
    private LocalTime startTime; 
    private LocalTime endTime;

    public Shift() {}

    public Shift(int shiftId, int employeeId, int managerId, int calendarId, LocalDate date, LocalTime startTime, LocalTime endTime) {


        // I'm not sure if the validity of the date inputs will be checked here
        if (!endTime.isAfter(startTime)) {
            throw new IllegalArgumentException("End time must be after start time.");
        }

        this.employeeId = employeeId;
        this.managerId = managerId;
        this.shiftId = shiftId;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
    }

 
    public int getEmployeeID() {return employeeId;}
    public int getShiftID() {return shiftId;}
    public int getManagerID() {return managerId;}
    public int getCalendarId() {return calendarId;}
    public LocalDate getDate() {return date;}
    public LocalTime getStartTime() {return startTime;}
    public LocalTime getEndTime() {return endTime;}
    public void setEmployeeID(Integer employeeId) {this.employeeId = employeeId;}
    public void setShiftID(Integer shiftId) {this.shiftId = shiftId;}
    public void setManagerID(Integer managerId) {this.managerId = managerId;}
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