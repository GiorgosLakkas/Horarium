
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

// This class operates assuming that the types of the dates given are datetime and not string

public class JobCalendarTest2 {
    private int calendarId;
    private int managerId;
    private LocalDate dateCreated;
    private LocalDate startingDate;
    private LocalDate endingDate;
    private Map<String, List<Shift2>> shiftsByDay;

    //the dateFormatter object allows the modification of a string object to a date object
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    public JobCalendarTest2(int calendarId, int managerId, LocalDate dateCreated, LocalDate startingDate, LocalDate endingDate) {
        
        

        this.calendarId = calendarId;
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
    


    public void FillJobCalendar(List<Shift2> shifts) {

        Map<String, List<Shift2>> grouped = shifts.stream()
        .collect(Collectors.groupingBy(Shift2::getDayOfWeek));


        for (String day : List.of(
            "Monday", "Tuesday", "Wednesday", "Thursday",
            "Friday", "Saturday", "Sunday")) {
        grouped.putIfAbsent(day, new ArrayList<>());
    }
        
    this.shiftsByDay = grouped;

    }

    public List<Shift2> getShiftsForDay(String day) {
        return shiftsByDay.getOrDefault(day, Collections.emptyList());
    }

    public Map<String, List<Shift2>> getAllShifts() {
        return shiftsByDay;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("JobCalendar: " + calendarId + "\n");
        
        for (String day : List.of(
                "Monday", "Tuesday", "Wednesday", "Thursday",
                "Friday", "Saturday", "Sunday")) {
            sb.append(day).append(":\n");
            List<Shift2> shifts = shiftsByDay.get(day);

            if (shifts == null || shifts.isEmpty()) {
                sb.append("  (No shifts)\n");
            } else {

                shifts.sort(Comparator.comparing(Shift2::getStartTime));
                for (Shift2 s : shifts) {
                    sb.append("  ").append(s).append("\n");
                }
            }
        }
        return sb.toString();
    }
}




    

