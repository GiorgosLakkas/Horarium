import java.time.*;
import java.time.format.DateTimeFormatter;

public class Shift {
    private String employeeName;
    private LocalDate date;        
    private String day;      
    private LocalDateTime startTime;
    private LocalDateTime endTime;

    // Constructor
    public Shift(String employeeName, LocalDate date, LocalTime startTime, LocalTime endTime) {
        LocalDateTime startDateTime = LocalDateTime.of(date, startTime);
        LocalDateTime endDateTime = LocalDateTime.of(date, endTime);
        

        // I'm not sure if the validity of the date inputs will be checked here
        if (!endDateTime.isAfter(startDateTime)) {
            throw new IllegalArgumentException("End time must be after start time.");
        }

        this.employeeName = employeeName;
        this.date = date;
        this.day = formatDayName(date.getDayOfWeek());
        this.startTime = startDateTime;
        this.endTime = endDateTime;
    }

    // 
    public static Shift createShift(String employeeName, String dateStr, String startStr, String endStr) {
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

        LocalDate date = LocalDate.parse(dateStr, dateFormatter);
        LocalTime start = LocalTime.parse(startStr, timeFormatter);
        LocalTime end = LocalTime.parse(endStr, timeFormatter);

        return new Shift(employeeName, date, start, end);
    }



    private static String formatDayName(DayOfWeek day) {
        // Capitalize first letter, rest lowercase (e.g. MONDAY → Monday)
        String name = day.toString().toLowerCase();
        return Character.toUpperCase(name.charAt(0)) + name.substring(1);
    }

    public Duration getDuration() {
        return Duration.between(startTime, endTime);
    }


    
    public String getEmployeeName() { return employeeName; }
    public LocalDate getDate() { return date; }
    public String getDayOfWeek() { return day; }
    public LocalDateTime getStartTime() { return startTime; }
    public LocalDateTime getEndTime() { return endTime; }

    @Override
    public String toString() {
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
        long hours = getDuration().toHours();
        long minutes = getDuration().toMinutesPart();

        return String.format(
            "Shift(%s on %s (%s): %s → %s | %d hours %d minutes)",
            employeeName,
            date,
            day,
            startTime.format(timeFormatter),
            endTime.format(timeFormatter),
            hours,
            minutes
        );
    }
}  