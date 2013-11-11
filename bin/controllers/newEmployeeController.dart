//Every file that is 'part of' a library MUST always includes the part of statemant
//at the beginning of th file
part of dart_mvc;

void newEmployeeController(HttpRequest request)
{
  //If the request method is 'get'
  if(request.method.toLowerCase() == "get")
  {
      //Two file objects with the html files
        File masterPage = new File("masterpage.html");
        File formView = new File("views/form.html");
    
        //Asychronous fille reading
        masterPage.readAsString(encoding: UTF8).then((masterPageHTML)
        {
            formView.readAsString(encoding: UTF8).then((formView) 
            {
        
              //We replace the %% characters with the home view html
              String reponseHTML = masterPageHTML.replaceAll("%%", formView);
              
              request.response.headers.add(HttpHeaders.CONTENT_TYPE, "text/html");
              request.response.write(reponseHTML);
              request.response.close();
        
            });
        }).catchError((e) 
            {
                print("Add new employee controller error: ${e.toString()}");     

                request.response.headers.add(HttpHeaders.CONTENT_TYPE, "text/html");
                request.response.write("The form page couldn't be loaded!");
                request.response.close();
            });
  }
  
  //if request method is equal to post
  else if(request.method.toLowerCase() == "post")
  {
    print("post success");    
    
    print(request.headers.contentType.mimeType);
    
    //if the form's mime type is 'multipart/form-data' the 
    if(request.headers.contentType.mimeType == "multipart/form-data")
    {
      //the code responsible for the file uploading
      HttpBodyHandler.processRequest(request).then((body) 
          {
            //1. we get the file binary data
            HttpBodyFileUpload uploadedFile = body.body["photo"];
            
            //2. we find the inserted employee into the employee list
            Employee lastInsertedEmployee = employeesList.last;
            
            //3. we get the current directory path because we need it to build the new file's path 
            Directory currentDirectory =  Directory.current;
            
            //4. we write the bytes to the path. For Windows OS we need to set a pair of backslashes '\\'
            new File(currentDirectory.path+"\\assets\\minion"+lastInsertedEmployee.employeeId+".jpg").create().then((File file)
                {
                            
                  file.writeAsBytes(uploadedFile.content, mode: FileMode.WRITE).then((_) 
                  { 
                    var uri = Uri.parse(request.uri.host+"/employees");
                    request.response.redirect(uri);
                  });
              
            } );
              
          });
    }
    else
    {
        //the form's data are saved as binary data into the List<int>
        //the List<int> is equal to Bytes class you might have used in other
        //programming languages as Java or C#
        List<int> formData = new List<int>(); 
    
        request.listen(formData.addAll, onDone: () 
        {
          
          //We cast the form data from binary to string
          //The query string's form is like key=value&key=value&key=value
          var queryString = new String.fromCharCodes(formData);
      
          //The data is split by the '&' character
          List<String> data = queryString.split("&");
      
          Map keyValues = new Map();
      
          data.forEach((String keyValue) 
              {
                //now we split again by the '=' character
                keyValues[keyValue.split("=")[0]] = keyValue.split("=")[1].replaceAll("%20", " ");
        
          });
      
          //We create a new employee object
          Employee newEmployee = new Employee();
          
          newEmployee..employeeId = keyValues["id"]
              ..employeeName = keyValues["name"]
              ..employeeGender = keyValues["gender"]
              ..employeeDept = keyValues["dept"];
      
          employeesList.add(newEmployee);
          
          String employeeString = "";
          
          employeeString += "Employee id: " + newEmployee.employeeId + "<br/>"+
          "Employee name: " + newEmployee.employeeName + "<br/>"+
          "Employee gender: " + newEmployee.employeeGender + "<br/>"+
          "Employee dept: " + newEmployee.employeeDept + "<br/>";
          
          
          String photoForm = "";
          photoForm += "<form method=\"post\" action=\"/newemployee\" enctype=\"multipart/form-data\">"
          +"<input type=\"file\" id=\"photo\" name=\"photo\">"
          +"<input type=\"submit\" value=\"Upload photo\"></form>";
          
          request.response.headers.add(HttpHeaders.CONTENT_TYPE, "text/html");
          request.response.write("<span class=\"success\">New employee created</span><br/>");
          request.response.write(employeeString);
          request.response.write("<h4>Upload employee's photo</h4>");
          request.response.write(photoForm);
          request.response.close();
    });
  }

}

}

