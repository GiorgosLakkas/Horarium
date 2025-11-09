package application_layer;

public class User {
    private int id ;
    private String name ;
    private String surname; 
    private String username;
    private String password;
    private String email;
    private int companyId;

    public User() {}
  

    public User(int id, String name, String surname, String username, String password, String email, int companyId) {
        this.id = id;
        this.name = name;
        this.surname = surname;
        this.username = username; 
        this.password = PasswordHashing.hashPassword(password);
        this.email = email;
        this.companyId = companyId;
    }

    public int getId() { return this.id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return this.name ; }
    public void setName(String name) {this.name = name;}
    public String getSurname() {return this.surname;}
    public void setSurname(String surname) {this.surname = surname;}
    public String getUsername() {return this.username;}
    public void setUsername(String username) {this.username = username;}
    // password to be stored as a hashed version of its original for safety purposes
    public String getPassword() {return this.password;}
    public void setPassword(String password) {this.password = PasswordHashing.hashPassword(password);}
    public String getEmail() {return this.email;}
    public void setEmail(String email) {this.email = email;}
    public int getCompanyId() {return this.companyId;}
    public void setCompanyId(int companyId) {this.companyId = companyId;}

    @Override
    public String toString() {
        return "User Id:" + id + ", Name:" + name + ", Surname:" + surname + ", Username:" + username + ", Email:" + email + 
          ", Company Id :" + companyId;
    }
    
}
