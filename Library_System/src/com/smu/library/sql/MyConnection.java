package com.smu.library.sql;

import java.sql.Connection;
import java.sql.DriverManager;

public class MyConnection {

	public static Connection getConnection(){
		Connection con=null;
		try{
			Class.forName("com.mysql.jdbc.Driver");
			con= DriverManager.getConnection("jdbc:mysql://localhost:3306/tutorial1","root","root");
		}catch(Exception e){
			System.out.println(e);
		}
		return con;
	}
}