<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="com.smu.library.sql.*,com.smu.library.model.*,java.util.*"%>
<%
	boolean isCustomerExists = false;	
	boolean isCustomerSaved = false;
	
	String fname = request.getParameter("fname");
	String lname = request.getParameter("lname");
	String address = request.getParameter("address");
	String phone = request.getParameter("phone");
	
	Table customer = new Table();
	customer.setFname(fname);
	customer.setLname(lname);
	customer.setAddress(address);
	customer.setPhone(phone);
	
	isCustomerExists = TablesInDB.isCustomerExists(customer);
%>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="Header.jsp" />
<body>
	<%@page import="com.smu.library.sql.*,com.smu.library.model.*,java.util.*"%>
	<jsp:include page="Top_Nav.jsp" />
	<div class="container-fluid text-center">
		<div class="row content">
			<jsp:include page="Left_Nav.jsp"/>
			<% 
			if(!isCustomerExists){
				isCustomerSaved = TablesInDB.createNewCustomer(customer);
			%>
			<div class="col-sm-8 col-centered">
				<h1 style="margin-top: 4%">Customer record created Successfully !!!</h1>
			</div>
			<%					
			}else{
				//request.setAttribute("customer", customer);
			%>
			<form action="SubmitExistingCustomer.jsp">
				<% 
					request.getSession().setAttribute("customer", customer);
				%>
				<div class="col-sm-8 col-centered">
					<h1 style="margin-top: 4%">Customer record exists of  <%=fname %> <%=lname %></h1>
				</div>
				<div class="col-sm-8 col-centered">
					<h1 style="margin-top: 1%">Do you still want to add it as new record?</h1>
				</div>
				<div class="col-sm-8 col-centered" style="margin-top: 2%">
					<button type="submit" class="btn btn-primary">Yes</button>
					<button type="button" class="btn btn-primary" onclick="history.back()">No</button>
				</div>
			</form>
			<%}%>
		</div>
	</div>
	<footer class="container-fluid text-center">
		<p>SMU</p>
	</footer>
</body>
</html>

