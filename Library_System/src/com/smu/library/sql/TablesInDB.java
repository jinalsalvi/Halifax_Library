package com.smu.library.sql;

import java.math.BigInteger;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.smu.library.model.Table;

public class TablesInDB {

	public static LinkedHashMap<String,String> getColumns(String tableName){
		LinkedHashMap<String,String> columns = new LinkedHashMap<String,String>();
		try{
			Connection con = (Connection) MyConnection.getConnection();
			PreparedStatement ps=con.prepareStatement("SHOW COLUMNS FROM library."+tableName);
			ResultSet rs=ps.executeQuery();
			while(rs.next()){
				columns.put(rs.getString("field"), rs.getString("type"));
			}
		}catch(Exception e){
			System.out.println(e);
		}
		return columns;
	}

	public static boolean isCustomerExists(Table customer){
		boolean isCustomerExists = false;
		try{
			Connection con = (Connection) MyConnection.getConnection();
			String sql = "select * FROM library.customer where UPPER(fname)=UPPER('"+customer.getFname()+"') and UPPER(lname)=UPPER('"+customer.getLname()+"')";
			System.out.println(sql);
			PreparedStatement ps=con.prepareStatement(sql);
			ResultSet rs=ps.executeQuery();
			while(rs.next()){
				isCustomerExists = true;
			}
		}catch(Exception e){
			System.out.println(e);
		}
		return isCustomerExists;
	}

	public static boolean createNewCustomer(Table customer){
		boolean isCustomerSaved = false;
		try{
			Connection con = (Connection) MyConnection.getConnection();
			String sql = "Insert into library.customer (fname, lname, address, phone) values('"+customer.getFname()+"','"+customer.getLname()+"','"+customer.getAddress()+"','"+customer.getPhone()+"')";
			System.out.println(sql);
			Statement stmt = con.createStatement();
			int update = stmt.executeUpdate(sql);
			if(update>0){
				isCustomerSaved = true;
			}
		}catch(Exception e){
			System.out.println(e);
		}
		return isCustomerSaved;
	}

	public static String isArticleValid(Table article){
		String errorMessage = "";
		try{
			Connection con = (Connection) MyConnection.getConnection();
			String sql = "select volumeID from library.volume where MagazineID="+article.getMagazineID()+" and volumeNo='"+article.getVolumeNo()+"'"
							+ " and Year="+article.getYear();
			System.out.println(sql);
			PreparedStatement ps=con.prepareStatement(sql);
			ResultSet rs=ps.executeQuery();
			while(!rs.next()){
				ps.close();
				rs.close();
				con.close();
				errorMessage = "Invalid Magazine or Volume Number";
				return errorMessage;
			}
			
			int volumeId = rs.getInt(1);
			ps.close();
			rs.close();
			String sqlArticle = "select * FROM library.article where UPPER(title)=UPPER('"+article.getTitle()+"')"
					+ " and pages='"+article.getPages()+"' and VolumeID="+volumeId;
			System.out.println(sqlArticle);
			PreparedStatement psArticle=con.prepareStatement(sqlArticle);
			ResultSet rsArticle=psArticle.executeQuery();
			while(rsArticle.next()){
				psArticle.close();
				rsArticle.close();
				con.close();
				errorMessage = "Article already exist !!!";
				return errorMessage;
			}
			psArticle.close();
			rsArticle.close();
			String allAuthors = article.getAuthors();
			String[] author = allAuthors.split(",");
			for(int i=0;i<author.length;i++) {
				String[] authorDetails = author[i].split("~");
				String sqlArticleAuthor = "select * from library.author where UPPER(fname)=UPPER('"+authorDetails[0]+"')"
						+ "and UPPER(lname)=UPPER('"+authorDetails[1]+"')" + "and UPPER(email)=UPPER('"+authorDetails[2]+"')";
				System.out.println(sqlArticleAuthor);
				PreparedStatement stAA = con.prepareStatement(sqlArticleAuthor);
				ResultSet rsArticleAuthor = stAA.executeQuery();
				while(!rsArticleAuthor.next()) {
					//Insert Author if does not exists
					String insertAuthorSql = "Insert into library.author (fname, lname, email) values('"+authorDetails[0]+"','"+authorDetails[1]+"','"+authorDetails[2]+"')";
					System.out.println(insertAuthorSql);
					Statement insertAuthorSqlst = con.createStatement();
					insertAuthorSqlst.executeUpdate(insertAuthorSql);
					insertAuthorSqlst.close();
					break;
				}
				stAA.close();
				rsArticleAuthor.close();
			}
			
			con.close();
		}catch(Exception e){
			errorMessage = "Something Went Wrong !!!";
			System.out.println(e);
		}
		return errorMessage;
	}

	public static boolean createNewArticle(Table article){
		boolean isArticleSaved = false;
		try{
			Connection con = (Connection) MyConnection.getConnection();
			String sql = "select volumeID from library.volume where MagazineID="+article.getMagazineID()+" and volumeNo='"+article.getVolumeNo()+"'"
					+ " and Year="+article.getYear();
			System.out.println(sql);
			PreparedStatement ps=con.prepareStatement(sql);
			ResultSet rs=ps.executeQuery();
			while(rs.next()){
				int volumeId = rs.getInt(1);
				String sqlArticle = "Insert into library.article (Title, Pages, VolumeID) values('"+article.getTitle()+"','"+article.getPages()+"',"+volumeId+")";
				System.out.println(sqlArticle);
				Statement stmt1 = con.createStatement();
				int update = stmt1.executeUpdate(sqlArticle);
				
				if(update>0){
					ResultSet rs1 =stmt1.getGeneratedKeys();
					if(rs1.next()){
						//Add in article_author table
						int AID = rs1.getInt(1);
						String allAuthors = article.getAuthors();
						String[] author = allAuthors.split(",");
						for(int i=0;i<author.length;i++) {
							String[] authorDetails = author[i].split("~");							
							String sqlAuthor = "Select * from library.author where UPPER(fname)=UPPER('"+authorDetails[0]+"')"
									+ "and UPPER(lname)=UPPER('"+authorDetails[1]+"')" + "and UPPER(email)=UPPER('"+authorDetails[2]+"')";
							System.out.println(sqlAuthor);
							PreparedStatement psQuery=con.prepareStatement(sqlAuthor);
							ResultSet rsAuthorId=psQuery.executeQuery();
							if(rsAuthorId.next()) {
								int author_id = rsAuthorId.getInt(1);
								String sqlInsert = "Insert into library.article_author (ArticleID,AuthorID) values("+AID+","+author_id+")";
								System.out.println(sqlInsert);
								Statement stmtInsert = con.createStatement();
								stmtInsert.executeUpdate(sqlInsert);
								stmtInsert.close();
							}
							psQuery.close();
							rsAuthorId.close();
						}
					}
					
					isArticleSaved = true;
				}
				stmt1.close();
			}
			ps.close();
			rs.close();
			con.close();
		}catch(Exception e){
			System.out.println(e);
		}
		return isArticleSaved;
	}

	public ArrayList<Integer> isItemExists(Table transaction){
		ArrayList<Integer> invalidItems = new ArrayList<Integer>();
		try{
			Connection con = (Connection) MyConnection.getConnection();
			String item = transaction.getTotalitems();
			System.out.println("item::"+item);
			String[] items= item.split(",");
			for(int i=0;i<items.length;i++) {
				String[] singleItem = items[i].split("~");
				int item_id = Integer.parseInt(singleItem[0]);
				String sql = "select * FROM library.item where _id="+item_id;
				PreparedStatement ps=con.prepareStatement(sql);
				ResultSet rs=ps.executeQuery();
				if (!rs.next()) {
					invalidItems.add(item_id);
				}
				ps.close();
				rs.close();
			}
			con.close();
		}catch(Exception e){
			System.out.println(e);
		}
		return invalidItems;
	}
	
	public boolean isValidCustomer(Table transaction){
		boolean isValidCustomer = false;
		try{
			Connection con = (Connection) MyConnection.getConnection();
			int cid = transaction.getCid();
			System.out.println("cid::"+cid);
			String sql = "select * FROM library.customer where CID="+cid;
			PreparedStatement ps=con.prepareStatement(sql);
			ResultSet rs=ps.executeQuery();
			if (rs.next()) {
				isValidCustomer = true;
			}
			ps.close();
			rs.close();
			con.close();
		}catch(Exception e){
			isValidCustomer = false;
			System.out.println(e);
		}
		return isValidCustomer;
	}

	public boolean createTransaction(Table transaction){
		boolean isTransactionSuccess = false;
		try{
			Connection con = (Connection) MyConnection.getConnection();
			String item = transaction.getTotalitems();
			int CID = transaction.getCid();
			float totalPrice = 0;
			float twoDigitsF =0;
			DecimalFormat decimalFormat = new DecimalFormat("#.##");
			java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis()); 
			System.out.println("item::"+item+" CID:"+CID);
			String[] items= item.split(",");
			for(int i=0;i<items.length;i++) {
				String[] singleItem = items[i].split("~");
				int item_id = Integer.parseInt(singleItem[0]);
				float price = Float.parseFloat(singleItem[1]);
				
				//Update Price into item table
				String updatePriceSql = "update library.item set price ="+price+" where _id="+item_id;
				System.out.println(updatePriceSql);
				Statement updatePriceSqlStatement = con.createStatement();
				updatePriceSqlStatement.executeUpdate(updatePriceSql);
				updatePriceSqlStatement.close();
				
				//Calculate Total Price
				totalPrice = totalPrice+ price;
			}
			twoDigitsF = Float.valueOf(decimalFormat.format(totalPrice));
			String sql = "Insert into library.transaction (CID, tdate, totalprice) values("+CID+",'"+sqlDate+"',"+twoDigitsF+")";
			System.out.println(sql);
			Statement stmt = con.createStatement();
			stmt.executeUpdate(sql);
			ResultSet rs =stmt.getGeneratedKeys();

			if(rs.next()){
				//Add Items
				int TID = rs.getInt(1);
				for(int i=0;i<items.length;i++) {
					String[] singleItem = items[i].split("~");
					BigInteger item_id = new BigInteger(singleItem[0]);
					String sqlItem = "Insert into library.transactiondetails (TID,itemID) values("+TID+","+item_id+")";
					System.out.println(sqlItem);
					Statement stmt1 = con.createStatement();
					stmt1.executeUpdate(sqlItem);
					stmt1.close();
				}
				isTransactionSuccess = true;
			}
			stmt.close();
			rs.close();
			con.close();
		}catch(Exception e){
			System.out.println(e);
		}
		return isTransactionSuccess;
	}

	public String validateTransaction(Table transaction){
		String errorMessage = "";
		try{
			Connection con = (Connection) MyConnection.getConnection();
			int tid = transaction.getTid();
			String sql = "select tdate from library.transaction where tid="+tid;			
			System.out.println(sql);
			PreparedStatement ps=con.prepareStatement(sql);
			ResultSet rs=ps.executeQuery();

			if(rs.next()){				
				String sqlDaysChecks ="SELECT * FROM  library.transaction WHERE tdate BETWEEN NOW() - INTERVAL 30 DAY AND NOW() AND tid="+tid;
				System.out.println(sqlDaysChecks);
				PreparedStatement psDays =con.prepareStatement(sqlDaysChecks);
				ResultSet rsDays =psDays.executeQuery();
				if(!rsDays.next()){
					errorMessage = "Transaction ID does not present within last 30 days";
				}
				psDays.close();
				rsDays.close();
			} else {
				errorMessage = "Transaction ID does not exist";
			}
			ps.close();
			rs.close();
			con.close();
		}catch(Exception e){
			System.out.println(e);
		}
		return errorMessage;
	}

	public boolean cancelTransaction(Table transaction){
		boolean isTransactionSuccess = false;
		try{
			Connection con = (Connection) MyConnection.getConnection();
			int tid = transaction.getTid();
			String sql = "delete from library.transactiondetails where tid="+tid;	
			System.out.println(sql);
			Statement stmt = con.createStatement();
			stmt.executeUpdate(sql);
			ResultSet rs =stmt.getGeneratedKeys();

			//Remove transaction successful from transaction table
			String sqlTrx = "delete from library.transaction where tid="+tid;
			System.out.println(sqlTrx);
			Statement stmt1 = con.createStatement();
			stmt1.executeUpdate(sqlTrx);
			ResultSet rs1 =stmt1.getGeneratedKeys();
			if(rs1.next()){
				System.out.println("Cancelling Transaction Id: "+tid+"Successful");
			}
			stmt1.close();
			rs1.close();
			isTransactionSuccess = true;
			stmt.close();
			rs.close();
			con.close();
		}catch(Exception e){
			System.out.println(e);
		}
	return isTransactionSuccess;
    }

	public static List<Table> getAllRecords(String tableName){
	List<Table> tablerows = new ArrayList<Table>();
	try{
		Connection con = (Connection) MyConnection.getConnection();
		Map<String,String> columnMap = getColumns(tableName);
		PreparedStatement ps = con.prepareStatement("select * from library."+tableName);
		ResultSet rs=ps.executeQuery();
		while(rs.next()){
			Table table = new Table();
			for(Map.Entry<String, String> entry : columnMap.entrySet()){
				String key = entry.getKey();
				if(key.toLowerCase().equalsIgnoreCase("ArticleID".toLowerCase())) {
					table.setArticleId(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("Title".toLowerCase())) {
					table.setTitle(rs.getString(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("Pages".toLowerCase())) {
					table.setPages(rs.getString(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("VolumeID".toLowerCase())) {
					table.setVolumeId(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("AuthorID".toLowerCase())) {
					table.setAuthorId(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("_id".toLowerCase())) {
					table.set_id(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("lname".toLowerCase())) {
					table.setLname(rs.getString(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("fname".toLowerCase())) {
					table.setFname(rs.getString(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("email".toLowerCase())) {
					table.setEmail(rs.getString(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("address".toLowerCase())) {
					table.setAddress(rs.getString(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("CID".toLowerCase())) {
					table.setCid(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("phone".toLowerCase())) {
					table.setPhone(rs.getString(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("D_Year".toLowerCase()) || key.toLowerCase().equalsIgnoreCase("W_Year".toLowerCase()) || key.toLowerCase().equalsIgnoreCase("Year".toLowerCase())) {
					table.setYear(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("D_Month".toLowerCase()) || key.toLowerCase().equalsIgnoreCase("W_Month".toLowerCase()) || key.toLowerCase().equalsIgnoreCase("Month".toLowerCase())) {
					table.setMonth(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("D_Day".toLowerCase()) || key.toLowerCase().equalsIgnoreCase("W_Day".toLowerCase())) {
					table.setDay(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("SIN".toLowerCase())) {
					table.setSIN(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("price".toLowerCase())) {
					table.setPrice(rs.getFloat(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("name".toLowerCase())) {
					table.setName(rs.getString(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("Electicity".toLowerCase())) {
					table.setElecticity(rs.getFloat(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("Heat".toLowerCase())) {
					table.setHeat(rs.getFloat(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("Water".toLowerCase())) {
					table.setWater(rs.getFloat(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("TID".toLowerCase())) {
					table.setTid(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("discountcode".toLowerCase())) {
					table.setDiscountcode(rs.getString(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("tdate".toLowerCase())) {
					table.setTdate(rs.getDate(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("totalprice".toLowerCase())) {
					table.setTotalprice(rs.getFloat(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("itemID".toLowerCase())) {
					table.setItemID(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("MegazineID".toLowerCase())) {
					table.setMagazineID(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("volumeNo".toLowerCase())) {
					table.setVolumeNo(rs.getString(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("Hours".toLowerCase())) {
					table.setHours(rs.getInt(entry.getKey()));
				}
				if(key.toLowerCase().equalsIgnoreCase("MonthlyRent".toLowerCase())) {
					table.setMonthlyRent(rs.getFloat(entry.getKey()));
				}
			}
			tablerows.add(table);
		}
	}catch(Exception e){
		System.out.println(e);
	}
	return tablerows;
}
}
