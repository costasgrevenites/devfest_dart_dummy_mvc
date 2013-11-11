//Author:      Konstantinos Grevenitis - konstantinos.grevenitis@gmail.com
//For:         GDG THESSALONIKI 2013 D3VF3ST - http://devfest.gdgthess.org/
//Description: This a dummy MVC site build with the Dart language. - https://www.dartlang.org
//Tip:         If you don't know what MVC design pattern is please refer to http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller 

//The whole dart_mvc project is a library, asseblied with parts
//Each part of the library is another dart file
library dart_mvc;

//These are the core Dart libraries
//For more information https://www.dartlang.org/docs/dart-up-and-running/contents/ch03.html
import 'dart:io';
import 'dart:async';
import 'dart:convert';

//This package is an extra library, developed by a third party, and not only, installed with pub manager
//For more information https://www.dartlang.org/docs/dart-up-and-running/contents/ch04-tools-pub.html
import 'package:http_server/http_server.dart';

//Other part files of the dart_mvc library

//This file has all the MVC website routes 
part 'routes.dart';

//The controllers directory includes all the controllers dart files (C)
part 'controllers/homeController.dart';
part 'controllers/employeesController.dart';
part 'controllers/employeeController.dart';
part 'controllers/assetsController.dart';
part 'controllers/newEmployeeController.dart';

//The models directory includes all the models dart files (M)
part 'models/employee.dart';

//A global variable name employeeList
//This list holds only objects of type 'Employee'
List<Employee> employeesList;

void main() 
{

  loadEmployees();
  
  //We create a web server by using dart:io HTTPServer class
  HttpServer.bind('127.0.0.1', 1234).then((HttpServer server) 
      {
    
        //The server listens the request
        server.listen((request) 
          {
      
            //The requestMethod vabiable's possible values
            //are GET, POST in lower case
            String requestMethod = request.method.toLowerCase();
            
            //The path variable's path possible values 
            //are the following:
            // '/'
            // '/employees'
            // '/newemployee'
            String path = request.uri.toString();
          
            
            //The Map class is a dictionary type class
            //that stores everything using the key value logic
            //Here we have all the controllers methods' name as values
            //and the keys are the paths
            //For more information http://api.dartlang.org/docs/releases/latest/dart_core/Map.html
            Map getControllers = routes[requestMethod];
            
            if(path.split('/')[1] != "favicon.ico")
            {
              if (requestMethod == "get")
              {
                
                print("Request method:" + requestMethod);   
                print("Request path:" + path);
                
                try 
                {
                  if(path.contains(new RegExp(r"(/assets/.)")))
                  {
                    getControllers["/"+path.split('/')[1]+"/asset"](request, path.split('/')[2]);
                  }
                  else if(path.contains(new RegExp(r"(employee/.)")) )
                  {
                    getControllers["/"+path.split('/')[1]+"/id"](request, path.split('/')[2]);
                  }
                  else
                  {
                    getControllers[path](request);
                  }
                  
                }
                catch (e)
                {
                  
                  print(e.toString());
                  request.response.write("Couldn't load page!");
                  request.response.close();
                }
              }
              
              if (requestMethod == "post")
              {
                getControllers[path](request);
              }
            }

        },
        onError: (error) => print("Error starting HTTP server: $error"));
  });
}


void loadEmployees()
{
  //Three dummy Employee objests are created
  Employee employee1 = new Employee();
  
  employee1..employeeId = "1" //the double dot '..' cascade allows us to perform multiple operations on the members of a single object;
      ..employeeName = "John Dee"
      ..employeeGender = "Male"
      ..employeeDept = "Computer Science Dept";
      
  Employee employee2 = new Employee();
  
  employee2..employeeId = "2"
      ..employeeName = "Anjelina Jolie"
      ..employeeGender = "Female"
      ..employeeDept = "Accounting Dept";
  
  Employee employee3 = new Employee();
  
  employee3..employeeId = "3"
      ..employeeName = "Ronnie James Dio"
      ..employeeGender = "Male"
      ..employeeDept = "Linguistics Dept";
  
  
  //Instatiation of the Employee List
  employeesList = new List<Employee>();
  
  employeesList.add(employee1);
  employeesList.add(employee2);
  employeesList.add(employee3);
  
}