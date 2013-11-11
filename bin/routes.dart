part of dart_mvc;

Map routes = {
              
  "get":
  { 
    
    "/" : homeController,
    "/employees" : employeesController ,
    "/employee/id": employeeController ,
    "/assets/asset": assetsController,
    "/newemployee" : newEmployeeController,
  },
  
  "post":
  {
    "/newemployee": newEmployeeController
  }
              
};