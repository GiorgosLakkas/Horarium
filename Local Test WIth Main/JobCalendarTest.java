
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

public class JobCalendarTest {
    private int calendarId;
    private int managerId;
    private LocalDate dateCreated;
    private LocalDate startingDate;
    private LocalDate endingDate;
    private Map<String, List<Shift>> shiftsByDay;

    //the dateFormatter object allows the modification of a string object to a date object
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    public JobCalendarTest(int calendarId, int managerId, String dateCreatedStr, String startingDateStr, String endingDateStr) {
        
        

        this.calendarId = calendarId;
        this.managerId = managerId;
        this.dateCreated = LocalDate.parse(dateCreatedStr, dateFormatter);
        this.startingDate = LocalDate.parse(startingDateStr, dateFormatter);
        this.endingDate = LocalDate.parse(endingDateStr, dateFormatter);
    }

    public int getCalendarId() {return this.calendarId;}
    public void setCalendarId(int calendarId) {this.calendarId = calendarId;}
    public int getManagerId() {return this.managerId;}
    public void setManagerId(int managerId) {this.managerId = managerId;}
    public LocalDate getDateCreated() {return this.dateCreated;}
    public void setDateCreated(String dateCreatedStr) {this.dateCreated = LocalDate.parse(dateCreatedStr, dateFormatter);}
    public LocalDate getStartingTime() {return this.startingDate;}
    public void setStartingTime(String startingDateStr) {this.startingDate = LocalDate.parse(startingDateStr, dateFormatter);}
    public LocalDate getEndingDate() {return this.endingDate;}
    public void setEndingDate(String endingDateStr) {this.endingDate = LocalDate.parse(endingDateStr, dateFormatter);}
    


    public void FillJobCalendar(List<Shift> shifts) {

        Map<String, List<Shift>> grouped = shifts.stream()
        .collect(Collectors.groupingBy(Shift::getDayOfWeek));


        for (String day : List.of(
            "Monday", "Tuesday", "Wednesday", "Thursday",
            "Friday", "Saturday", "Sunday")) {
        grouped.putIfAbsent(day, new ArrayList<>());
    }
        
    this.shiftsByDay = grouped;

    }

    public List<Shift> getShiftsForDay(String day) {
        return shiftsByDay.getOrDefault(day, Collections.emptyList());
    }

    public Map<String, List<Shift>> getAllShifts() {
        return shiftsByDay;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder("JobCalendar: " + calendarId + "\n");
        
        for (String day : List.of(
                "Monday", "Tuesday", "Wednesday", "Thursday",
                "Friday", "Saturday", "Sunday")) {
            sb.append(day).append(":\n");
            List<Shift> shifts = shiftsByDay.get(day);

            if (shifts == null || shifts.isEmpty()) {
                sb.append("  (No shifts)\n");
            } else {

                shifts.sort(Comparator.comparing(Shift::getStartTime));
                for (Shift s : shifts) {
                    sb.append("  ").append(s).append("\n");
                }
            }
        }
        return sb.toString();
    }
}




    

