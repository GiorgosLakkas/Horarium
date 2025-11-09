package application_layer;

import java.util.*;

public class Employee extends User { 
    private int daysOffRemaining ;
    private List<JobCalendar> calendar ;

    public Employee() {} 

    public Employee(int id, String name, String surname, String username, String password, String email, int companyId,int daysOffRemaining,
     List<JobCalendar> calendar) {
        super(id,name,surname,username,password,email,companyId);
        this.daysOffRemaining = daysOffRemaining;
        this.calendar = calendar;
    }

   
    public int getDaysOffRemaining() {return this.daysOffRemaining;}
    public void setDaysOffRemaining(int daysOffRemaining) {this.daysOffRemaining = daysOffRemaining;}
    public List<JobCalendar> getCalendar() {return this.calendar;}
    public void setCalendar(List<JobCalendar> calendar) {this.calendar = calendar;}

    @Override
    public String toString() {
        return super.toString() + ", Days Off Remaining:" + daysOffRemaining ;
    }
    
}
