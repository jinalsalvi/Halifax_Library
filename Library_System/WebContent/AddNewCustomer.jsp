<!DOCTYPE html>
<html lang="en">
<jsp:include page="Header.jsp" />
<body>
	<%@page import="com.smu.library.sql.*,com.smu.library.model.*,java.util.*"%>
	<jsp:include page="Top_Nav.jsp" />
	<div class="container-fluid text-center">
		<div class="row content">
			<jsp:include page="Left_Nav.jsp"/>
			<div class="col-sm-4 col-centered">
				<h1 style="margin-top: 4%">Add New Customer</h1>
				<form action="SubmitCustomer.jsp" class="text-left" method="POST">
				  <div class="form-group">
				    <label for="email">First Name</label>
				    <input type="text" class="form-control" id="fname" name="fname" placeholder="First Name" required>
				  </div>
				  <div class="form-group">
				    <label for="pwd">Last Name</label>
				    <input type="text" class="form-control" id="lname" name="lname" placeholder="Last Name" required>
				  </div>
				  <div class="form-group">
				    <label for="pwd">Address</label>
				    <input type="text" class="form-control" id="address" name="address" placeholder="Address" required>
				  </div>
				  <div class="form-group">
				    <label for="pwd">Phone</label>
				    <input type="text" class="form-control" id="phone" name="phone" pattern="[0-9]{1,}" title="Numbers only" placeholder="Phone" required>
				  </div>
				  <div class="form-group">
						<div class="col-sm-offset-4 col-sm-10" style="margin-top: 2%">
							<button type="submit" class="btn btn-primary">Add</button>
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
