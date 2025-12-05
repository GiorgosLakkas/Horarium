package application_layer;

import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;


public class JobCalendar {


    private int calendarId;
    private int managerId;
    private LocalDate dateCreated;
    private LocalDate startingDate;
    private LocalDate endingDate;
     
    private Map<String, List<Shift>> shiftsByDay = new HashMap<>();
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");


    public JobCalendar() {}
    public JobCalendar(int calendarId, int managerId, LocalDate dateCreated, LocalDate startingDate, LocalDate endingDate) {
        this.calendarId = calendarId;
        this.managerId = managerId;
        this.dateCreated = dateCreated;
        this.startingDate = startingDate;
        this.endingDate = endingDate;
        
    }

    public JobCalendar(int managerId, LocalDate dateCreated, LocalDate startingDate, LocalDate endingDate) {

        this.managerId = managerId;
        this.dateCreated = dateCreated;
        this.startingDate = startingDate;
        this.endingDate = endingDate;
        
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
    


    public void fillJobCalendar(List<Shift> shifts) {

        shiftsByDay = shifts.stream()
        .collect(Collectors.groupingBy(Shift::getDay));


        for (String day : List.of(
            "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY",
            "FRIDAY", "SATURDAY", "SUNDAY")) {
            shiftsByDay.putIfAbsent(day, new ArrayList<>());
        }
        
   

    }
    //The first method returns the weekly shifts of the employees. The second one returns the shifts of a specific day
    
    public Map<String, List<Shift>> getJobCalendar() {
        return shiftsByDay;
    } 
     
    public List<Shift> getShiftsForDay(String day) {
        return shiftsByDay.getOrDefault(day, Collections.emptyList());
    }

    public List<Shift> getAllShifts() {
        List<Shift> allShifts = shiftsByDay.values()
                            .stream()
                            .flatMap(List::stream)
                            .toList();
        return allShifts; 
    }
    

    public void removeShift(Shift oldShift) {
        
        //we might need to check if the times and date is null here.(1)
        if (oldShift == null) return;

        String dayKey = oldShift.getDay().toUpperCase();
        
        // Get the list for the dayKey. This object (dayShifts) is the exact same list that is mapped to the shift's day
        List<Shift> dayShifts = shiftsByDay.get(dayKey);
        
        if (dayShifts.contains(oldShift)) {
            // Remove the shift from that day's list. The HashMap is also updated here
            dayShifts.remove(oldShift);
        }
    }
    
    public void addShift(Shift newShift) {
        //(1)
        if (newShift == null) return;
        String dayKey = newShift.getDay().toUpperCase();
        List<Shift> dayShifts = shiftsByDay.get(dayKey);

        //The shift is added in any case unless it is null
        dayShifts.add(newShift);

    }


    @Override 
    public String toString() {
        return "Calendar Id:" + calendarId + ", Manager Id:" + managerId + ", Date Created:" + dateCreated
         + ", Starting Date:" + startingDate + ", Ending Date:" + endingDate ;
    }

    
}
