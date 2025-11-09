package application_layer;

public class Company {
    private int id ;
    private String companyName ;

    public Company() {}

    public Company(int id, String companyName) {
        this.id = id;
        this.companyName = companyName;
    }
    
    public int getCompanyId() {return this.id;}
    public void setCompanyId(int id) {this.id = id;} 
    public String getCompanyName() {return this.companyName;}
    public void setCompanyName(String companyName) {this.companyName = companyName;}

    @Override
    public String toString() {
        return "Company Id" + id + ", Company Name" + companyName;

    }


}
