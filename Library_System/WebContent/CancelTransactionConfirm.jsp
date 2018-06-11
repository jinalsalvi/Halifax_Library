<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="com.smu.library.sql.*,com.smu.library.model.*,java.util.*"%>
<%
	String transactionId = request.getParameter("transactionId");
	
	Table transaction = new Table();
	transaction.setTid(Integer.parseInt(transactionId));
	TablesInDB table = new TablesInDB();
%>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="Header.jsp" />
<%
	String transactionID = request.getParameter("transactionId");
%>
<body>
	<jsp:include page="Top_Nav.jsp" />
	<div class="container-fluid text-center">
		<div class="row content">
			<jsp:include page="Left_Nav.jsp"/>
			<% 
				String errorMessage = table.validateTransaction(transaction);
				if((errorMessage == null) || (errorMessage.equalsIgnoreCase(""))){
					boolean isTransactionSuccess = table.cancelTransaction(transaction);
					if(isTransactionSuccess){
			%>			
					<div class="col-sm-8 col-centered">
						<h1 style="margin-top: 4%">Transaction Cancelled Successfully!!!</h1>				
					</div>
			<%
				} else {
			%>
					<div class="col-sm-8 col-centered">
						<h1 style="margin-top: 4%">ERROR : Cancellation failed</h1>
					</div>
			<%
				}
			%>
			<%
				} else {
			%>
					<div class="col-sm-8 col-centered">
					<h1 style="margin-top: 4%">ERROR : <%=errorMessage%></h1>
					</div>
			<% 
				}
			%>
		</div>
	</div>
	<footer class="container-fluid text-center">
		<p>SMU</p>
	</footer>
</body>
</html>

