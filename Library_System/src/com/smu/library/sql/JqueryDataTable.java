package com.smu.library.sql;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class JqueryDataTable extends HttpServlet{

	private String GLOBAL_SEARCH_TERM;
	private String COLUMN_NAME;
	private String DIRECTION;
	private int INITIAL;
	private int RECORD_SIZE;
	private String ID_SEARCH_TERM,NAME_SEARCH_TERM,PLACE_SEARCH_TERM,CITY_SEARCH_TERM,STATE_SEARCH_TERM,PHONE_SEARCH_TERM;
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {


		String[] columnNames = { "_id", "name", "place", "city", "state","phone" };

		JSONObject jsonResult = new JSONObject();
		int listDisplayAmount = 100;
		int start = 0;
		int column = 0;
		String dir = "asc";
		String tableName = request.getParameter("tableName");
		//System.out.println(tableName);
		String pageNo = request.getParameter("iDisplayStart");
		String pageSize = request.getParameter("iDisplayLength");
		String colIndex = request.getParameter("iSortCol_0");
		String sortDirection = request.getParameter("sSortDir_0");
		
		if (pageNo != null) {
			start = Integer.parseInt(pageNo);
			if (start < 0) {
				start = 0;
			}
		}
		if (pageSize != null) {
			listDisplayAmount = Integer.parseInt(pageSize);
			if (listDisplayAmount < 10 || listDisplayAmount > 50) {
				listDisplayAmount = 10;
			}
		}
		if (colIndex != null) {
			column = Integer.parseInt(colIndex);
			if (column < 0 || column > 5)
				column = 0;
		}
		if (sortDirection != null) {
			if (!sortDirection.equals("asc"))
				dir = "desc";
		}

		String colName = columnNames[column];
		int totalRecords= -1;
		try {
			totalRecords = getTotalRecordCount(tableName);
		} catch (SQLException e1) {
			e1.printStackTrace();
		}

		RECORD_SIZE = listDisplayAmount;
		GLOBAL_SEARCH_TERM = request.getParameter("sSearch");
		ID_SEARCH_TERM=request.getParameter("sSearch_0");
		NAME_SEARCH_TERM=request.getParameter("sSearch_1");
		PLACE_SEARCH_TERM=request.getParameter("sSearch_2");
		CITY_SEARCH_TERM=request.getParameter("sSearch_3");
		STATE_SEARCH_TERM=request.getParameter("sSearch_4");
		PHONE_SEARCH_TERM=request.getParameter("sSearch_5");
		COLUMN_NAME = colName;
		DIRECTION = dir;
		INITIAL = start;

		try {
			jsonResult = getDetails(totalRecords, request);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		response.setContentType("application/json");
		response.setHeader("Cache-Control", "no-store");
		PrintWriter out = response.getWriter();
		out.print(jsonResult);
	}
	
	public JSONObject getDetails(int totalRecords, HttpServletRequest request)
			throws SQLException, ClassNotFoundException {

		int totalAfterSearch = totalRecords;
		String tableName = request.getParameter("tableName");
		JSONObject result = new JSONObject();
		JSONArray array = new JSONArray();
		String searchSQL = "";

		Connection con = (Connection) MyConnection.getConnection();
		Map<String,String> columnMap = TablesInDB.getColumns(tableName);
		String sql = "select * from library."+tableName;
		if(tableName.equalsIgnoreCase("author")) {
			sql += " order by _id";
		}
		sql += " limit " + INITIAL + ", " + RECORD_SIZE;
        //System.out.println(sql);
        //for searching
		PreparedStatement stmt = con.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();

		while (rs.next()) {
			JSONArray ja = new JSONArray();
			for(Map.Entry<String, String> entry : columnMap.entrySet()){
				String key = entry.getKey();
				
				if(key.toLowerCase().equalsIgnoreCase("ArticleID".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("Title".toLowerCase())) {
					if(rs.getString(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getString(entry.getKey()));
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("Pages".toLowerCase())) {
					if(rs.getString(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getString(entry.getKey()));
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("VolumeID".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("AuthorID".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("_id".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("lname".toLowerCase())) {
					if(rs.getString(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getString(entry.getKey()));
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("fname".toLowerCase())) {
					if(rs.getString(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getString(entry.getKey()));
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("email".toLowerCase())) {
					if(rs.getString(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getString(entry.getKey()));
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("address".toLowerCase())) {
					if(rs.getString(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getString(entry.getKey()));
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("CID".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("phone".toLowerCase())) {
					if(rs.getString(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getString(entry.getKey()));
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("D_Year".toLowerCase()) || key.toLowerCase().equalsIgnoreCase("W_Year".toLowerCase()) || key.toLowerCase().equalsIgnoreCase("Year".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("D_Month".toLowerCase()) || key.toLowerCase().equalsIgnoreCase("W_Month".toLowerCase()) || key.toLowerCase().equalsIgnoreCase("Month".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("D_Day".toLowerCase()) || key.toLowerCase().equalsIgnoreCase("W_Day".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("SIN".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("price".toLowerCase())) {
					
					if(rs.getString(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getString(entry.getKey()));
					}
					/*try {
						ja.put(rs.getFloat(entry.getKey()));
					} catch (JSONException e) {
						ja.put("");
					}*/
				}
				if(key.toLowerCase().equalsIgnoreCase("name".toLowerCase())) {
					if(rs.getString(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getString(entry.getKey()));
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("Electicity".toLowerCase())) {
					try {
						ja.put(rs.getFloat(entry.getKey()));
					} catch (JSONException e) {
						ja.put("");
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("Heat".toLowerCase())) {
					try {
						ja.put(rs.getFloat(entry.getKey()));
					} catch (JSONException e) {
						ja.put("");
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("Water".toLowerCase())) {
					try {
						ja.put(rs.getFloat(entry.getKey()));
					} catch (JSONException e) {
						ja.put("");
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("TID".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("discountcode".toLowerCase())) {
					if(rs.getString(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getString(entry.getKey()));
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("tdate".toLowerCase())) {
					if(rs.getDate(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getDate(entry.getKey()));
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("totalprice".toLowerCase())) {
					
					if(rs.getString(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getString(entry.getKey()));
					}
					
					/*try {
						ja.put(rs.getFloat(entry.getKey()));
					} catch (JSONException e) {
						ja.put("");
					}*/
				}
				if(key.toLowerCase().equalsIgnoreCase("itemID".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("MagazineID".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("volumeNo".toLowerCase())) {
					if(rs.getString(entry.getKey())==null) {
						ja.put("");
					}else {
						ja.put(rs.getString(entry.getKey()));
					}
				}
				if(key.toLowerCase().equalsIgnoreCase("Hours".toLowerCase())) {
					ja.put(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("MonthlyRent".toLowerCase())) {
					try {
						ja.put(rs.getFloat(entry.getKey()));
					} catch (JSONException e) {
						ja.put("");
					}
				}
			}
			array.put(ja);	
		}
		stmt.close();
		rs.close();

		String query = "SELECT " + "COUNT(*) as count " + "FROM library." + tableName;

		//for pagination
		if (GLOBAL_SEARCH_TERM != ""||ID_SEARCH_TERM != "" || NAME_SEARCH_TERM != "" ||PLACE_SEARCH_TERM != ""||CITY_SEARCH_TERM != ""|| STATE_SEARCH_TERM != "" || PHONE_SEARCH_TERM != "" ) {
			query += searchSQL;

			
			PreparedStatement st = con.prepareStatement(query);
			ResultSet results = st.executeQuery();

			if (results.next()) {
				totalAfterSearch = results.getInt("count");
			}
			st.close();
			results.close();
			con.close();
		}
		try {
			result.put("iTotalRecords", totalRecords);
			result.put("iTotalDisplayRecords", totalAfterSearch);
			result.put("aaData", array);
		} catch (Exception e) {

		}

		return result;
	}
	
	public int getTotalRecordCount(String tableName) throws SQLException {

		int totalRecords = -1;
		String sql = "SELECT " + "COUNT(*) as count " + "FROM library." + tableName;
		Connection con = (Connection) MyConnection.getConnection();
		PreparedStatement statement = con.prepareStatement(sql);
        ResultSet resultSet = statement.executeQuery();

		if (resultSet.next()) {
			totalRecords = resultSet.getInt("count");
		}
		resultSet.close();
		statement.close();
		con.close();
		return totalRecords;
	}
}
