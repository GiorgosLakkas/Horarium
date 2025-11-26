package application_layer;


public class Employee extends User {
    private int managerId;
    private int daysOffRemaining;

    
    
    public Employee() {}
    public Employee(int id, String name, String surname, String username, String password, String email, int companyId,int daysOffRemaining,
     int managerId) {
        super(id,name,surname,username,password,email,companyId);
        this.managerId = managerId;
        this.daysOffRemaining = daysOffRemaining;
    }

    public int deductAbsenceDays(int requestedDays) {
        if (requestedDays < 0) {
            throw new IllegalArgumentException("Requested days cannot be negative.");
        }
    
        if (requestedDays > this.daysOffRemaining) {
            // Hard stop: business rule breach
            throw new IllegalArgumentException("Requested days exceed remaining balance.");
        }
    
        // Straight-through deduction
        this.daysOffRemaining = this.daysOffRemaining - requestedDays;
    
        return daysOffRemaining;
    }

    public float daysOfPercentage() {
        return ((this.daysOffRemaining)/30)*100;
    }
    
    

   
    public int getDaysOffRemaining() {return this.daysOffRemaining;}
    public void setDaysOffRemaining(int daysOffRemaining) {this.daysOffRemaining = daysOffRemaining;}
    public int getManagerId() {return this.managerId;}
    public void setManagerId(int managerId) {this.managerId = managerId;}


    @Override
    public String toString() {
        return super.toString() + "Manager Id :" + managerId + ", Days Off Remaining:" + daysOffRemaining ;
    }
   
}
