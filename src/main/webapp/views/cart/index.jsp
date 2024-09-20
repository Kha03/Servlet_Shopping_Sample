<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Shopping Cart</title>
<!-- Latest compiled and minified CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
body {
	display: flex;
	flex-direction: column;
	min-height: 100vh;
}

.table_center {
	margin-left: auto;
	margin-right: auto;
	width: 80%;
}

img {
	width: 100%;
	height: 15vw;
	object-fit: contain;
}

input[type=number]::-webkit-inner-spin-button, input[type=number]::-webkit-outer-spin-button
	{
	-webkit-appearance: none;
	margin: 0;
}
</style>
</head>
<body>
	<nav class="navbar navbar-light bg-dark container">
		<div class="container-fluid">
			<span class="navbar-brand mb-0 h1 text-light">Shopping Cart</span>
		</div>
	</nav>

	<div class="container mt-5">
		<h3>Your Cart</h3>

		<c:if test="${empty cartItems}">
			<p>Your cart is empty.</p>
		</c:if>

		<c:if test="${not empty cartItems}">
			<table class="table table-bordered table_center">
				<thead class="thead-dark">
					<tr>
						<th scope="col">Image</th>
						<th scope="col">Product</th>
						<th scope="col">Price</th>
						<th scope="col">Quantity</th>
						<th scope="col">Total</th>
						<th scope="col">Actions</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="item" items="${cartItems}" varStatus="status">
						<tr>
							<td><img
								src="${pageContext.request.contextPath}/assets/images/${item.product.image}"
								alt="${item.product.name}" style="width: 100px; height: 100px;"></td>
							<td>${item.product.name}</td>
							<td>$<fmt:formatNumber value="${item.product.price}"
									type="currency" /></td>
							<td>
								<div class="input-group">
									<input type="number" class="form-control"
										value="${item.quantity}" min="1" aria-label="Quantity"
										name="quantity_${item.product.id}">
									<button class="btn btn-outline-secondary btn_quantity"
										type="button" data-action="increment"
										data-id="${item.product.id}">+</button>
									<button class="btn btn-outline-secondary btn_quantity"
										type="button" data-action="decrement"
										data-id="${item.product.id}">-</button>
								</div>
							</td>
							<td>$<fmt:formatNumber
									value="${item.product.price * item.quantity}" type="currency" /></td>
							<td><button type="button" class="btn btn-danger"
									data-bs-toggle="modal" data-bs-target="#myModal"
									onClick="hanleRemoveModal('${item.product.name}', ${item.product.id})">Remove</button>
								<button type="button" class="btn btn-success"
									data-bs-toggle="modal" data-bs-target="#myModal"
									onClick="hanleUpdateModal('${item.product.name}', ${item.product.id})">Remove</button></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>

			<div class="text-end">
				<h4>
					Total Price: $
					<fmt:formatNumber value="${totalPrice}" type="currency" />
				</h4>
				<a href="${pageContext.request.contextPath}/product"
					class="btn btn-success">Proceed to Checkout</a>
			</div>
		</c:if>
	</div>
	<!-- The Modal -->
	<div class="modal fade" id="myModal">
		<div class="modal-dialog">
			<div class="modal-content">

				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">Confirm</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>

				<!-- Modal body -->
				<div class="modal-body" id="modal-body"></div>

				<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-primary"
						data-bs-dismiss="modal" id="success">Ok</button>
				</div>

			</div>
		</div>
	</div>

	<script>
        const buttons = document.querySelectorAll('.btn_quantity');
        buttons.forEach(button => {
            button.addEventListener('click', () => {
                const input = button.closest('.input-group').querySelector('input');
                let value = parseInt(input.value, 10) || 1;
                if (button.dataset.action === 'increment') {
                    value++;
                } else if (button.dataset.action === 'decrement') {
                    value = value > 1 ? value - 1 : 1;
                }
                input.value = value;
            });
        });
        function hanleRemoveModal(name, id){
        	document.getElementById('modal-body').innerHTML = `Are you sure you want to remove \${name} from your cart?`;
            document.getElementById('success').addEventListener('click', () => {
                let url = '${pageContext.request.contextPath}/cart?action=remove&id=' + id;
                window.location.href = url;
            });
        }
        function hanleUpdateModal(name, id){
        	document.getElementById('modal-body').innerHTML = `Are you sure you want to update quantity \${name} from your cart?`;
            document.getElementById('success').addEventListener('click', () => {
                let url = '${pageContext.request.contextPath}/cart?action=update&id=' + id+ '&quantity=' + document.getElementById('quantity_' + id).value;
                window.location.href = url;
            });
        }
    </script>
</body>
</html>
