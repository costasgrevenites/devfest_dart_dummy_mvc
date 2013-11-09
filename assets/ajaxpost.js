function postAsync()
{
	xmlhttp = new XMLHttpRequest();

	xmlhttp.onreadystatechange = function()
  	{
  		if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
    	{
    		document.getElementById("next-step").innerHTML = xmlhttp.responseText;
    	};
    }
	
	var id = encodeURIComponent(document.getElementById("id").value)
	var name = encodeURIComponent(document.getElementById("name").value)
	var gender = encodeURIComponent(document.getElementById("gender").value)
	var dept = encodeURIComponent(document.getElementById("dept").value)

	var parameters = "id=" + id + "&name=" + name + "&gender=" + gender + "&dept=" + dept; 

	xmlhttp.open("POST","/newemployee",true);
	xmlhttp.send(parameters);
}