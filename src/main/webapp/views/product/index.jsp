<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
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

        input[type=number]::-webkit-inner-spin-button, input[type=number]::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-light bg-dark container">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1 text-light">Product List</span>
        </div>
    </nav>
    <div class="container mt-5">
        <div class="row">
            <c:forEach var="product" items="${productList}" varStatus="status">
                <div class="col-md-4 mb-4">
                    <div class="card" style="width: 18rem;">
                        <img src="${pageContext.request.contextPath}/assets/images/${product.image}" class="card-img-top" alt="${product.name}">
                        <div class="card-body">
                            <h5 class="card-title">${product.name}</h5>
                            <p class="card-text">Price: <fmt:formatNumber value="${product.price}" type="currency" /></p>
                            <div class="input-group mb-3">
                                <input type="number" class="form-control" value="1" min="1" aria-label="Quantity" name="quality_product">
                                <button class="btn btn-outline-secondary" type="button" data-action="increment">+</button>
                                <button class="btn btn-outline-secondary" type="button" data-action="decrement">-</button>
                            </div>
                            <a href="#" class="btn btn-primary">Add to Cart</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    <script>
        const buttons = document.querySelectorAll('.btn');
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
    </script>
</body>
</html>
