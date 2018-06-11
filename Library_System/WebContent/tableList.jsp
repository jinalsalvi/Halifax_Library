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
		<input type="text" id="tableName" value=<%= tableName%>>
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
				<%
					for(Table table : tablerows){
						%>
						<tr>
						<%
						for(Map.Entry<String, String> entry : map.entrySet()){
							if(entry.getKey().toLowerCase().equalsIgnoreCase("_id".toLowerCase())){
								%><td>
								<%=table.get_id()%>
								</td>
								<%
							}
							if(entry.getKey().toLowerCase().equalsIgnoreCase("name".toLowerCase())){
								%><td>
								<%=table.getName()%>
								</td>
								<%
							}
							if(entry.getKey().toLowerCase().equalsIgnoreCase("ArticleID".toLowerCase())){
								%><td>
								<%=table.getArticleId()%>
								</td>
								<%
							}
							if(entry.getKey().toLowerCase().equalsIgnoreCase("Title".toLowerCase())){
								%><td>
								<%=table.getTitle()%>
								</td>
								<%
							}
							if(entry.getKey().toLowerCase().equalsIgnoreCase("Pages".toLowerCase())){
								%><td>
								<%=table.getPages()%>
								</td>
								<%
							}
							if(entry.getKey().toLowerCase().equalsIgnoreCase("VolumeID".toLowerCase())){
								%><td>
								<%=table.getVolumeId()%>
								</td>
								<%
							}
						}%>
						</tr>
						<%
					}
				%>
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
</html>

<script type="text/javascript">
$(document).ready(function(){
	var tableName = document.getElementById("tableName");
	//alert(tableName.value);
	if(tableName.value!="article"){
		alert(tableName.value+"")
		$('#table_data').DataTable({
			"pageLength": 10000
		});
	}
});
</script>
