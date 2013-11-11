//Every file that is 'part of' a library MUST always includes the part of statemant
//at the beginning of th file
part of dart_mvc;

void employeeController(HttpRequest request, String id)
{
  //The file object of masterpage html
  File masterPage = new File("masterpage.html");
  String responseString = "";
  
  
  masterPage.readAsString(encoding: UTF8).then((masterPageHTML)
      {
    
              //we print the employees list to the client
              employeesList.forEach((Employee listObject) {
      
              if(listObject.employeeId == id)
              {
                responseString += "<img class=\"empoloyee-photo\" src=\"/assets/minion"+listObject.employeeId+".jpg\"/>"+
                "Employee id: " + listObject.employeeId + "<br/>"+
                "Employee name: " + listObject.employeeName + "<br/>"+
                "Employee gender: " + listObject.employeeGender + "<br/>"+
                "Employee dept: " + listObject.employeeDept + "<br/>";
              }
              
                                                     });
            
            //We replace the %% characters with the home view html            
            String reponseHTML = masterPageHTML.replaceAll("%%", responseString);
           
            request.response.headers.add(HttpHeaders.CONTENT_TYPE, "text/html");
            request.response.write(reponseHTML);
            request.response.close();
    
      }).catchError((e) 
          {
            print("Employee controller error: ${e.toString()}");     

            request.response.headers.add(HttpHeaders.CONTENT_TYPE, "text/html");
            request.response.write("The employee page couldn't be loaded!");
            request.response.close();
          });  
}