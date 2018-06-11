<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page
	import="com.smu.library.sql.*,com.smu.library.model.*,java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="Header.jsp" />
<body>
	<jsp:include page="Top_Nav.jsp" />
	<div class="container-fluid text-center">
		<div class="row content">
			<jsp:include page="Left_Nav.jsp" />
			<div class="col-sm-4 col-centered">
			<h1 style="margin-top: 4%">Cancel Transaction</h1>
				<form action="CancelTransactionConfirm.jsp" class="text-left" method="POST" style="margin-top: 4%">
					<div class="form-group">
						<label for="transactionId">Transaction ID</label> 
						<input type="text" class="form-control" pattern="[0-9]{1,}" placeholder="Transaction ID"  title="Numbers only" id="transactionId" name="transactionId" required>
					</div>
					<div class="form-group">
						<div class="col-sm-offset-4 col-sm-10" style="margin-top: 2%">
							<button type="submit" class="btn btn-primary">Delete</button>
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
</html>

