import java.util.List;

public class Main {
    public static void main(String[] args) {
        //Create several shifts, normaly the shifts are created through the manager
        List<Shift> shifts = List.of(
            Shift.createShift("Alice", "2025-11-10", "09:00", "17:00"),   // Monday
            Shift.createShift("Panos", "2025-11-10", "08:00", "10:00"),
            Shift.createShift("Bob", "2025-11-11", "10:00", "18:00"),     // Tuesday
            Shift.createShift("Charlie", "2025-11-12", "12:00", "20:00"), // Wednesday
            Shift.createShift("Dana", "2025-11-14", "09:00", "17:00"),    // Friday
            Shift.createShift("Legenis", "2025-11-13", "11:00", "11:01")
        );

        // Create a JobCalendar
        JobCalendarTest Schedule = new JobCalendarTest(1, 123, "2025-11-12", "2025-11-10", "2025-11-15");

        // Fill the JobCalendar’s shift data
        Schedule.FillJobCalendar(shifts);

        
        System.out.println(Schedule);

        
        System.out.println("\nShifts on Wednesday:");
        for (Shift s : Schedule.getShiftsForDay("Wednesday")) {
            System.out.println("  " + s);
        }
    }
}
