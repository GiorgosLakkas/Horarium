

import java.util.*;

public class employeeTest extends UserTest { 
    private int daysOffRemaining;
    private List<JobCalendarTest> calendar;
    private List<Shift> shifts;

    public employeeTest() {} 
    
    //Added the list of shifts attribute 
    public employeeTest(int id, String name, String surname, String username, String password, String email, int companyId,int daysOffRemaining,
     List<JobCalendarTest> calendar, List<Shift> shifts) {
        super(id,name,surname,username,password,email,companyId);
        this.daysOffRemaining = daysOffRemaining;
        this.calendar = calendar;
        this.shifts = shifts;
    }


    public int getDaysOffRemaining() {return this.daysOffRemaining;}
    public void setDaysOffRemaining(int daysOffRemaining) {this.daysOffRemaining = daysOffRemaining;}
    public List<JobCalendarTest> getCalendar() {return this.calendar;}
    public void setCalendar(List<JobCalendarTest> calendar) {this.calendar = calendar;}
    public List<Shift> getShifts() {return this.shifts;}
    public void setShift(List<Shift> shifts) {this.shifts = shifts;}

    @Override
    public String toString() {
        return super.toString() + ", Days Off Remaining:" + daysOffRemaining ;
    }
    
}
