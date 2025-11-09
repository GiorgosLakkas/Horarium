package application_layer;

public class Manager extends User {
    private int requestsApproaved ;

    public Manager() {}
    public Manager(int id, String name, String surname, String username, String password, String email, int companyId,int requestsApproaved) {
        super(id,name,surname,username,password,email,companyId);
        this.requestsApproaved = requestsApproaved;
    }

    public int getRequestsApproaved() {return this.requestsApproaved;}
    public void setRequestsApproaved(int requestsApproaved) {this.requestsApproaved = requestsApproaved;}

    @Override 
    public String toString() {
        return super.toString() + ", Requests Approaved:" + requestsApproaved;
    }

    
}
