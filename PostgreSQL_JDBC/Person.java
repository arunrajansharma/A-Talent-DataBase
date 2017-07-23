/***************************************************************

						CSE 532 - Project 2

File name : Person.java
Author 	  : Arun Rajan, 110921170

Brief Description : This is simple Plain Old Java Object to store the values and display results on jsp pages.

Pledge:

I pledge my  honor that all parts of this project were done by me  alone and without collaboration with anybody else.
**************************************************************/

package controllers;

public class Person {
	private String name1;
	private String name2;
	
	public Person(String a, String b){
		name1 = a;
		name2 = b;
	}

	public String getName1() {
		return name1;
	}

	public void setName1(String name1) {
		this.name1 = name1;
	}

	public String getName2() {
		return name2;
	}

	public void setName2(String name2) {
		this.name2 = name2;
	}
	
	
}
