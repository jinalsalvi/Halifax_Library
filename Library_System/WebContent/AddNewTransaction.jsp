<!DOCTYPE html>
<html lang="en">
<jsp:include page="Header.jsp" />
<body>
	<%@page	import="com.smu.library.sql.*,com.smu.library.model.*,java.util.*"%>
	<jsp:include page="Top_Nav.jsp" />
	<div class="container-fluid text-center">
		<div class="row content">
			<jsp:include page="Left_Nav.jsp"/>
			<div class="col-sm-8 col-centered">
				<form action="SubmitTransaction.jsp" method="POST">
					<div class="form-group row" style="margin-top: 4%">
						<div>
							<h1>Create New Transaction</h1>
						</div>
					</div>
					<div class="row" style="margin-top: 4%">
						<div class="col-xs-2 form-group">
							<input type="text" pattern="[0-9]{1,}"  class="form-control" id="customerId"
								name="customerId" value="" placeholder="Customer Id" title="Numbers only" required/>
						</div>
					</div>
					<div class="panel panel-default"  style="margin-top: 2%">
						<div class="panel-heading" style="color:#ddd; background-color:#555; font-weight: bold;">Add Items</div>
						<div class="panel-body">
							<div class="col-sm-5 nopadding">
								<div class="form-group">
									<input type="text" class="form-control" id="item_id1"
										name="item_id1" value="" placeholder="Item Id" pattern="[0-9]{1,}" title="Numbers only" required/>
								</div>
							</div>
							<div class="col-sm-5 nopadding">
								<div class="form-group">
									<input type="text" class="form-control" id="item_price1"
										name="item_price1" value="" pattern="[0-9]+(\.[0-9][0-9]?)?"  title="Digits upto two  decimal places only" placeholder="Item Price" required>
								</div>
							</div>
							<!-- <div id="item_fields"></div> -->
							<div class="col-sm-2 nopadding">
								<div class="form-group">
									<button class="btn btn-success" type="button" onclick="item_fields();"><span class="glyphicon glyphicon-plus" aria-hidden="true"></span></button>
								</div>
							</div>
							<div id="item_fields"></div>
						</div>
<!-- 						<div class="panel-footer">
							<small>Press <span class="glyphicon glyphicon-plus gs"></span>
								to add another item
							</small>
						</div> -->
					</div>
					<button type="submit" class="btn btn-primary" onclick="submitform();">Submit</button>
					<div class="clear"></div>
					<input type="hidden" name="totalfields" id="totalfields" value="1"/>
					<input type="hidden" name="totalitems" id="totalitems" value=""/>
				</form>
			</div>
		</div>
	</div>

	<footer class="container-fluid text-center"  style="margin-top: 2%">
		<p>SMU</p>
	</footer>
</body>
<script type="text/javascript">
	var item = 1;
	function item_fields() {
		item++;
		var objTo = document.getElementById('item_fields')
		var divtest = document.createElement("div");
		divtest.setAttribute("class", "form-group removeclass" + item);
		var rdiv = 'removeclass' + item;
		//divtest.innerHTML = '<div class="col-sm-5 nopadding"><div class="form-group"><input type="text" class="form-control" id="item_id'+item+'" name="item_id'+item+'" value="" placeholder="Item Id"></div></div><div class="col-sm-5 nopadding"><div class="form-group"><input type="text" class="form-control" id="item_price'+item+'" name="item_price'+item+'" value="" placeholder="Item Price"></div></div><div class="clear"></div>';
		divtest.innerHTML = '<div class="col-sm-5 nopadding"><div class="form-group"><input type="text" class="form-control dynamicitemid" id="item_id'+item+'" name="item_id'+item+'" value="" pattern="[0-9]{1,}" title="Numbers only" required placeholder="Item Id"></div></div><div class="col-sm-5 nopadding"><div class="form-group"><input type="text" class="form-control dynamicitemprice" id="item_price'+item+'" name="item_price'+item+'" value="" placeholder="Item Price" pattern="[0-9]+(\.[0-9][0-9]?)?"  title="Digits and . only" required></div></div><div class="clear"></div><div class="col-sm-2"><button class="btn btn-danger top-buffer" type="button" onclick="remove_Item_fields('+ item +');"> <span class="glyphicon glyphicon-minus" aria-hidden="true"></span> </button></div>';
		objTo.appendChild(divtest);
		$('input[name="totalfields"]').val(item);
	}
	
	function remove_Item_fields(rid) {
		$('.removeclass' + rid).remove();
		recalcId();
		item--;
		$('input[name="totalfields"]').val(item);
	}
	
	function recalcId() {
		$('.dynamicitemid').each(function(i, obj) {
			$(this).prop("id", "item_id" + (i + 2));
			$(this).prop("name", "item_id" + (i + 2));
		});
		$('.dynamicitemprice').each(function(i, obj) {
			$(this).prop("id", "item_price" + (i + 2));
			$(this).prop("name", "item_price" + (i + 2));
		});

	}
	function submitform(){
		var totalfields = document.getElementById("totalfields");
		//alert("totalfields:"+totalfields.value);
		var rows = "";
		for(var i=1;i<=totalfields.value;i++){
			var item_id = document.getElementById("item_id"+i).value;
			var item_price = document.getElementById("item_price"+i).value;
			if(rows==""){
				rows = item_id+"~"+item_price;
			}else{
				rows = rows+","+item_id+"~"+item_price;
			}
		}
		//alert("rows:"+rows);
		$('input[name="totalitems"]').val(rows);
		//$("#addNewTransaction").submit();
	}
</script>
</html>
