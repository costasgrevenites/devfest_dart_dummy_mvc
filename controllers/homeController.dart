//Every file that is 'part of' a library MUST always includes the part of statemant
//at the beginning of th file
part of dart_mvc;

void homeController(HttpRequest request)
{
  
  //Two file objects with the html files
  File masterPage = new File("masterpage.html");
  File homeView = new File("views/home.html");
  
  //Asychronous reading of masterpage.html
  masterPage.readAsString(encoding: UTF8).then((masterPageHTML)
      {
         homeView.readAsString(encoding: UTF8).then((homeViewHTML) 
             {
      
              //We replace the %% characters with the home view html
              String reponseHTML = masterPageHTML.replaceAll("%%", homeViewHTML);
           
              request.response.headers.add(HttpHeaders.CONTENT_TYPE, "text/html");
              request.response.write(reponseHTML);
              request.response.close();
      
        });
      }).catchError((e) 
          {
            print("Home controller error: ${e.toString()}");     

            request.response.headers.add(HttpHeaders.CONTENT_TYPE, "text/html");
            request.response.write("The home page couldn't be loaded!");
            request.response.close();
          });
}