package application;

import java.time.LocalDate;

//DTO stands for Data Transfering Object
public class AbsenceDTO {
    private LocalDate startDate;
    private LocalDate endDate;
    private int daysOff;

    public AbsenceDTO() {}
    public AbsenceDTO(LocalDate startDate, LocalDate endDate, int daysOff) {
        this.startDate = startDate;
        this.endDate = endDate;
        this.daysOff = daysOff;
    }
    
    public LocalDate getStartDate() {return startDate;}
    public LocalDate getEndDate() { return endDate;}
    public int getDaysOff() {return this.daysOff;}
    public void setStartDate(LocalDate startDate) {this.startDate = startDate;}
    public void setEndDate(LocalDate endDate) {this.endDate = endDate;}
    public void setDaysOff(int daysOff) {this.daysOff=daysOff;}
}
