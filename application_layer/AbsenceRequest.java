package application_layer;

import java.time.* ;

public class AbsenceRequest extends Request {

    enum AbsenceType {
        HOLIDAY, SICKNESS, MATERNAL 
    }

    private LocalDate startDate;
    private LocalDate endDate;
    private AbsenceType absenceType;

    public AbsenceRequest() {}
    public AbsenceRequest(int requestId,int employeeId,int managerId, LocalDate date, Status status, LocalDate startDate,
       LocalDate endDate, AbsenceType absenceType) {
        super(requestId,employeeId,managerId,date,status);
        this.startDate = startDate;
        this.endDate = endDate;
        this.absenceType = absenceType;
    }

    public LocalDate getStartDate() {return this.startDate;}
    public void setStartDate(LocalDate startDate) {this.startDate = startDate;}
    public LocalDate getEndDate() {return this.endDate;}
    public void setEndDate(LocalDate endDate) {this.endDate = endDate;}
    public AbsenceType getAbsenceType() {return this.absenceType;}
    public void setAbsenceType(AbsenceType absenceType) {this.absenceType = absenceType;}

    @Override
    public String toString() {
        return super.toString() + ", Start Date:" + startDate + ", End Date:"+  endDate + ", Absence Type:" + absenceType;
    }
    
}
