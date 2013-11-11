part of dart_mvc;

void employeesController(HttpRequest request)
{
    
    File masterPage = new File("masterpage.html");
    String responseString = "";
    
    Future<String> finishedReading = masterPage.readAsString(encoding: UTF8).then((masterPageHTML)
        {            
              responseString = "<ul class=\"employees-list\">";
      
              employeesList.forEach((Employee listObject) {
        
              responseString += "<li>"
                "<img class=\"empoloyee-photo\" src=\"/assets/minion"+listObject.employeeId+".jpg\"/>"
                "Employee id: " + listObject.employeeId + "<br/>"+
                "Employee name: " + listObject.employeeName + "<br/>"+
                "Employee gender: " + listObject.employeeGender + "<br/>"+
                "Employee dept: " + listObject.employeeDept + "<br/>"+
                "</li>";
                                                             });
      
              responseString += "</ul>";
              
              request.response.headers.add(HttpHeaders.CONTENT_TYPE, "text/html");
              
              String reponseHTML = masterPageHTML.replaceAll("%%", responseString);
              
              request.response.write(reponseHTML);
              
              request.response.close();
      
        }).catchError((e) 
            {
              print("Employees controller error: ${e.toString()}");     

              request.response.headers.add(HttpHeaders.CONTENT_TYPE, "text/html");
              request.response.write("The employees page couldn't be loaded!");
              request.response.close();
            });  
}

