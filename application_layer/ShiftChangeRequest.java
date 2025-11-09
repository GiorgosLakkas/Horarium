package application_layer;

import java.time.*;

public class ShiftChangeRequest extends Request {
    private LocalDate oldShiftDate;
    private LocalDate newShiftDate;
    private LocalDateTime startingTime ;
    private LocalDateTime endingTime; 

    public ShiftChangeRequest() {}
    public ShiftChangeRequest(int requestId,int employeeId,int managerId, LocalDate date, Status status,LocalDate oldShiftDate,
        LocalDate newShiftDate, LocalDateTime startingTime, LocalDateTime endingTime) {
        super(requestId,employeeId,managerId,date,status);
        this.oldShiftDate = oldShiftDate;
        this.newShiftDate = newShiftDate;
        this.startingTime = startingTime;
        this.endingTime = endingTime;
    }

    public LocalDate getOldShiftDate() {return this.oldShiftDate;}
    public void setOldShiftDate(LocalDate oldShiftDate) {this.oldShiftDate = oldShiftDate;}
    public LocalDate getNewShifDate() {return this.newShiftDate;}
    public void setNewShiftChange(LocalDate newShiftDate) {this.newShiftDate = newShiftDate;}
    public LocalDateTime getStartingTime() {return this.startingTime;}
    public void setStartingTime(LocalDateTime startingTime) {this.startingTime = startingTime;}
    public LocalDateTime getEndingTime() {return this.endingTime;} 
    public void setEndingTime(LocalDateTime endingTime) {this.endingTime = endingTime;}

    @Override
    public String toString() {
        return super.toString() + ", Old Shift Date:" + oldShiftDate + ", New Shift Date" + newShiftDate + ", Starting Time"
         + startingTime + ", Ending Time:" + endingTime;
    }
    
}
