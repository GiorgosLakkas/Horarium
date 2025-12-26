package application;

import java.time.LocalDate;
import java.time.LocalTime;

public class ShiftEditDTO {
    // Keep these as String for JSON compatibility (as your comments requested)
    private String shiftId;     // "" or null means "new shift"
    private String employeeId;  // required
    private String start;       // "HH:mm"
    private String end;         // "HH:mm"
    private String date;        // "yyyy-MM-dd"

    public ShiftEditDTO() {}

    public String getShiftId() { return shiftId; }
    public void setShiftId(String shiftId) { this.shiftId = shiftId; }

    public String getEmployeeId() { return employeeId; }
    public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }

    public String getStart() { return start; }
    public void setStart(String start) { this.start = start; }

    public String getEnd() { return end; }
    public void setEnd(String end) { this.end = end; }

    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    // Convert DTO -> Shift using existing Shift constructors (no Shift(int) needed)
    public Shift toShiftForInsert(int managerId, int calendarId) {
        int empId = Integer.parseInt(employeeId);
        LocalTime st = LocalTime.parse(start);
        LocalTime en = LocalTime.parse(end);
        LocalDate d = LocalDate.parse(date);
        return new Shift(empId, managerId, calendarId, st, en, d);
    }

    public Shift toShiftForUpdate(int managerId, int calendarId) {
        int sId = Integer.parseInt(shiftId);
        int empId = Integer.parseInt(employeeId);
        LocalTime st = LocalTime.parse(start);
        LocalTime en = LocalTime.parse(end);
        LocalDate d = LocalDate.parse(date);
        return new Shift(sId, empId, managerId, calendarId, st, en, d);
    }

    public boolean isNew() {
        return shiftId == null || shiftId.trim().isEmpty() || shiftId.trim().equals("0");
    }
}
