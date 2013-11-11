//Every file that is 'part of' a library MUST always includes the part of statemant
//at the beginning of th file
part of dart_mvc;

//The controller that manipulates the assets requests (images, js files, css files)
void assetsController(HttpRequest request, String assetName)
{
  //Possible values of the extension variable
  //'jpg', 'jpeg', 'png', 'gif', 'css', 'js'
  String extension = assetName.split(".")[1];
  
  //Possible values of the contentType variable
  // 'image/jpeg', 'image/png', 'image/gif', 'text/css', 'text/javascript'
  String contentType;
  
  switch (extension) 
  {
    case "jpg":
    case "jpeg":
      contentType = "image/jpeg";  
    break;
      
    case "png":
      contentType = "image/png";
    break;
    
    case "gif":
      contentType = "image/gif";  
    break;
      
    case "css":
      contentType = "text/css";  
    break;
    
    case "js":
      contentType = "text/javascript";
    break;
  }
 
  //we create a file object
  File asset = new File("assets/"+assetName);
   
  //Asychronous reading the file we send the data to the client
  asset.readAsBytes().then((List<int> charCodes) {
    
    request.response.headers.add(HttpHeaders.CONTENT_TYPE, contentType);
    request.response.add(charCodes);
    request.response.close();
    
  }).catchError((e) 
      {
        print("Asset error: ${e.toString()}");     

        request.response.headers.add(HttpHeaders.CONTENT_TYPE, "text/html");
        request.response.write("The asset couldn't be loaded!");
        request.response.close();
      
      });
}