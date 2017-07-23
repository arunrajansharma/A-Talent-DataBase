<!--            CSE 532 - Project 2

File name : success.jsp
Author    : Arun Rajan, 110921170

Brief Description : This is landing page for the response we get from the server regarding all the queries.
                    It uses JSTL 1.2 for displaying the results that is encoded in a list of POJOs

Pledge:

I pledge my  honor that all parts of this project were done by me  alone and without collaboration with anybody else.


 -->


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<title>Insert title here</title>
</head>
<body>
<h3 align ="center">  Successful </h1>

<c:if test="${ not empty namesList }">
  <h4 align = center> The Contestant pair Information</h4>
  <table border="1" align = "center">
  	<tr>
  	<th> Name 1</th>
  	<th> Name 2</th>
  	</tr>
  	<c:forEach items="${namesList}" var="pair">
  	 <tr>
  	 		<td>${pair.name1 }</td>
  	 		<td>${pair.name2 }</td>
  	 </tr>
  	</c:forEach>	
  </table>
</c:if>

<a href="login.jsp" align = "center"> Query Page </a>


</body>
</html>