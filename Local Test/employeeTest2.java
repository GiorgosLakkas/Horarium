

import java.util.*;

public class employeeTest2 extends UserTest { 
    private int daysOffRemaining;
    private List<JobCalendarTest2> calendar;
    private List<Shift2> shifts;

    public employeeTest2() {} 
    
    //Added the list of shifts attribute 
    public employeeTest2(int id, String name, String surname, String username, String password, String email, int companyId,int daysOffRemaining,
     List<JobCalendarTest2> calendar, List<Shift2> shifts) {
        super(id,name,surname,username,password,email,companyId);
        this.daysOffRemaining = daysOffRemaining;
        this.calendar = calendar;
        this.shifts = shifts;
    }


    public int getDaysOffRemaining() {return this.daysOffRemaining;}
    public void setDaysOffRemaining(int daysOffRemaining) {this.daysOffRemaining = daysOffRemaining;}
    public List<JobCalendarTest2> getCalendar() {return this.calendar;}
    public void setCalendar(List<JobCalendarTest2> calendar) {this.calendar = calendar;}
    public List<Shift2> getShifts() {return this.shifts;}
    public void setShift(List<Shift2> shifts) {this.shifts = shifts;}

    @Override
    public String toString() {
        return super.toString() + ", Days Off Remaining:" + daysOffRemaining ;
    }
    
}
