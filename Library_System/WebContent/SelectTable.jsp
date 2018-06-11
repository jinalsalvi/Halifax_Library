<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Show Data</title>
</head>

<jsp:include page="Header.jsp" />
<body>
	<jsp:include page="Top_Nav.jsp" />
	<div class="container-fluid text-center">
		<div class="row content">
			<jsp:include page="Left_Nav.jsp" />
			<div class="col-sm-4 col-centered">
				<h1 style="margin-top: 4%">View Table</h1>
				<form action="TableData.jsp" class="text-left"  style="margin-top: 4%" method="POST">
<!-- 					<div class="form-group">
						<div class="col-sm-offset-2 col-sm-10">
							<label>Select the table name to see the data</label>
						</div>
					</div> -->
					<div class="form-group">
						<label for="selectTable">Table Name</label> 
						 <select class="form-control" id="selectTable" name="selectTable">
							<option value="magazine">Magazine</option>
							<option value="volume">Volume</option>
							<option value="article">Article</option>
							<option value="author">Author</option>
							<option value="article_author">Article Author</option>
							<option value="customer">Customer</option>
							<option value="employee">Employee</option>
							<option value="item">Item</option>
							<option value="transaction">Transaction</option>
							<option value="transactiondetails">Transaction Details</option>
						</select>
					</div>
					<div class="form-group">
						<div class="col-sm-offset-4 col-sm-10" style="margin-top: 2%">
							<button type="submit" class="btn btn-primary">Show Data</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<footer class="container-fluid text-center">
	<p>SMU</p>
	</footer>
</body>