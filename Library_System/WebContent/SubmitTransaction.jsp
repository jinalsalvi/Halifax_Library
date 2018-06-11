<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="com.smu.library.sql.*,com.smu.library.model.*,java.util.*"%>
<%
	String customerId = request.getParameter("customerId");
	String totalitems = request.getParameter("totalitems");
	
	Table transaction = new Table();
	transaction.setCid(Integer.parseInt(customerId));
	transaction.setTotalitems(totalitems);
	TablesInDB table = new TablesInDB();
	boolean isValidCustomer = table.isValidCustomer(transaction);
	ArrayList<Integer> invalidItems = table.isItemExists(transaction);
%>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="Header.jsp" />
<body>
	<jsp:include page="Top_Nav.jsp" />
	<div class="container-fluid text-center">
		<div class="row content">
			<jsp:include page="Left_Nav.jsp"/>
			<% 
			if(!isValidCustomer){
			%>
			<div class="col-sm-8 col-centered">
				<h1 style="margin-top: 4%">ERROR : Customer does not Exists in the Database !!!</h1>
			</div>
			<% 
			}else if(invalidItems.size()>0){
			%>
			<div class="col-sm-8 col-centered">
				<h1 style="margin-top: 4%">ERROR : Following Items does not Exists in the Database !!!</h1>
			</div>
			<%
				for(int i=0;i<invalidItems.size();i++){
			%>
				<div class="col-sm-8 col-centered">
					<h1 style="margin-top: 4%"><%=invalidItems.get(i)%></h1>
				</div>
			<%		
				}				
			}else{
				boolean createTransaction = table.createTransaction(transaction);
			%>
				<div class="col-sm-8 col-centered">
					<h1 style="margin-top: 4%">Transaction Successful !!!</h1>
				</div>
			<%}%>
		</div>
	</div>
	<footer class="container-fluid text-center">
		<p>SMU</p>
	</footer>
</body>
</html>

