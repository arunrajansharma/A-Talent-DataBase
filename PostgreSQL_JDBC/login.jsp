<!--            CSE 532 - Project 2

File name : Login.jsp
Author    : Arun Rajan, 110921170

Brief Description : This is landing part of the project and a really simple page just to show query description 
					and provides a button for each query.
					It sends request to the Server

Pledge:

I pledge my  honor that all parts of this project were done by me  alone and without collaboration with anybody else.

 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Welcome</title>
</head>
<body>
    <h4 align="center"> Welcome, Project 2</h4>
	<br>
	<h4 align = "right"> CSE 532 (CSE 522) : Theory of Database Systems</h4>
	<h4 align = "right"> Arun Rajan, 110921170</h4>
	<form action="LogicController" method="post">
	
	<!--   Enter Query Number : <input type="text" name="query"> <br>
	 <input type="submit"/>
	-->
	
	<table border="1"  align="center">
	<tr>
		<td>Find all pairs of contestants who auditioned the same artwork on the same date and got the
           same score from at least one judge (not necessarily the same judge).</td>
		<td><button type="submit" name="query" value="1" > Query 1</button></td>
	</tr>
	<tr>	
		<td>Find all pairs of contestants who happened to audition the same artwork (in possibly different shows) and got the same maximal score and the same minimal score for that audition (from possibly different judges).</td>
		<td><button type="submit" name="query" value="2" > Query 2</button></td>
	</tr>
	<tr>	
		<td>Find all pairs of contestants who auditioned the same artwork in (possibly different) shows that had the same number of judges and the two contestants received the same average score for that audition.</td>
		<td><button type="submit" name="query" value="3" > Query 3</button></td>
		
	</tr>
	<tr>
		<td>Find all pairs of contestants (by name) such that the first contestant in each pair performed in all the shows in which the second contestant did (possibly performing different artworks).</td>
		<td><button type="submit" name="query" value="4" > Query 4</button></td>
		
	</tr>
	<tr>	
		<td>Find all close rivals. The close rivals relation is the transitive closure of the following binary relation: X and Y are direct close rivals iff they both performed the same artwork in the same show and their overall average scores are within 0.2 of each other.</td>
		<td><button type="submit" name="query" value="5" > Query 5</button></td>
	</tr>
	
	</table>
	</form>
	
	
</body>
</html>