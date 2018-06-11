<!DOCTYPE html>
<html lang="en">
<jsp:include page="Header.jsp"/>
<body>
<%@page import="com.smu.library.sql.*,com.smu.library.model.*,java.util.*"%>
<jsp:include page="Top_Nav.jsp"/>
<div class="container-fluid text-center">    
  <div class="row content">
	<jsp:include page="Left_Nav.jsp"/>
    <div class="col-sm-8 col-centered">
		<%
		String tableName = request.getParameter("selectTable");
		LinkedHashMap<String,String> map =TablesInDB.getColumns(tableName);
		request.setAttribute("map",map);
		List<Table> tablerows = TablesInDB.getAllRecords(tableName);
		request.setAttribute("tablerows",tablerows);
		%>
		<input type="hidden" id="tableName" value=<%= tableName%>>
		<h1 style="margin-top: 4%; text-transform: uppercase"><%=tableName %></h1>
		<div>
			<table id="table_data" class="table table-striped table-bordered" style="margin-top: 4%">
				<thead class="thead-dark">
					<tr>
					<% 
						for(Map.Entry<String, String> entry : map.entrySet()){
					%>
						<th class="text-center"><%=entry.getKey()%></th>
					<% }%>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
    </div>
  </div>
</div>

<footer class="container-fluid text-center">
  <p>SMU</p>
</footer>
</body>
<style>
.dataTables_filter {
	display: none;
}
</style>
<script type="text/javascript">
	var table;
	var path = '${pageContext.request.contextPath}';
	jQuery(document).ready(function() {
	var tableName = document.getElementById("tableName");
	table = $('#table_data').dataTable({
		  	"bPaginate": true,
		  	"order": [ 0, 'asc' ],
		  	"bInfo": false,
		  	"iDisplayStart":0,
		  	"bProcessing" : true,
		 	"bServerSide" : true,
		 	"bLengthChange" : false,
		 	"bSort" : false,
		 	"sAjaxSource" : path+"/com/smu/library/sql/JqueryDataTable.java?tableName="+tableName.value
	      })
	});
</script>
</html>
