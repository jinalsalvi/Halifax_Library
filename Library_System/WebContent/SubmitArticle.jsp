<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="com.smu.library.sql.*,com.smu.library.model.*,java.util.*"%>
<%
	boolean isArticleExists = false;	
	boolean isArticleSaved = false;
	
	String title = request.getParameter("title");
	String pages = request.getParameter("pages");
	String volNo = request.getParameter("volNo");
	String magId = request.getParameter("magId");
	String year = request.getParameter("year");
	String totalitems = request.getParameter("totalitems");
	
	
	Table article = new Table();
	article.setAuthors(totalitems);
	article.setTitle(title);
	article.setPages(pages);
	article.setVolumeNo(volNo);
	article.setMagazineID(Integer.parseInt(magId));
	article.setYear(Integer.parseInt(year));
	
	String errorMessage = TablesInDB.isArticleValid(article);
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
			if((errorMessage == null) || (errorMessage.equalsIgnoreCase(""))){
				isArticleSaved = TablesInDB.createNewArticle(article);
			
			%>
			<div class="col-sm-8 col-centered">
				<h1 style="margin-top: 4%">Article created Successfully !!!</h1>
			</div>
			<%					
			}else{
			%>
			<div class="col-sm-8 col-centered">
				<h1 style="margin-top: 4%">ERROR : <%=errorMessage%></h1>
			</div>
			<%}%>
		</div>
	</div>
	<footer class="container-fluid text-center">
		<p>SMU</p>
	</footer>
</body>
</html>

