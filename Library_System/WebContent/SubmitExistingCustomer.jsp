<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="com.smu.library.sql.*,com.smu.library.model.*,java.util.*"%>

<%
	Table customer = (Table) request.getSession().getAttribute("customer");
	TablesInDB.createNewCustomer(customer);
%>
<!DOCTYPE html>
<html lang="en">
<title>Insert title here</title>
<jsp:include page="Header.jsp" />
<body>
	<%@page import="com.smu.library.sql.*,com.smu.library.model.*,java.util.*"%>
	<jsp:include page="Top_Nav.jsp" />
	<div class="container-fluid text-center">
		<div class="row content">
			<jsp:include page="Left_Nav.jsp"/>
			<div class="col-sm-8 col-centered">
				<h1 style="margin-top: 4%">Customer record created Successfully !!!</h1>
			</div>
		</div>
	</div>
	<footer class="container-fluid text-center">
		<p>SMU</p>
	</footer>
</body>
</html>