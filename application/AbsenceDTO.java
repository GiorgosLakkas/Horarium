package application;

import java.time.LocalDate;

//DTO stands for Data Transfering Object/ The attributes need to be string so the js can recognize them
public class AbsenceDTO {
    public int employee_id;
    private String startDate;
    private String endDate;
    private int daysOff;

    public AbsenceDTO() {}
    public AbsenceDTO(int employee_id, LocalDate startDate, LocalDate endDate, int daysOff) {
        this.employee_id = employee_id;
        this.startDate = startDate.toString();
        this.endDate = endDate.toString();
        this.daysOff = daysOff;
    }
    
    public int getEmployeeId(){return employee_id;}
    public String getStartDate() {return startDate;}
    public String getEndDate() { return endDate;}
    public int getDaysOff() {return this.daysOff;}
    public void setEmployeeId(int employee_id) {this.employee_id = employee_id;}
    public void setStartDate(LocalDate startDate) {this.startDate = startDate.toString();}
    public void setEndDate(LocalDate endDate) {this.endDate = endDate.toString();}
    public void setDaysOff(int daysOff) {this.daysOff=daysOff;}
}
