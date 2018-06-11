<!DOCTYPE html>
<html lang="en">
<jsp:include page="Header.jsp" />
<body>
	<%@page
		import="com.smu.library.sql.*,com.smu.library.model.*,java.util.*"%>
	<jsp:include page="Top_Nav.jsp" />
	<div class="container-fluid text-center">
		<div class="row content">
			<jsp:include page="Left_Nav.jsp" />
			<div class="col-sm-5 col-centered">
				<h1 style="margin-top: 4%">Add New Article</h1>
				<form action="SubmitArticle.jsp" class="text-left" method="POST"
					id="addNewArticle">
					<div class="form-group">
						<label for="title">Title</label> <input type="text"
							placeholder="e.g. Calculi for Interaction"
							class="form-control" id="title"
							name="title" required />
					</div>
					<div class="form-group">
						<label for="pages">Pages</label> <input type="text"
							class="form-control" pattern="[0-9]+(-[0-9]*)?"
							placeholder="e.g. 707-737" id="pages" name="pages" required>
					</div>
					<div class="form-group">
						<label for="magId">Magazine ID</label> <input type="text"
							pattern="[0-9]{1,}" placeholder="e.g. 1" title="Numbers only"
							class="form-control" id="magId" name="magId" required>
					</div>
					<div class="form-group">
						<label for="volNo">Volume Number</label> <input type="text"
							class="form-control" pattern="[A-Za-z0-9]{1,}"
							placeholder="e.g. 10" id="volNo" name="volNo" required>
					</div>
					<div class="form-group">
						<label for="year">Year</label> <input type="text"
							class="form-control" placeholder="e.g. 1971" pattern="[0-9]{4}"
							title="4 digit Year only" id="year" name="year" required>
					</div>
					<label>Author Name</label>
					
					<div class="row">
						<div class="col-sm-3 top-buffer">
							<input type="text" pattern="[A-Za-z]{1,}" title="Characters only"
								class="form-control" id="authorfname1" name="authorfname1"
								value="" placeholder="First Name" required>
						</div>
						<div class="col-sm-3 top-buffer">
							<input type="text" pattern="[A-Za-z]{1,}" title="Characters only"
								class="form-control" id="authorlname1" name="authorlname1"
								value="" placeholder="Last Name" required>
						</div>
						<div class="col-sm-5 top-buffer">
							<input type="email" title="Valid Email address"
								class="form-control" id="authoremail1" name="authoremail1"
								value="" placeholder="e.g. abc@abc.com" required>
						</div>
						<!-- <div id="author_fields"></div> -->
						<div class="col-sm-1">
							<button class="btn btn-success top-buffer" type="button"
								onclick="author_fields();">
								<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
							</button>
						</div>
					</div>
					<div id="author_fields"></div>
					

					<div class="form-group">
						<div class="col-sm-offset-4 col-sm-10" style="margin-top: 4%">
							<button type="submit" class="btn btn-primary"
								onclick="submitform();">Add</button>
						</div>
					</div>
					<div class="clear"></div>
					<input type="hidden" name="totalfields" id="totalfields" value="1" />
					<input type="hidden" name="totalitems" id="totalitems" value="" />
				</form>
			</div>
		</div>
	</div>
	<footer class="container-fluid text-center" style="margin-top: 2%">
		<p>SMU</p>
	</footer>
</body>
<script type="text/javascript">
	var author = 1;
	function author_fields() {

		/* var totalfields = document.getElementById('totalfields').value;
		if(totalfields==1){
			var author1 = document.getElementById('author1').value;
			if(author1==""){
				alert("Author ID can not be blank");
				return false;
			}
		}else{
			//alert("More than one field");
			for(var i=2;i<=totalfields;i++){
				var nextauthor = document.getElementById("author"+i).value;
				//alert("author:"+nextauthor)
				if(nextauthor==""){
					alert("Author ID can not be blank");
					return false;
				}
			}	
		} */

		author++;
		var objTo = document.getElementById('author_fields');
		var divtest = document.createElement("div");
		divtest.setAttribute("class", "row removeclass" + author);
		//var rdiv = 'removeclass' + author;
		//divtest.innerHTML = '<input type="text" class="form-control" id="author'+author+'" name="author'+author+'" value="">';
		//divtest.innerHTML = '<div class="col-sm-10 top-buffer"><input type="text" pattern="[0-9]{1,}" title="Numbers only"  class="form-control dynamic" id="author'+author+'" name="author'+author+'" value="" required></div><div class="col-sm-2">	<button class="btn btn-danger top-buffer" type="button" onclick="remove_author_fields('+ author +');"> <span class="glyphicon glyphicon-minus" aria-hidden="true"></span> </button></div>';
		/* divtest.innerHTML = '<div class="col-sm-5 top-buffer"><input type="text" pattern="[A-Za-z]{1,}" title="Numbers only"  class="form-control dynamicfname" id="authorfname'+author+'" name="authorfname'+author+'" value="" placeholder="First Name" required></div><div class="col-sm-5 top-buffer">	<input type="text" pattern="[A-Za-z]{1,}" title="Numbers only"  class="form-control dynamiclname" id="authorlname'+author+'" name="authorlname'+author+'" value="" placeholder="Last Name" required></div><div class="col-sm-2"><button class="btn btn-danger top-buffer" type="button" onclick="remove_author_fields('
				+ author
				+ ');"> <span class="glyphicon glyphicon-minus" aria-hidden="true"></span> </button></div>'; */
		divtest.innerHTML = '<div class="col-sm-3 top-buffer"><input type="text" pattern="[A-Za-z]{1,}" title="Numbers only"  class="form-control dynamicfname" id="authorfname'+author+'" name="authorfname'+author+'" value="" placeholder="First Name" required></div><div class="col-sm-3 top-buffer">	<input type="text" pattern="[A-Za-z]{1,}" title="Numbers only"  class="form-control dynamiclname" id="authorlname'+author+'" name="authorlname'+author+'" value="" placeholder="Last Name" required></div><div class="col-sm-5 top-buffer"><input type="email" title="Valid Email address" class="form-control dynamicemail" id="authoremail'+author+'" name="authoremail'+author+'" value="" placeholder="e.g. abc@abc.com" required></div><div class="col-sm-1"><button class="btn btn-danger top-buffer" type="button" onclick="remove_author_fields('+ author+');"> <span class="glyphicon glyphicon-minus" aria-hidden="true"></span> </button></div>';
		objTo.appendChild(divtest);
		$('input[name="totalfields"]').val(author);
	}
	function remove_author_fields(rid) {
		$('.removeclass' + rid).remove();
		recalcId();
		author--;
		$('input[name="totalfields"]').val(author);
	}

	function submitform() {
		console.log("submitform");
		var totalfields = document.getElementById("totalfields");
		//alert("totalfields:"+totalfields.value);
		var rows = "";
		for (var i = 1; i <= totalfields.value; i++) {
			var authorfname = document.getElementById("authorfname" + i).value;
			var authorlname = document.getElementById("authorlname" + i).value;
			var authoremail = document.getElementById("authoremail" + i).value;
			if (rows == "") {
				rows = authorfname + "~" + authorlname+"~"+authoremail;
			} else {
				rows = rows + "," + authorfname + "~" + authorlname+"~"+authoremail;
			}
		}
		//alert("rows:"+rows);
		$('input[name="totalitems"]').val(rows);
		//alert(document.getElementById("totalitems").value);
		//console.log(document.getElementById("totalitems").value);
		//$("#addNewArticle").submit();
	}

	function recalcId() {
		/* $('.dynamic').each(function(i, obj) {
			//var id = $(this).attr("id","author"+(i+2));
			var id = $(this).prop("id","author"+(i+2));
			//console.log(id);
		}); */
		$('.dynamicfname').each(function(i, obj) {
			//var id = $(this).attr("id","author"+(i+2));
			var id = $(this).prop("id", "authorfname" + (i + 2));
			var name = $(this).prop("name", "authorfname" + (i + 2));
			//console.log(id);
		});
		$('.dynamiclname').each(function(i, obj) {
			//var id = $(this).attr("id","author"+(i+2));
			var id = $(this).prop("id", "authorlname" + (i + 2));
			var name = $(this).prop("name", "authorlname" + (i + 2));
			//console.log(id);
		});
		$('.dynamicemail').each(function(i, obj) {
			var id = $(this).prop("id", "authoremail" + (i + 2));
			var name = $(this).prop("name", "authoremail" + (i + 2));
		});

	}
</script>
<style>
.top-buffer {
	margin-top: 10px;
}
</style>
</html>
