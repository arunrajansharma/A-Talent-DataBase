/***************************************************************

						CSE 532 - Project 2

File name : LogicController.java
Author 	  : Arun Rajan, 110921170

Brief Description : This file contains the source code for the servelet used in the project. 
					This servelet receives requests from the client and does following:
					a) Figure out which Query
					b) Establish a connection with the Database
					c) Create required view by the project with the first execution
					d) Creates a list of POJO, Person 
					e) Redirects that list to Success.jsp page to display


Pledge:

I pledge my  honor that all parts of this project were done by me  alone and without collaboration with anybody else.
**************************************************************/


package controllers;


import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

 
public class LogicController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static boolean isSetupDone = false;
	private static Connection conn;
	static {
		String url = "jdbc:postgresql://localhost/arunrajan";
		String uname = "arunrajan";
		String password = "";
		try{
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(url,uname,password);
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
	}
	public LogicController() {
		super();
	}
 
	private ResultSet getQuery1() throws SQLException{
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery("select distinct A.cname, B.cname from contestant_table as A, contestant_table as B, audition_table as C, audition_table as D, judge_score as E, judge_score F, show_table G, show_table H where  G.sdate = H.sdate AND C.show_id = G.oid AND D.show_id = H.oid AND C.cont_id <> D.cont_id AND D.art_id = C.art_id AND C.cont_id = A.oid AND D.cont_id = B.oid AND E.arr && F.arr AND E.anum = C.anum  AND F.anum = D.anum AND A.cname < B.cname;");
		return rs;
	}
	
	private ResultSet getQuery2() throws SQLException{
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery("select A.cname, B.cname from contestant_table as A, contestant_table as B, maxmin as C, maxmin as D where A.oid = C.cont_id AND B.oid = D.cont_id AND A.cname<B.cname AND C.maxscore = D.maxscore AND C.minscore = D.minscore AND C.art_id = D.art_id order by A.cname;");
		return rs;
	}
	
	private ResultSet getQuery3() throws SQLException{
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery("select A.cname, B.cname from  contestant_table as A, contestant_table as B, Q3_aux as C, Q3_aux as D  where C.avgscore = D.avgscore AND C.noj = D.noj AND C.art_id = D.art_id AND A.cname < B.cname   AND C.cont_id <> D.cont_id AND C.cont_id = A.oid AND D.cont_id = B.oid order by  A.cname, B.cname;");
		return rs;
	}
	
	private ResultSet getQuery4() throws SQLException{
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery("select A.cname, B.cname from contestant_table as A, contestant_table as B, q4_aux_1 as C, q4_aux_1 as D where A.oid = C.cont_id AND  B.oid = D.cont_id AND C.cont_id <> D.cont_id AND ((C.allshows @> D.allshows) OR (C.allshows = D.allshows)) ORDER by A.cname, B.cname;");
		return rs;
	}
	
	private ResultSet getQuery5() throws SQLException{
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery("WITH RECURSIVE Q5_3(X, Y) AS (SELECT X, Y from q5_binary UNION  select A.X, B.Y FROM q5_binary as A, Q5_3 as B WHERE A.Y = B.X) SELECT * FROM Q5_3 where X<Y order by X, Y;");
		return rs;
	}
	
	
	
	
	private void setupCreateViews() throws SQLException{
		Statement st = conn.createStatement();
		
		// for query 1
		st.execute("create temporary view judge_score as(select anum, ARRAY(select (s).score from UNNEST(scores) s) arr from audition_table);");
		
		// for query 2 
		st.execute("create temporary view maxmin as (select show_id, cont_id, art_id,(select MAX((s).score) from unnest(scores) s) as maxscore,(select MIN((s).score) from unnest(scores) s) as minscore from audition_table);");
	
		// for query 3
		st.execute("create temporary view Q3_aux as (select show_id, cont_id, art_id,(select count((s).score) from unnest(scores) s) as noj,(Select AVG((s).score) from unnest(scores) s) as avgscore from audition_table);");
		
		//query4
		st.execute("create temporary view Q4_aux as (select cont_id, show_id from audition_table group by cont_id,show_id);");
		st.execute("create temporary view q4_aux_1 as (select cont_id, array_agg(show_id) allshows from q4_aux group by cont_id);");
		
		//query5
		st.execute("create temporary view q5_avg as( select cont_id, sum(sumscores)/sum(count1) avgscore from (select cont_id, (select count((s).score) from unnest(scores) s) as count1,(select sum((s).score) from unnest(scores) s) as sumscores from audition_table)  as Z group by z.cont_id);");
		st.execute("create temporary view q5_aux as(select A.cont_id, A.show_id, A.art_id, B.avgscore from audition_Table as A, q5_avg as B where A.cont_id = B.cont_id);");
		st.execute("create temporary view Q5_binary as (select distinct A.cname X, B.cname Y from contestant_table as A, contestant_table as B, Q5_aux as C, Q5_aux as D where A.oid = C.cont_id AND  B.oid = D.cont_id AND C.art_id = D.art_id AND C.show_id = D.show_id AND C.cont_id <> D.cont_id AND @(C.avgscore - D.avgscore) <= 0.2);");
		st.close();
	}
	
	private List<Person> processRequest(HttpServletRequest request, HttpServletResponse response, int flag)throws ServletException, IOException{
		response.setContentType("text/html;charset=UTF-8");
		List<Person> lt = new ArrayList<Person>();
		/*
		PrintWriter out = response.getWriter();
		out.println("<html> <head> </head> <body> Result: ");
		*/
		try{
			if(isSetupDone==false){
				setupCreateViews();
				isSetupDone = true;
			}
			ResultSet rs = null;
			
			switch(flag){
			
			case 1: rs = getQuery1();
					break;
			case 2: rs = getQuery2();
					break;
			case 3: rs = getQuery3();
					break;
			case 4: rs = getQuery4();
					break;
			case 5: rs = getQuery5();
					break;
			default: ;
			}			
			
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnsNumber = rsmd.getColumnCount();   // we know we just have two columns

			while (rs.next())
    		{   Person st = new Person(rs.getString(1), rs.getString(2));
    		    lt.add(st);
    		}
			 
		 }
		catch(SQLException ex){
			ex.printStackTrace();
		}
		
		System.out.println( "Hello World!" );
		System.out.println( "Returning Person list to doPost method" );
		return lt;
		
	}
	
	public void destory(){
		if(conn != null){
			try{
				conn.close();
			}
			catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
	}
	
	
	
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
    
		String query = request.getParameter("query");
		List<Person> lt = processRequest(request,response,Integer.parseInt(query));
		
		request.setAttribute("namesList", lt);
			
		System.out.println("Reaching here");
		
		RequestDispatcher  rd = request.getRequestDispatcher("/success.jsp");
		rd.forward(request, response);
	}
 
}