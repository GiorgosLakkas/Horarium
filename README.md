# Running the Project Locally with Tomcat

For anyone who wants to try this project with Tomcat locally, follow these steps:

---

## 1. Download Tomcat

Download Apache Tomcat 10.1.48 from the official website:

[Apache Tomcat 10 Download](https://tomcat.apache.org/download-10.cgi)

---

## 2. Start Tomcat

1. Open a Command Prompt (CMD) or Terminal.
2. Navigate to the `bin` folder of your Tomcat installation. For example:

```
cd "C:\TOMCAT\apache-tomcat-10.1.48\bin"
```
---

## 3. Deploy Tomcat 
```
startup.bat
```

---
## 4. Shut Down Tomcat
```
shutdown.bat
```

NOTE: Be sure to create WEB-INF folder with inner folders the classes folder and the lib (the jars) and web.xml

---
## 5. Run Servlets and JSP Pages

JSP pages do not need anything special. Just refresh browser after each change!

Servlets: In this version of Tomcat, you need the Jakarta jar file (put it in referenced libraries on VS Code)

Download Jakarta Jar: 
[Jakarta Jar File](https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar)

In order for the changes to be showed, you need to recompile the classes (.class files in WEB-INF/classes)